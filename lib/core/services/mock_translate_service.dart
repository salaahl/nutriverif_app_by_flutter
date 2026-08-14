import 'translate_service.dart';

class MockTranslateService extends TranslateService {
  final Map<String, String> _mockTranslations = {
    'Hello': 'Bonjour',
    'Ingredients': 'Ingrédients',
    'Nutrition facts': 'Valeurs nutritionnelles',
    'High in fat': 'Élevé en matières grasses',
    'Low in sugar': 'Faible en sucre',
  };

  @override
  Future<String> getTranslation({
    required String text,
    required String lang,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (text.trim().isEmpty) {
      return "";
    }

    if (_mockTranslations.containsKey(text)) {
      return _mockTranslations[text]!;
    }

    // Fallback générique si le texte n'est pas dans le dictionnaire
    return text;
  }
}
