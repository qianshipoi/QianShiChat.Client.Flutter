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
      return GlobalResponse.fromMap(map);
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
      if (response.statusCode == 401) {
        logout();
      }
      logger.i(response.bodyString);
      return response;
    });

    httpClient.maxAuthRetries = 3;
    super.onInit();
  }
}
