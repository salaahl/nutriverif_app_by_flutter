class FakeTranslateService {
  static const translatedResponse = {
    'translations': [
      {'text': 'Bonjour'},
    ],
  };

  Future<String> getTranslation({
    required String text,
    required String lang,
  }) async {
    try {
      final data = translatedResponse;
      final raw = data['translations']?[0]['text'];

      return raw ?? "";
    } catch (e) {
      throw Exception('Erreur lors de la traduction: $e');
    }
  }
}
