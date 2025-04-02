import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String image;
  final String name;
  final String governorate;
  final String region;
  final double lat;
  final double lng;
  final String specialty; // New field
  final String contact; // New field
  final String clinicName; // New field
  final String workingHours; // New field
  final String bio; // New field
  final double rating; // New field

  Doctor({
    required this.image,
    required this.name,
    required this.governorate,
    required this.region,
    required this.lat,
    required this.lng,
    required this.specialty,
    required this.contact,
    required this.clinicName,
    required this.workingHours,
    required this.bio,
    required this.rating,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Doctor(
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      governorate: data['governorate'] ?? '',
      region: data['region'] ?? '',
      lat: data['latitude'] ?? 0.0,
      lng: data['longitude'] ?? 0.0,
      specialty: data['specialty'] ?? 'Not specified',
      contact: data['contact'] ?? 'Not available',
      clinicName: data['clinicName'] ?? 'Not specified',
      workingHours: data['workingHours'] ?? 'Not specified',
      bio: data['bio'] ?? 'No bio available',
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}
