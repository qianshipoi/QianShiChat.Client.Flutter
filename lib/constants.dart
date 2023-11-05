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

class RouterContants {
  static const settings = "/settings";
  static const login = "/login";
  static const register = "/register";
  static const chat = "/chat";
  static const userProfile = "/user_profile";
  static const friendNotice = "/friend_notice";
  static const groupNotice = "/group_notice";
  static const applyFriend = "/apply_friend";
  static const applyGroup = "/apply_group";
  static const newGroup = "/new_group";
  static const search = "/search";
}

class AssetsContants {
  static const chatLottie = "assets/lottie/chat.json";
}
