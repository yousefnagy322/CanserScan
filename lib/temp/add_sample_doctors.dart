import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AddSampleDoctorsPage extends StatefulWidget {
  const AddSampleDoctorsPage({super.key});

  @override
  State<AddSampleDoctorsPage> createState() => _AddSampleDoctorsPageState();
}

class _AddSampleDoctorsPageState extends State<AddSampleDoctorsPage> {
  bool _isLoading = false;

  Future<void> _addSampleDoctors() async {
    setState(() {
      _isLoading = true;
    });

    final random = Random();
    final locations = [
      {
        "governorate": "Cairo",
        "region": "Nasr City",
        "latitude": 30.0551,
        "longitude": 31.3460,
      },
      {
        "governorate": "Cairo",
        "region": "Maadi",
        "latitude": 29.9590,
        "longitude": 31.2575,
      },
      {
        "governorate": "Giza",
        "region": "Dokki",
        "latitude": 30.0368,
        "longitude": 31.2089,
      },
      {
        "governorate": "Giza",
        "region": "6th of October",
        "latitude": 29.9381,
        "longitude": 30.9140,
      },
      {
        "governorate": "Alexandria",
        "region": "Smouha",
        "latitude": 31.2140,
        "longitude": 29.9443,
      },
      {
        "governorate": "Alexandria",
        "region": "Sidi Gaber",
        "latitude": 31.2218,
        "longitude": 29.9370,
      },
      {
        "governorate": "Luxor",
        "region": "East Bank",
        "latitude": 25.6872,
        "longitude": 32.6396,
      },
      {
        "governorate": "Aswan",
        "region": "City Center",
        "latitude": 24.0889,
        "longitude": 32.8998,
      },
      {
        "governorate": "Mansoura",
        "region": "Downtown",
        "latitude": 31.0409,
        "longitude": 31.3785,
      },
      {
        "governorate": "Suez",
        "region": "Port Tawfiq",
        "latitude": 29.9668,
        "longitude": 32.5498,
      },
    ];

    final firstNames = [
      'Ahmed',
      'Mohamed',
      'Fatima',
      'Aisha',
      'Hassan',
      'Youssef',
      'Sara',
      'Laila',
      'Omar',
      'Nour',
    ];
    final lastNames = [
      'Hussein',
      'Ali',
      'Mostafa',
      'Khalil',
      'Saad',
      'Ezz',
      'Salem',
      'Fathy',
      'Gamal',
      'Zaki',
    ];
    final specialties = [
      'Dermatologist',
      'Oncologist',
      'General Practitioner',
      'Pediatrician',
      'Surgeon',
    ];
    final clinicPrefixes = ['Health', 'Care', 'Skin', 'Family', 'Wellness'];
    final clinicSuffixes = ['Clinic', 'Center', 'Hospital', 'Practice'];
    final workingHoursOptions = [
      'Mon-Fri, 9 AM - 5 PM',
      'Sun-Thu, 10 AM - 6 PM',
      'Mon-Sat, 8 AM - 4 PM',
      'Daily, 11 AM - 7 PM',
    ];
    final bioTemplates = [
      "has over [years] years of experience in [specialty].",
      "specializes in [specialty] and patient care.",
      "is a renowned [specialty] with a focus on advanced treatments.",
      "has been practicing [specialty] for [years] years.",
    ];

    for (int i = 0; i < 10; i++) {
      final location = locations[i % locations.length];
      final firstName = firstNames[random.nextInt(firstNames.length)];
      final lastName = lastNames[random.nextInt(lastNames.length)];
      final specialty = specialties[random.nextInt(specialties.length)];
      final clinicName =
          '${clinicPrefixes[random.nextInt(clinicPrefixes.length)]} ${clinicSuffixes[random.nextInt(clinicSuffixes.length)]}';
      final years = random.nextInt(20) + 5;
      final bioTemplate = bioTemplates[random.nextInt(bioTemplates.length)]
          .replaceFirst('[years]', years.toString())
          .replaceFirst('[specialty]', specialty.toLowerCase());
      final rating = 3.5 + random.nextDouble() * 1.5;

      final doctorData = {
        "image":
            "https://firebasestorage.googleapis.com/v0/b/cancer-scan.firebasestorage.app/o/doctors%20images%2Fdefault%20doctor.jpg?alt=media&token=743b465a-92a8-464b-bbee-d092a0c94f9b",
        "name": "Dr. $firstName $lastName",
        "governorate": location["governorate"],
        "region": location["region"],
        "latitude": location["latitude"],
        "longitude": location["longitude"],
        "specialty": specialty,
        "contact":
            "+20 1${random.nextInt(9) + 1}${random.nextInt(10000000).toString().padLeft(7, '0')}",
        "clinicName": clinicName,
        "workingHours":
            workingHoursOptions[random.nextInt(workingHoursOptions.length)],
        "bio": "Dr. $firstName $lastName $bioTemplate",
        "rating": rating,
      };

      try {
        await FirebaseFirestore.instance
            .collection('dermatologists')
            .add(doctorData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Added: ${doctorData['name']}")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error adding ${doctorData['name']}: $e")),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finished adding 10 sample doctors!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          'Add Sample Doctors',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.08,
          ),
          colors: const [Color(0xff12748B), Color(0xff051F25)],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Press the button below to add 10 sample doctors to the database.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff12748B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: _isLoading ? null : _addSampleDoctors,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Add 10 Sample Doctors',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
