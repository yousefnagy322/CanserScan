import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
    : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  Future<String> getChatResponse(String userInput) async {
    final response = await _model.generateContent([Content.text(userInput)]);
    return response.text ?? "Sorry, I couldn't understand that.";
  }
}
