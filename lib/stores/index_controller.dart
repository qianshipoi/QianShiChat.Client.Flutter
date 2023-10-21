import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/utils/sputils.dart';

class IndexController extends GetxController {
  final useSystemTheme = true.obs;
  final useDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
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
        Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      }
    });
  }

  changeThemeMode(bool isDark) {
    useDarkTheme.value = isDark;
    if (useSystemTheme.value) {
      useSystemTheme.value = false;
    } else {
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
