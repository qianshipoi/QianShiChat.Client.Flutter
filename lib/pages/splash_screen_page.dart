import 'package:flutter/material.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
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

    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _checkToken(context);
            },
            child: const Text('check token')),
      ),
    );
  }

  _checkToken(context) async {
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