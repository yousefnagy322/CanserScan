import 'package:canser_scan/Pages/Doctors/doctor_details_page.dart';
import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  static String id = 'MapPage';
  double? doctorLatfdp;
  double? doctorLngfdp;

  MapPage({this.doctorLatfdp, this.doctorLngfdp});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialPosition = LatLng(29.3763, 31.1927); // Default position
  Set<Marker> markers = {};
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();
  LatLng? userLatLng;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Always fetch user location to calculate distances and populate doctor list
    getUserLocation();
    // If doctor coordinates are provided, set initial position to them
    if (widget.doctorLatfdp != null && widget.doctorLngfdp != null) {
      initialPosition = LatLng(widget.doctorLatfdp!, widget.doctorLngfdp!);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  Future<void> getUserLocation() async {
    setState(() {
      _isLoading = true;
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
          setState() {
            _isLoading = false;
          }

          ;
          return;
        }
      }

      var currentLocation = await location.getLocation();
      userLatLng = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      fetchDermatologists(); // Fetch doctors based on user location

      // Only move to user location if no doctor coordinates are provided
      if (widget.doctorLatfdp == null || widget.doctorLngfdp == null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(userLatLng!, 14),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void fetchDermatologists() {
    FirebaseFirestore.instance
        .collection('dermatologists')
        .snapshots()
        .listen(
          (snapshot) {
            if (userLatLng == null) return; // Wait for user location

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
                      snippet:
                          '${data['governorate']}, ${data['region']}' ??
                          'No address available',
                    ),
                    onTap: () {
                      widget.doctorLatfdp = data['latitude'];
                      widget.doctorLngfdp = data['longitude'];
                    },
                  ),
                );

                Map<String, dynamic> doctorData = {
                  'id': doc.id,
                  'name': data['name'] ?? '',
                  'latitude': data['latitude'] ?? 0.0,
                  'longitude': data['longitude'] ?? 0.0,
                  'governorate': data['governorate'] ?? '',
                  'region': data['region'] ?? '',
                  'image':
                      data['image'] ?? 'assets/doctor_photo/default_doctor.jpg',
                  'specialty': data['specialty'] ?? 'Not specified',
                  'contact': data['contact'] ?? 'Not available',
                  'clinicName': data['clinicName'] ?? 'Not specified',
                  'workingHours': data['workingHours'] ?? 'Not specified',
                  'bio': data['bio'] ?? 'No bio available',
                  'rating': (data['rating'] ?? 0.0).toDouble(),
                  'address':
                      '${data['governorate']}, ${data['region']}' ??
                      'No address available',
                  'distance': distance,
                };
                tempDoctors.add(doctorData);
              }
            }

            tempDoctors.sort((a, b) => a['distance'].compareTo(b['distance']));

            setState(() {
              doctors = tempDoctors;
              filteredDoctors = tempDoctors;
              markers = newMarkers;
              _isLoading = false;
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
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: AppBar(
            centerTitle: true,
            title: Text(
              'Find Doctor',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
              ),
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/photos/dark_back_arrow.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                if (widget.doctorLatfdp != null &&
                    widget.doctorLngfdp != null) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    moveToDoctor(widget.doctorLatfdp!, widget.doctorLngfdp!);
                  });
                }
              },
              markers: markers,
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          Positioned(
            top: screenHeight * 0.02,
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
          Positioned(
            top: screenHeight * 0.12,
            right: screenWidth * 0.04,
            child: FloatingActionButton(
              heroTag: 'mylocation',
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryColor,
              onPressed: () async {
                if (userLatLng != null) {
                  moveToDoctor(userLatLng!.latitude, userLatLng!.longitude);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            top: screenHeight * 0.20,
            right: screenWidth * 0.04,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryColor,
              onPressed: () async {
                if (widget.doctorLatfdp != null &&
                    widget.doctorLngfdp != null) {
                  _launchGoogleMaps(widget.doctorLatfdp!, widget.doctorLngfdp!);
                }
              },
              child: const Icon(Icons.route_outlined),
            ),
          ),
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
              : Positioned(
                left: 15,
                bottom: screenHeight * 0.195,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Nearest Doctors',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.02,
            child: Container(
              height: screenHeight * 0.18,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child:
                  filteredDoctors.isEmpty
                      ? const Center(
                        child: Text(
                          'No doctors available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          var doctorData = filteredDoctors[index];
                          // Convert map to Doctor object
                          Doctor doctor = Doctor(
                            image: doctorData['image'],
                            name: doctorData['name'],
                            governorate: doctorData['governorate'],
                            region: doctorData['region'],
                            lat: doctorData['latitude'],
                            lng: doctorData['longitude'],
                            specialty: doctorData['specialty'],
                            contact: doctorData['contact'],
                            clinicName: doctorData['clinicName'],
                            workingHours: doctorData['workingHours'],
                            bio: doctorData['bio'],
                            rating: doctorData['rating'],
                          );
                          return GestureDetector(
                            onTap: () {
                              moveToDoctor(
                                doctorData['latitude'],
                                doctorData['longitude'],
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.5,
                              margin: EdgeInsets.all(screenWidth * 0.02),
                              padding: EdgeInsets.all(screenWidth * 0.02),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          doctorData['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),

                                      // New button with same onTap as home page doctor card
                                      IconButton(
                                        icon: const Icon(
                                          Icons.info,
                                          color: kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      DoctorDetailsPage(
                                                        doctor: doctor,
                                                      ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0),
                                  Text(
                                    doctorData['address'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${(doctorData['distance'] / 1000).toStringAsFixed(2)} km away',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.033,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.teal[700],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.directions,
                                          color: kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          _launchGoogleMaps(
                                            doctorData['latitude'],
                                            doctorData['longitude'],
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
