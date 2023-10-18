import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
import 'package:qianshi_chat/providers/auth_provider.dart';
import 'package:qianshi_chat/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplahScreenPage extends StatefulWidget {
  const SplahScreenPage({super.key});

  @override
  State<SplahScreenPage> createState() => _SplahScreenPageState();
}

class _SplahScreenPageState extends State<SplahScreenPage> {
  final _authProvider = Get.find<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    _checkToken(context);
    return const Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }

  _checkToken(context) async {
    var preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey(accessTokenKey)) {
      Get.off(() => const LoginPage());
      return;
    }

    // check token
    Global.accessToken = preferences.getString(accessTokenKey)!;
    var response = await _authProvider.check();
    if (!response.status.isOk) {
      Get.off(() => const LoginPage());
      return;
    }
    // var response = await HttpUtils.get('Auth');
    // var result = GlobalResponse.fromMap(response.body!);

    var token = response.headers!['x-access-token']!;
    var user = UserInfo.fromJson(json.encode(response.body!.data));
    initLoginInfo(token, user);
    Get.off(() => const HomePage());
  }
}
