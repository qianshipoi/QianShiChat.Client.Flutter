import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:qianshi_chat/locale/globalization.dart';

class LocaleMessage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          Globalization.english: "english",
        },
        "zh_CN": {
          Globalization.english: "英语",
        },
      };
}
