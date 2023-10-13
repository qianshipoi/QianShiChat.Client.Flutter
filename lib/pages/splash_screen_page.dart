import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:qianshi_chat/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplahScreenPage extends StatefulWidget {
  const SplahScreenPage({super.key});

  @override
  State<SplahScreenPage> createState() => _SplahScreenPageState();
}

class _SplahScreenPageState extends State<SplahScreenPage> {
  @override
  Widget build(BuildContext context) {
    _checkToken(context);
    return const Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }

  _checkToken(context) async {
    var preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(accessTokenKey)) {
      Global.accessToken = preferences.getString(accessTokenKey)!;
      var userStr = preferences.getString(userInfoKey);
      var user = UserInfo.fromJson(userStr!);
      Get.put(() => CurrentUserController(userInfo: user));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }
}
