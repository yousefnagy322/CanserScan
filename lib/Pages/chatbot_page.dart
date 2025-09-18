import 'package:canser_scan/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Define the GeminiProvider as a top-level constant
const String geminiApiKey =
    ''; 

final _provider = GeminiProvider(
  model: GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: geminiApiKey,
    systemInstruction: Content.text('''
      You are a medical assistant specializing in skin cancer and general health.
      Only answer questions related to skin cancer, dermatology, and health advice.
      If a user asks anything unrelated, politely decline to answer.
      You are a medical assistant specializing in skin cancer and general health, capable of speaking any language, converting voice to text, and analyzing images; answer only dermatology and health-related questions in English or Arabic professionally and accurately.
    '''),
  ),
);

// Define the chat style as a constant
const LlmChatViewStyle medicalChatStyle = LlmChatViewStyle(
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
    iconDecoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
  ),
  recordButtonStyle: ActionButtonStyle(
    iconColor: Colors.white,
    iconDecoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
  ),
  submitButtonStyle: ActionButtonStyle(
    iconColor: kPrimaryColor,
    iconDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  static const String id = 'ChatPage';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: const Scaffold(appBar: ChatAppBar(), body: ChatBody()),
    );
  }
}

// AppBar Widget
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/photos/bluebot.svg'),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(height: 1, thickness: 1, color: kPrimaryColor),
          ),
          scrolledUnderElevation: 0,
          toolbarHeight: 40,
          leadingWidth: 90,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              // Close keyboard and navigate back
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            icon: const Image(
              image: AssetImage('assets/photos/dark_back_arrow.png'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Body Widget
class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LlmChatView(
      provider: _provider,
      style: medicalChatStyle,
      welcomeMessage:
          'Welcome! I can help with skin cancer info and general health advice.',
      suggestions: const [
        'What are the symptoms of skin cancer?',
        'How can I protect my skin from UV damage?',
        'What foods promote skin health?',
      ],
    );
  }
}
