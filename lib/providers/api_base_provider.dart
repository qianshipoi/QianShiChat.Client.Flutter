import 'dart:convert';

import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/utils/global.dart';

class ApiBaseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      logger.i(map);
      Map<String, dynamic> map1 =
          map.runtimeType == "".runtimeType ? jsonDecode(map) : map;
      if (map1.containsKey("succeeded")) {
        return GlobalResponse.fromMap(map1);
      } else {
        return GlobalResponse(
            statusCode: map1['status'],
            data: map,
            succeeded: false,
            errors: map,
            timestamp: DateTime.now().millisecond);
      }
    };
    httpClient.baseUrl = ApiContants.apiBaseUrl;
    httpClient.addRequestModifier<Object?>((request) async {
      if (Global.accessToken != null) {
        request.headers['Authorization'] = 'Bearer ${Global.accessToken}';
      }
      request.headers['Client-Type'] = ApiContants.clientType;
      logger.i('requestUrl: ${request.url}');
      logger.i('requestHeaders: ${request.headers}');
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      logger.i(response.bodyString);
      if (response.statusCode == 401) {
        logout();
      }

      return response;
    });

    httpClient.maxAuthRetries = 3;
    super.onInit();
  }
}
