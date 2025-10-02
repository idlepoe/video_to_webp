import 'package:get/get.dart';
import 'en.dart';
import 'ko.dart';
import 'es.dart';
import 'zh.dart';
import 'hi.dart';
import 'ja.dart';
import 'id.dart';
import 'ru.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enTranslations,
        'ko': koTranslations,
        'es': esTranslations,
        'zh': zhTranslations,
        'hi': hiTranslations,
        'ja': jaTranslations,
        'id': idTranslations,
        'ru': ruTranslations,
      };
}
