import 'package:canser_scan/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import cached_network_image
import 'navigation_provider.dart';
import 'widgets/bottom_nav_bar.dart';
import 'doctor_details_page.dart';
import 'models/doctor.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});
  static const String id = 'DoctorsPage';

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String selectedGovernorate = 'All';
  String selectedRegion = 'All';
  String searchQuery = '';
  List<String> regions = ['All'];
  List<String> governorates = ['All'];
  List<Doctor> allDoctors = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(4);
    });
    _fetchGovernorates();
  }

  Future<void> _fetchGovernorates() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('dermatologists').get();
      final uniqueGovernorates =
          snapshot.docs
              .map(
                (doc) =>
                    (doc.data() as Map<String, dynamic>)['governorate']
                        as String,
              )
              .toSet()
              .toList();
      setState(() {
        governorates = ['All', ...uniqueGovernorates];
      });
    } catch (e) {
      print('Error fetching governorates: $e');
      setState(() {
        governorates = ['All', 'Cairo', 'Giza', 'Alexandria'];
      });
    }
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

    if (regions.length != filteredRegions.length + 1 ||
        !_listsAreEqual(regions.skip(1).toList(), filteredRegions)) {
      regions = ['All', ...filteredRegions];
      if (!regions.contains(selectedRegion)) {
        selectedRegion = 'All';
      }
    }
  }

  bool _listsAreEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const HomeBottomNavBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GradientText(
            'Doctors',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.08,
            ),
            colors: const [Color(0xff12748B), Color(0xff051F25)],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              height: 1,
              thickness: 1,
              color: kPrimaryColor, // Customize color
            ),
          ),
          scrolledUnderElevation: 0,
          toolbarHeight: 40,
          leadingWidth: 90,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search doctors by name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Governorate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      customDropdown(
                        value: selectedGovernorate,
                        items: governorates,
                        onChanged: (value) {
                          setState(() {
                            selectedGovernorate = value!;
                            selectedRegion = 'All';
                            updateRegions(allDoctors);
                          });
                        },
                        hint: 'Select Governorate',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Region',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      customDropdown(
                        value: selectedRegion,
                        items: regions,
                        onChanged: (value) {
                          setState(() {
                            selectedRegion = value!;
                          });
                        },
                        hint: 'Select Region',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('dermatologists')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  }

                  allDoctors =
                      snapshot.data!.docs
                          .map((doc) => Doctor.fromFirestore(doc))
                          .toList();

                  updateRegions(allDoctors);

                  final filteredDoctors =
                      allDoctors
                          .where(
                            (doctor) =>
                                (selectedGovernorate == 'All' ||
                                    doctor.governorate ==
                                        selectedGovernorate) &&
                                (selectedRegion == 'All' ||
                                    doctor.region == selectedRegion) &&
                                (searchQuery.isEmpty ||
                                    doctor.name.toLowerCase().contains(
                                      searchQuery,
                                    )),
                          )
                          .toList();

                  return ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      DoctorDetailsPage(doctor: doctor),
                            ),
                          );
                        },
                        child: doctorCard(
                          context,
                          doctor,
                          screenWidth,
                          screenHeight,
                        ),
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

  Widget customDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xff12748B)),
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        menuMaxHeight: 300,
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
        hint: Text(hint),
      ),
    );
  }

  Widget doctorCard(
    BuildContext context,
    Doctor doctor,
    double screenWidth,
    double screenHeight,
  ) {
    return Card(
      color: Colors.grey[100],
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: doctor.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                height: screenHeight * 0.1,
                width: screenWidth * 0.18,
                placeholder:
                    (context, url) => Container(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.18,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.18,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        'assets/photos/location.png',
                        height: screenWidth * 0.04, // Responsive icon size
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${doctor.region}, ${doctor.governorate}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
