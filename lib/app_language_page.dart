import 'package:flutter/material.dart';

class AppLanguagePage extends StatelessWidget {
  const AppLanguagePage({super.key});

  static const String id = 'AppLanguagePage';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // List of languages (only Arabic and English)
    final List<String> languages = ['Arabic', 'English'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C4B4), Color(0xFF0288D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Language Title
            Text(
              'App Language',
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Suggested Subtitle
            Text(
              'Suggested',
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Language List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3C34), // Dark teal background
                  borderRadius: BorderRadius.circular(10),
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
                              color: Colors.white24,
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
            ),
          ],
        ),
      ),
    );
  }
}
