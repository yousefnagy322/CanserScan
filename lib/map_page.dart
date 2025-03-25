import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
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
    }
  }

  void fetchDermatologists() {
    FirebaseFirestore.instance.collection('dermatologists').snapshots().listen((
      snapshot,
    ) {
      if (userLatLng == null) return; // Ensure user location is available

      List<Map<String, dynamic>> tempDoctors = [];
      Set<Marker> newMarkers = {};

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          double distance = Geolocator.distanceBetween(
            userLatLng!.latitude, // Use userLatLng instead of initialPosition
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
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE3F7F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff56EACF),
                Color(0xff194D59),
              ], // Change colors as needed
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            centerTitle: true,
            title: Text(
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
                  Future.delayed(Duration(milliseconds: 500), () {
                    moveToDoctor(widget.doctorLat!, widget.doctorLng!);
                  });
                } else {
                  getUserLocation();
                }
              },
              markers: markers,
            ),
          ),

          // Search Field
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
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
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Custom My Location Button
          Positioned(
            top: 70,
            right: 15,
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryColor,
              onPressed: () async {
                await getUserLocation();
              },
              child: Icon(Icons.my_location),
            ),
          ),

          // Horizontal Doctor List Overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Container(
              height: 120, // Adjust height as needed
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Set horizontal scrolling
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  var doctor = filteredDoctors[index];
                  return GestureDetector(
                    onTap: () {
                      moveToDoctor(doctor['latitude'], doctor['longitude']);
                    },
                    child: Container(
                      width: 180, // Adjust width as needed
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            doctor['address'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${doctor['distance'].toStringAsFixed(2)} meters away',
                            style: TextStyle(fontSize: 12, color: Colors.teal),
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

// moveToDoctor(doctor['latitude'], doctor['longitude'])
