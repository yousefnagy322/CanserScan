import 'package:canser_scan/helper/constants.dart';
import 'package:canser_scan/home_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static String id = 'ChatPage';
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String geminiApiKey = 'AIzaSyC3a5Z5r333CiijVKlzoDl3DDLFQpyDqi4';

  late final _provider = GeminiProvider(
    model: GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
      systemInstruction: Content.text('''
      You are a medical assistant specializing in skin cancer and general health.
      Only answer questions related to skin cancer, dermatology, and health advice.
      If a user asks anything unrelated, politely decline to answer
      You can answer in both English and Arabic, depending on the user's input.
      Keep responses professional, clear, and accurate.
    '''),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: AppBar(
            centerTitle: true,
            title: Row(
              children: [
                Image.asset('assets/photos/bluebot.png'),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      'Chatbot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Online',
                      style: TextStyle(color: Colors.green, fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
            scrolledUnderElevation: 0,
            toolbarHeight: 40,
            leadingWidth: 90,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomePageV2.id);
              },
              icon: Image.asset('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),
      body: LlmChatView(
        provider: _provider,
        style: medicalChatStyle(),
        welcomeMessage:
            'Welcome! I can help with skin cancer info and general health advice.',
        suggestions: [
          'What are the symptoms of skin cancer?',
          'How can I protect my skin from UV damage?',
          'What foods promote skin health?',
        ],
      ),
    );
  }
}

LlmChatViewStyle medicalChatStyle() {
  return LlmChatViewStyle(
    closeMenuButtonStyle: ActionButtonStyle(
      iconColor: Colors.white,
      iconDecoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
    ),
    attachFileButtonStyle: ActionButtonStyle(
      iconDecoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
    galleryButtonStyle: ActionButtonStyle(
      iconDecoration: BoxDecoration(color: kPrimaryColor),
    ),
    cameraButtonStyle: ActionButtonStyle(
      iconDecoration: BoxDecoration(color: kPrimaryColor),
    ),

    addButtonStyle: ActionButtonStyle(
      iconColor: Colors.white,
      iconDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor,
      ),
    ),

    recordButtonStyle: ActionButtonStyle(
      iconColor: Colors.white,
      iconDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor,
      ),
    ),

    submitButtonStyle: ActionButtonStyle(
      iconColor: kPrimaryColor,
      iconDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      icon: Icons.send,
    ),

    backgroundColor: Colors.white,

    chatInputStyle: ChatInputStyle(
      backgroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.black, fontSize: 16),
      hintText: 'Ask about skin cancer',
      hintStyle: TextStyle(color: Colors.grey),
    ),

    userMessageStyle: UserMessageStyle(
      textStyle: TextStyle(color: Colors.white, fontSize: 15),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
    ),

    llmMessageStyle: LlmMessageStyle(
      icon: Icons.health_and_safety,
      iconColor: Colors.blue,
      decoration: BoxDecoration(
        color: Color(0xffEEEEEE),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
    ),
  );
}
