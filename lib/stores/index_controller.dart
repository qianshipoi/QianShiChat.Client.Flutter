// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/utils/sputils.dart';

class IndexController extends GetxController {
  final useSystemTheme = true.obs;
  final useDarkTheme = false.obs;
  final languages = [
    Language(displayName: "english", languageCode: "en", countryCode: "US"),
    Language(displayName: "简体中文", languageCode: "zh", countryCode: "CN")
  ];
  final currentLanguage = Rx<Language?>(null);
  final currentLocale = Rx<Locale?>(Get.locale);

  @override
  void onInit() {
    super.onInit();
    initTheme();
    initLocale();
  }

  void initLocale() {
    ever(currentLanguage, (callback) {
      logger.i("locale: $callback");
      if (callback == null) return;
      var currentLocale = Get.locale;
      if (currentLocale != null &&
          currentLocale.languageCode == callback.languageCode &&
          currentLocale.countryCode == callback.countryCode) {
        return;
      }
      this.currentLocale.value =
          Locale(callback.languageCode, callback.countryCode);
      Get.updateLocale(this.currentLocale.value!);
      SpUtil().setJSON("current_locale", callback.toJson());
    });

    var localeMap = SpUtil().getJSON("current_locale");
    if (localeMap == null) {
      currentLanguage.value = languages.first;
      return;
    }
    try {
      var language = Language.fromJson(localeMap);
      var l = languages.firstWhereOrNull((element) =>
          element.languageCode == language.languageCode &&
          element.countryCode == language.countryCode);
      if (l != null) {
        currentLanguage.value = l;
      }
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  void initTheme() {
    useSystemTheme.value = SpUtil().getBool("useSystemTheme") ?? true;
    useDarkTheme.value = SpUtil().getBool("useDarkTheme") ?? Get.isDarkMode;
    Get.changeThemeMode(useSystemTheme.value
        ? ThemeMode.system
        : useDarkTheme.value
            ? ThemeMode.dark
            : ThemeMode.light);

    ever(useSystemTheme, (isSystemTheme) {
      SpUtil().setBool("useSystemTheme", isSystemTheme);
      if (isSystemTheme) {
        Get.changeThemeMode(ThemeMode.system);
      } else {
        Get.changeThemeMode(
            useDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
      }
    });
    ever(useDarkTheme, (isDark) {
      logger.i("useDarkTheme: $isDark");
      SpUtil().setBool("useDarkTheme", isDark);
      if (useSystemTheme.value) {
        useSystemTheme.value = false;
      } else {
        if (Get.isDarkMode == isDark) return;
        Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      }
    });
  }
}

class Language {
  String displayName;
  String languageCode;
  String countryCode;
  Language({
    required this.displayName,
    required this.languageCode,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'languageCode': languageCode,
      'countryCode': countryCode,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      displayName: map['displayName'] as String,
      languageCode: map['languageCode'] as String,
      countryCode: map['countryCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) =>
      Language.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Language(displayName: $displayName, languageCode: $languageCode, countryCode: $countryCode)';
}
