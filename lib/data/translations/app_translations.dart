import 'package:get/get.dart';
import 'en.dart';
import 'ko_kr.dart';
import 'es.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enTranslations,
        'ko': koTranslations,
        'es': esTranslations,
      };
}
