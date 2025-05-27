// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/provider/navigation_provider.dart';
import 'package:canser_scan/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});
  static const String id = "AboutUsPage";

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  void initState() {
    super.initState();
    // Set the navigation index to "About Us" (index 3)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).setSelectedIndex(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                'About us',
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
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'CancerScan is dedicated to empowering early skin cancer detection through advanced technology and expert care. Our app connects users with trusted dermatologists and provides reliable tools to monitor skin health. We’re committed to making a difference, one scan at a time.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Contact Us:',
                  style: TextStyle(
                    color: const Color(0xff3674B5),
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildContactRow(
                  icon: Icons.phone,
                  text: '+20 0120 231',
                  onTap: () async {
                    final Uri phoneUri = Uri(scheme: 'tel', path: '+200120231');
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch phone dialer'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                _buildContactRow(
                  icon: Icons.facebook,
                  text: 'cancerScan@facebook.com',
                  onTap: () async {
                    final Uri fbUri = Uri.parse('https://www.facebook.com');
                    if (await canLaunchUrl(fbUri)) {
                      await launchUrl(fbUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot launch Facebook')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                _buildContactRow(
                  icon: Icons.email,
                  text: 'cancerScan@gmail.com',
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'cancerScan@gmail.com',
                      queryParameters: {
                        'subject': 'Inquiry from CancerScan App',
                      },
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot launch email client'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Some reviews:',
                  style: TextStyle(
                    color: const Color(0xff3674B5),
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReviewRow(
                  screenWidth: screenWidth,
                  name: 'Fady nadi',
                  rating: 5,
                ),

                _buildReviewRow(
                  screenWidth: screenWidth,
                  name: 'Shady ahmed',
                  rating: 5,
                ),

                _buildReviewRow(
                  screenWidth: screenWidth,
                  name: 'Morad ma',
                  rating: 4,
                ),
                _buildReviewRow(
                  screenWidth: screenWidth,
                  name: 'Sandy William',
                  rating: 5,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor, size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow({
    required double screenWidth,
    required String name,
    required int rating,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.black87,
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: screenWidth * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
