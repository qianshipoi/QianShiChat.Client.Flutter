import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
import 'package:qianshi_chat/utils/global.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';
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

    if (!preferences.containsKey(accessTokenKey)) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
      return;
    }

    // check token
    Global.accessToken = preferences.getString(accessTokenKey)!;
    var response = await HttpUtils.get('Auth');
    var result = GlobalResponse.fromMap(response.data);

    var token = response.headers['x-access-token']!.first;
    var user = UserInfo.fromJson(json.encode(result.data));
    initLoginInfo(token, user);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }
}
