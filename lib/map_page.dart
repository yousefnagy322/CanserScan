import 'package:canser_scan/home_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();

    fetchDermatologists();
  }

  /// Get the user's current location
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

      setState(() {
        initialPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        markers.add(
          Marker(
            markerId: MarkerId("currentLocation"),
            position: initialPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(title: "You are here"),
          ),
        );
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(initialPosition, 14),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  /// Fetch dermatologists from Firestore in real-time
  void fetchDermatologists() {
    FirebaseFirestore.instance.collection('dermatologists').snapshots().listen((
      snapshot,
    ) {
      Set<Marker> newMarkers = {};

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
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
        }
      }

      setState(() {
        markers = newMarkers;
      });
    });
  }

  /// Move to the selected doctor's location
  void moveToDoctor(double lat, double lng) {
    print("Moving to Doctor at: $lat, $lng");

    LatLng doctorPosition = LatLng(lat, lng);

    // markers.add(
    //   Marker(
    //     markerId: MarkerId("selectedDoctor"),
    //     position: doctorPosition,
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //     infoWindow: InfoWindow(title: "Selected Doctor"),
    //   ),
    // );

    setState(() {});

    // Ensure mapController is initialized before using it
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(doctorPosition, 16),
      );
    } else {
      print("mapController is not initialized yet!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.pop(context);
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;

          // Ensure doctor location is moved to AFTER the map is ready
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
    );
  }
}
