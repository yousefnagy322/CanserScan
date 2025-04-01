import 'package:canser_scan/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'map_page.dart';
import 'navigation_provider.dart';
import 'widgets/bottom_nav_bar.dart';

class Doctor {
  final String image;
  final String name;
  final String governorate;
  final String region;
  final double lat;
  final double lng;

  Doctor({
    required this.image,
    required this.name,
    required this.governorate,
    required this.region,
    required this.lat,
    required this.lng,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Doctor(
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      governorate: data['governorate'] ?? '',
      region: data['region'] ?? '',
      lat: data['latitude'],
      lng: data['longitude'],
    );
  }
}

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});
  static const String id = 'DoctorsPage';

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String selectedGovernorate = 'All';
  String selectedRegion = 'All';
  List<String> regions = ['All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(4);
    });
  }

  void updateRegions(List<Doctor> doctors) {
    final filteredRegions =
        doctors
            .where(
              (doc) =>
                  selectedGovernorate == 'All' ||
                  doc.governorate == selectedGovernorate,
            )
            .map((doc) => doc.region)
            .toSet()
            .toList();

    if (regions.length != filteredRegions.length + 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          regions = ['All', ...filteredRegions];
          selectedRegion = 'All';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const HomeBottomNavBar(),
      appBar: AppBar(
        title: GradientText(
          'Doctors',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.08,
          ),
          colors: const [Color(0xff12748B), Color(0xff051F25)],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedGovernorate,
                    onChanged: (value) {
                      setState(() {
                        selectedGovernorate = value!;
                        selectedRegion = 'All';
                      });
                    },
                    items:
                        [
                              'All',
                              'Cairo',
                              'Giza',
                              'Alexandria',
                            ] // Add more governorates
                            .map(
                              (gov) => DropdownMenuItem(
                                value: gov,
                                child: Text(gov),
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedRegion,
                    onChanged: (value) {
                      setState(() {
                        selectedRegion = value!;
                      });
                    },
                    items:
                        regions
                            .map(
                              (reg) => DropdownMenuItem(
                                value: reg,
                                child: Text(reg),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('dermatologists')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  }
                  final doctors =
                      snapshot.data!.docs
                          .map((doc) => Doctor.fromFirestore(doc))
                          .toList();

                  updateRegions(doctors);

                  final filteredDoctors =
                      doctors
                          .where(
                            (doctor) =>
                                (selectedGovernorate == 'All' ||
                                    doctor.governorate ==
                                        selectedGovernorate) &&
                                (selectedRegion == 'All' ||
                                    doctor.region == selectedRegion),
                          )
                          .toList();

                  return ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return doctorCard(
                        context,
                        doctor,
                        screenWidth,
                        screenHeight,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorCard(
    BuildContext context,
    Doctor doctor,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: screenHeight * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            doctor.image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            height: screenHeight * 0.1,
            width: screenWidth * 0.18,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                doctor.name,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/photos/location.png',
                    height: screenWidth * 0.04, // Responsive icon size
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${doctor.region}, ${doctor.governorate}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
              fixedSize: Size(
                screenWidth * 0.16,
                screenHeight * 0.04,
              ), // Responsive button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              print(doctor.lat);
              print(doctor.lng);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MapPage(
                        doctorLatfdp: doctor.lat,
                        doctorLngfdp: doctor.lng,
                      ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Map',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Responsive font size
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image.asset('assets/photos/mapicon.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
