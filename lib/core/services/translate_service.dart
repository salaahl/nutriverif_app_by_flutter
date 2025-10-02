import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslateService {
  static const String _apiUrl =
      'https://jokes-api-platform.onrender.com/translate';

  Future<String> getTranslation({
    required String text,
    required String lang,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'text': text, 'target_lang': 'FR'}),
          )
          .timeout(Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final raw = data['translations']?[0]?['text'] as String?;

      return raw ?? "";
    } catch (e) {
      throw Exception('Erreur lors de la traduction: $e');
    }
  }
}
