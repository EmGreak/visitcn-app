import 'dart:convert';
import 'package:http/http.dart' as http;

/// MiniMax API Client for VisitCN App
/// Doc: https://www.minimaxi.chat/document/Texture/Functions/V1/text/chatcompletion_v2
class MiniMaxClient {
  static const String _baseUrl = 'https://api.minimaxi.com/v1';
  
  // MiniMax API Key (from TOOLS.md)
  static const String _apiKey = 'sk-cp-FsoI_MVQHJ3ONsrFvVcQJ_iL6XQ9CkldLbIxi3osxwiQenUVTjA2AggnAZfqmWMgxyXCiomxDHbA-2m-fVS9_sq_pjMKbxzRI0EymbZl74medLbpaoXlNwA';
  
  /// Send chat message and get AI response
  /// [messages] - List of message maps with 'role' and 'content'
  ///   role: 'user' | 'assistant' | 'system'
  /// [model] - Model name, default 'MiniMax-Text-01'
  static Future<String> chat({
    required List<Map<String, String>> messages,
    String model = 'MiniMax-Text-01',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/text/chatcompletion_v2'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final choices = data['choices'] as List?;
      if (choices != null && choices.isNotEmpty) {
        return choices[0]['messages'] as String? ?? 'No response';
      }
      return 'No response';
    } else {
      throw MiniMaxException(
        'API Error: ${response.statusCode}',
        response.body,
      );
    }
  }

  /// Build a travel assistant system prompt
  static List<Map<String, String>> buildTravelAssistantMessages(
    String userMessage, {
    String? city,
    String? language,
  }) {
    final systemPrompt = '''
You are VisitCN AI, a smart travel assistant for foreigners visiting China.

Your capabilities:
1. **Itinerary Planning** - Create detailed day-by-day travel plans based on purpose, duration, preferences, and location
2. **Visa Guidance** - Explain Chinese visa types, application process, and required documents
3. **Payment Guide** - Help with Alipay, WeChat Pay, cash exchange, and international cards
4. **Transportation** - Subway, taxi, high-speed rail, airplane, and city navigation
5. **Emergency Help** - Hospital recommendations, police contacts, insurance info
6. **Cultural Tips** - Chinese customs, dining etiquette, and cultural notes
7. **Food Recommendations** - Local specialties with dietary restriction awareness

Response format guidelines:
- Use structured tables for itineraries (Time | Activity | Location)
- Use bullet points for tips and lists
- Add emoji to make it readable
- Be concise but complete
- When recommending food, always note if it's spicy 🌶️
- For行程 (itinerary), always include estimated time and location

User context (if provided):
- City: ${city ?? 'Not specified'}
- Language preference: ${language ?? 'English'}

Respond in the same language as the user.
''';

    return [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userMessage},
    ];
  }
}

class MiniMaxException implements Exception {
  final String message;
  final String? details;
  
  MiniMaxException(this.message, [this.details]);
  
  @override
  String toString() => 'MiniMaxException: $message${details != null ? '\n$details' : ''}';
}
