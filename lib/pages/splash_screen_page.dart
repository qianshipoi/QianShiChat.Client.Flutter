import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplahScreenPage extends StatefulWidget {
  const SplahScreenPage({super.key});

  @override
  State<SplahScreenPage> createState() => _SplahScreenPageState();
}

class _SplahScreenPageState extends State<SplahScreenPage> {
  @override
  Widget build(BuildContext context) {
    context.watch<CurrentUserStore>().init();

    _checkToken(context);
    return const Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }

  _checkToken(context) async {
    logger.i('check token');
    var preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(accessTokenKey)) {
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
