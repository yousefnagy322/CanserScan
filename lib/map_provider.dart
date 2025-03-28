// map_provider.dart
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapProvider with ChangeNotifier {
  LatLng _initialPosition = const LatLng(29.3763, 31.1927); // Default position
  LatLng? _userLatLng;
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  bool _isLoading = false;
  String? _errorMessage;

  LatLng get initialPosition => _initialPosition;
  LatLng? get userLatLng => _userLatLng;
  Set<Marker> get markers => _markers;
  List<Map<String, dynamic>> get filteredDoctors => _filteredDoctors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final Location _location = Location();

  Future<void> getUserLocation(GoogleMapController mapController) async {
    try {
      _setLoading(true);
      _setError(null);

      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          _setError('Location services are disabled.');
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _setError('Location permissions are denied.');
          return;
        }
      }

      var currentLocation = await _location.getLocation();
      _userLatLng = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      _initialPosition = _userLatLng!;

      // Add a marker for the user's location
      _markers.removeWhere(
        (marker) => marker.markerId.value == "user_location",
      );
      _markers.add(
        Marker(
          markerId: const MarkerId("user_location"),
          position: _userLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "Your Location"),
        ),
      );

      // Animate the camera to the user's location (original behavior)
      mapController.animateCamera(CameraUpdate.newLatLngZoom(_userLatLng!, 14));

      notifyListeners();
    } catch (e) {
      print("Error getting location: $e");
      _setError('Error getting location: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchDermatologists() async {
    if (_userLatLng == null) return;

    try {
      _setLoading(true);
      _setError(null);

      var snapshot =
          await FirebaseFirestore.instance.collection('dermatologists').get();
      List<Map<String, dynamic>> tempDoctors = [];
      Set<Marker> newMarkers = {..._markers}; // Preserve user location marker

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          double distance = Geolocator.distanceBetween(
            _userLatLng!.latitude,
            _userLatLng!.longitude,
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

          tempDoctors.add({
            'id': doc.id,
            'name': data['name'],
            'latitude': data['latitude'],
            'longitude': data['longitude'],
            'address': data['address'] ?? 'No address available',
            'distance': distance,
          });
        }
      }

      tempDoctors.sort((a, b) => a['distance'].compareTo(b['distance']));

      _markers = newMarkers;
      _doctors = tempDoctors;
      _filteredDoctors = tempDoctors;
      notifyListeners();
    } catch (e) {
      _setError('Error fetching dermatologists: $e');
    } finally {
      _setLoading(false);
    }
  }

  void filterDoctors(String query) {
    _filteredDoctors =
        _doctors.where((doctor) {
          return doctor['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
