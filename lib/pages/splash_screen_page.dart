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
import 'package:lottie/lottie.dart';

class SplahScreenPage extends StatefulWidget {
  const SplahScreenPage({super.key});

  @override
  State<SplahScreenPage> createState() => _SplahScreenPageState();
}

class _SplahScreenPageState extends State<SplahScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final _authProvider = Get.find<AuthProvider>();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(AssetsContants.chatLottie,
          repeat: false,
          controller: _controller,
          animate: true,
          height: MediaQuery.of(context).size.height, onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward().whenComplete(() => _checkToken(context));
      }),
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
    var token = response.headers![ApiContants.accessTokenHeaderKey]!;
    var user = UserInfo.fromJson(json.encode(response.body!.data));
    initLoginInfo(token, user);
    Get.off(() => const HomePage());
  }
}
