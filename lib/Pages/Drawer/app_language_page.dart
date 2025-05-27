import 'package:canser_scan/helper/constants.dart';
import 'package:flutter/material.dart';

class AppLanguagePage extends StatelessWidget {
  const AppLanguagePage({super.key});

  static const String id = 'AppLanguagePage';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // List of languages (only Arabic and English)
    final List<String> languages = ['English', 'Arabic'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            // App Language Title
            Center(
              child: Text(
                'App Language',
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Suggested Subtitle
            Text(
              'Suggested',
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.w600,
                color: Color(0xff545050),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Language List
            Container(
              height: screenHeight * 0.2,
              decoration: BoxDecoration(
                color: kPrimaryColor, // Dark teal background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            languages[index],
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            // Handle language selection here
                            // For example, update app language and pop
                            print('Selected: ${languages[index]}');
                          },
                        ),
                        if (index < languages.length - 1)
                          const Divider(
                            color: Colors.white,
                            height: 1,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
