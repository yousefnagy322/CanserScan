import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  static String id = 'MapPage';
  final double? doctorLat;
  final double? doctorLng;

  MapPage({this.doctorLat, this.doctorLng});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialPosition = LatLng(29.3763, 31.1927);
  Set<Marker> markers = {};
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();
  LatLng? userLatLng;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  void dispose() {
    searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  Future<void> getUserLocation() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      var currentLocation = await location.getLocation();
      userLatLng = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      fetchDermatologists();
      setState(() {
        initialPosition = userLatLng!;

        // Add a marker for the user's location
        markers.removeWhere(
          (marker) => marker.markerId.value == "user_location",
        );
      });

      mapController.animateCamera(CameraUpdate.newLatLngZoom(userLatLng!, 14));
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void fetchDermatologists() {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    FirebaseFirestore.instance
        .collection('dermatologists')
        .snapshots()
        .listen(
          (snapshot) {
            if (userLatLng == null) {
              setState(() {
                _isLoading = false;
              });
              return; // Ensure user location is available
            }

            List<Map<String, dynamic>> tempDoctors = [];
            Set<Marker> newMarkers = {};

            for (var doc in snapshot.docs) {
              var data = doc.data();
              if (data.containsKey('latitude') &&
                  data.containsKey('longitude')) {
                double distance = Geolocator.distanceBetween(
                  userLatLng!.latitude,
                  userLatLng!.longitude,
                  data['latitude'],
                  data['longitude'],
                );

                newMarkers.add(
                  Marker(
                    markerId: MarkerId(doc.id),
                    position: LatLng(data['latitude'], data['longitude']),
                    infoWindow: InfoWindow(
                      title: data['name'],
                      snippet: data['address'] ?? 'No address available',
                    ),
                  ),
                );

                Map<String, dynamic> doctorData = {
                  'id': doc.id,
                  'name': data['name'],
                  'latitude': data['latitude'],
                  'longitude': data['longitude'],
                  'address': data['address'] ?? 'No address available',
                  'distance': distance,
                };
                tempDoctors.add(doctorData);
              }
            }

            // Sort doctors by distance from user
            tempDoctors.sort((a, b) => a['distance'].compareTo(b['distance']));

            setState(() {
              markers = newMarkers;
              doctors = tempDoctors;
              filteredDoctors = tempDoctors;
              _isLoading = false; // Hide loading indicator
            });
          },
          onError: (e) {
            print("Error fetching dermatologists: $e");
            setState(() {
              _isLoading = false;
            });
          },
        );
  }

  void filterDoctors(String query) {
    List<Map<String, dynamic>> tempFiltered =
        doctors.where((doctor) {
          return doctor['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredDoctors = tempFiltered;
    });
  }

  void moveToDoctor(double lat, double lng) {
    LatLng doctorPosition = LatLng(lat, lng);
    mapController.animateCamera(CameraUpdate.newLatLngZoom(doctorPosition, 16));
  }

  void _launchGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffE3F7F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff56EACF), Color(0xff194D59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            centerTitle: true,
            title: const Text(
              'Find Dermatologist',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomePageV2.id);
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Google Map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // Disable default button
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                if (widget.doctorLat != null && widget.doctorLng != null) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    moveToDoctor(widget.doctorLat!, widget.doctorLng!);
                  });
                } else {
                  getUserLocation();
                }
              },
              markers: markers,
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),

          // Search Field
          Positioned(
            top: screenHeight * 0.02, // Responsive positioning
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterDoctors,
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Custom My Location Button
          Positioned(
            top: screenHeight * 0.12, // Responsive positioning
            right: screenWidth * 0.04,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryColor,
              onPressed: () async {
                await getUserLocation();
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          // Horizontal Doctor List Overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.02, // Responsive positioning
            child: Container(
              height: screenHeight * 0.18, // Responsive height
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  var doctor = filteredDoctors[index];
                  return GestureDetector(
                    onTap: () {
                      moveToDoctor(doctor['latitude'], doctor['longitude']);
                    },
                    child: Container(
                      width: screenWidth * 0.5, // Responsive width
                      margin: EdgeInsets.all(
                        screenWidth * 0.02,
                      ), // Responsive margin
                      padding: EdgeInsets.all(
                        screenWidth * 0.02,
                      ), // Responsive padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ), // Responsive spacing
                          Text(
                            doctor['address'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.03, // Responsive font size
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ), // Responsive spacing
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(doctor['distance'] / 1000).toStringAsFixed(2)} km away', // Convert meters to km
                                style: TextStyle(
                                  fontSize:
                                      screenWidth *
                                      0.03, // Responsive font size
                                  color: Colors.teal,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.directions,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  _launchGoogleMaps(
                                    doctor['latitude'],
                                    doctor['longitude'],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
