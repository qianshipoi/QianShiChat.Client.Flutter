import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/locale_message.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/chat_page.dart';
import 'package:qianshi_chat/pages/contacts/group_notice_page.dart';
import 'package:qianshi_chat/pages/contacts/new_friend_page.dart';
import 'package:qianshi_chat/pages/home_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
import 'package:qianshi_chat/pages/splash_screen_page.dart';
import 'package:qianshi_chat/pages/test_page.dart';
import 'package:qianshi_chat/pages/user_profile_page.dart';
import 'package:qianshi_chat/providers/attachment_provider.dart';
import 'package:qianshi_chat/providers/auth_provider.dart';
import 'package:qianshi_chat/providers/avatar_provider.dart';
import 'package:qianshi_chat/providers/chat_provider.dart';
import 'package:qianshi_chat/providers/friend_provider.dart';
import 'package:qianshi_chat/providers/group_provider.dart';
import 'package:qianshi_chat/providers/user_provider.dart';
import 'package:qianshi_chat/stores/chat_hub_controller.dart';
import 'package:qianshi_chat/stores/current_user_controller.dart';
import 'package:qianshi_chat/utils/database.dart';
import 'package:qianshi_chat/utils/global.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';
import 'package:qianshi_chat/utils/sputils.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  filter: null,
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

late SharedPreferences preferences;

void logout() {
  preferences.remove(accessTokenKey);
  preferences.remove(userInfoKey);
  Get.currentRoute == "/login"
      ? null
      : Get.off(() => const LoginPage(), routeName: '/login');
}

void initLoginInfo(String token, UserInfo userInfo) {
  preferences.setString(accessTokenKey, token);
  preferences.setString(userInfoKey, userInfo.toJson());
  Global.accessToken = token;
  Get.find<CurrentUserController>().current.value = userInfo;
  Get.find<ChatHubController>().start();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  runApp(const MyApp());
}

Future<void> initStore() async {
  // 初始化本地存储类
  await SpUtil().init();
  // 初始化request类
  HttpUtils.init(
    baseUrl: ApiContants.apiBaseUrl,
  );

  preferences = await SharedPreferences.getInstance();

  Get.put(CurrentUserController());
  Get.put(ChatHubController());
  Get.lazyPut(() => AttachmentProvider(), fenix: true);
  Get.lazyPut(() => AuthProvider(), fenix: true);
  Get.lazyPut(() => AvatarProvider(), fenix: true);
  Get.lazyPut(() => ChatProvider(), fenix: true);
  Get.lazyPut(() => FriendProvider(), fenix: true);
  Get.lazyPut(() => GroupProvider(), fenix: true);
  Get.lazyPut(() => UserProvider(), fenix: true);

  // initMeeduPlayer();
  await DBProvider.db.initDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/chat": (context) => const ChatPage(),
        "/user_profile": (context) => const UserProfilePage(),
        "/new_friend": (context) => const NewFriendPage(),
        "/group_notice": (context) => const GroupNoticePage(),
      },
      translations: LocaleMessage(),
      locale: const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplahScreenPage(),
    );
  }
}
