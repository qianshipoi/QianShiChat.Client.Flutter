import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class AuthProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> login(String account, String password) {
    return post<GlobalResponse>('auth', {
      'account': account,
      'password': md5.convert(utf8.encode(password)).toString(),
    });
  }

  Future<Response<GlobalResponse>> check() {
    return get<GlobalResponse>('auth');
  }
}
