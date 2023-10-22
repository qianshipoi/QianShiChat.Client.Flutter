import 'dart:io';

const appTitle = "QianShiChat";

const accessTokenKey = "token";
const userInfoKey = "current_user";

class ApiContants {
  static const baseUrl = "https://chat-api.kuriyama.top/";
  static const apiBaseUrl = "${baseUrl}api/";
  static const signalrBaseUrl = "${baseUrl}Hubs/Chat";
  static String clientType = "flutter_${Platform.operatingSystem}";
  static const accessTokenHeaderKey = "x-access-token";
}
