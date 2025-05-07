import 'package:canser_scan/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
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
  String selectedSpecialty = 'All';
  String selectedSort = 'Default';
  String searchQuery = '';
  List<String> regions = ['All'];
  List<String> governorates = ['All'];
  List<String> specialties = ['All'];
  List<String> sortOptions = [
    'Default',
    'Nearest',
    'Name (A-Z)',
    'Name (Z-A)',
    'Rating',
  ];
  List<Doctor> allDoctors = [];
  Location location = Location();
  LatLng? userLatLng;
  bool _showFilters = false; // State variable to control filter visibility

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
    _fetchSpecialties();
    _getUserLocation();
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

  Future<void> _fetchSpecialties() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('dermatologists').get();
      final uniqueSpecialties =
          snapshot.docs
              .map(
                (doc) =>
                    (doc.data() as Map<String, dynamic>)['specialty']
                        as String? ??
                    'Unknown',
              )
              .toSet()
              .toList();
      setState(() {
        specialties = ['All', ...uniqueSpecialties];
      });
    } catch (e) {
      print('Error fetching specialties: $e');
      setState(() {
        specialties = ['All', 'Dermatology', 'Oncology'];
      });
    }
  }

  Future<void> _getUserLocation() async {
    if (userLatLng != null) return;

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
        userLatLng = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
    } catch (e) {
      print("Error getting location: $e");
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

  void _resetFilters() {
    setState(() {
      selectedGovernorate = 'All';
      selectedRegion = 'All';
      selectedSpecialty = 'All';
      selectedSort = 'Default';
      searchQuery = '';
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Update the selectedIndex to the previous page's index
        Provider.of<NavigationProvider>(context, listen: false).popIndex();
        return true; // Allow the pop to proceed
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const HomeBottomNavBar(),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(color: kPrimaryColor),
            child: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Doctors',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.08,
                ),
              ),
              scrolledUnderElevation: 0,
              toolbarHeight: 40,
              leadingWidth: 90,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged:
                          (value) =>
                              setState(() => searchQuery = value.toLowerCase()),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        hintText: 'Search doctors by name...',
                        prefixIcon: Icon(Icons.search, color: kPrimaryColor),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _showFilters ? Icons.filter_alt_off : Icons.filter_alt,
                      color: kPrimaryColor,
                    ),
                    onPressed: _toggleFilters,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: _showFilters,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Governorate',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
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
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.medical_services,
                                    size: 16,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Specialty',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              customDropdown(
                                value: selectedSpecialty,
                                items: specialties,
                                onChanged:
                                    (value) => setState(
                                      () => selectedSpecialty = value!,
                                    ),
                                hint: 'Select Specialty',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.map,
                                    size: 16,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Region',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              customDropdown(
                                value: selectedRegion,
                                items: regions,
                                onChanged:
                                    (value) =>
                                        setState(() => selectedRegion = value!),
                                hint: 'Select Region',
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.sort,
                                    size: 16,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sort${selectedSort != 'Default' ? ': $selectedSort' : ''}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              customDropdown(
                                value: selectedSort,
                                items: sortOptions,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSort = value!;
                                  });
                                },
                                hint: 'Select Sort Option',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _resetFilters,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: kPrimaryColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            'Reset Filters',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
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

                    var filteredDoctors =
                        allDoctors
                            .where(
                              (doctor) =>
                                  (selectedGovernorate == 'All' ||
                                      doctor.governorate ==
                                          selectedGovernorate) &&
                                  (selectedRegion == 'All' ||
                                      doctor.region == selectedRegion) &&
                                  (selectedSpecialty == 'All' ||
                                      doctor.specialty == selectedSpecialty) &&
                                  (searchQuery.isEmpty ||
                                      doctor.name.toLowerCase().contains(
                                        searchQuery,
                                      )),
                            )
                            .toList();

                    if (selectedSort == 'Nearest' && userLatLng != null) {
                      filteredDoctors.sort(
                        (a, b) => Geolocator.distanceBetween(
                          userLatLng!.latitude,
                          userLatLng!.longitude,
                          a.lat,
                          a.lng,
                        ).compareTo(
                          Geolocator.distanceBetween(
                            userLatLng!.latitude,
                            userLatLng!.longitude,
                            b.lat,
                            b.lng,
                          ),
                        ),
                      );
                    } else if (selectedSort == 'Name (A-Z)') {
                      filteredDoctors.sort((a, b) => a.name.compareTo(b.name));
                    } else if (selectedSort == 'Name (Z-A)') {
                      filteredDoctors.sort((a, b) => b.name.compareTo(a.name));
                    } else if (selectedSort == 'Rating') {
                      filteredDoctors.sort(
                        (a, b) => b.rating.compareTo(a.rating),
                      );
                    }

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
        border: Border.all(width: 1.5, color: Colors.grey[300]!),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    item == value
                                        ? Color(0xff12748B)
                                        : Colors.black87,
                                fontWeight:
                                    item == value
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (item == value)
                            Icon(Icons.check, size: 16, color: kPrimaryColor),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
        hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailsPage(doctor: doctor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.transparent, Color(0xff56EACF).withOpacity(0.15)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
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
                            height: screenWidth * 0.04,
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
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff56EACF).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doctor.specialty,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '★ ${doctor.rating.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.amber[700],
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
        ),
      ),
    );
  }
}
