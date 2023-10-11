import 'package:flutter/material.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUserStore extends ChangeNotifier {
  UserInfo? _current;
  late SharedPreferences _preferences;
  UserInfo current() {
    if (_current != null) {
      return _current!;
    }

    var userInfoStr = _preferences.getString(userInfoKey);
    _current = UserInfo.fromJson(userInfoStr!);
    return _current!;
  }

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }
}
