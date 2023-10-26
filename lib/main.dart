import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/locale_message.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/pages/apply_friend_page.dart';
import 'package:qianshi_chat/pages/apply_group_page.dart';
import 'package:qianshi_chat/pages/chat_page.dart';
import 'package:qianshi_chat/pages/contacts/group_notice_page.dart';
import 'package:qianshi_chat/pages/contacts/new_friend_page.dart';
import 'package:qianshi_chat/pages/login_page.dart';
import 'package:qianshi_chat/pages/settings_page.dart';
import 'package:qianshi_chat/pages/splash_screen_page.dart';
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
import 'package:qianshi_chat/stores/index_controller.dart';
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
  Get.find<ChatHubController>().stop();
  preferences.remove(accessTokenKey);
  preferences.remove(userInfoKey);
  Get.currentRoute == RouterContants.login
      ? null
      : Get.off(() => const LoginPage(), routeName: RouterContants.login);
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
  await SpUtil().init();
  HttpUtils.init(
    baseUrl: ApiContants.apiBaseUrl,
  );

  preferences = await SharedPreferences.getInstance();

  Get.put(CurrentUserController());
  Get.put(ChatHubController());
  Get.put(IndexController());
  Get.lazyPut(() => AttachmentProvider(), fenix: true);
  Get.lazyPut(() => AuthProvider(), fenix: true);
  Get.lazyPut(() => AvatarProvider(), fenix: true);
  Get.lazyPut(() => ChatProvider(), fenix: true);
  Get.lazyPut(() => FriendProvider(), fenix: true);
  Get.lazyPut(() => GroupProvider(), fenix: true);
  Get.lazyPut(() => UserProvider(), fenix: true);

  await DBProvider.db.initDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routes: {
        RouterContants.chat: (context) => const ChatPage(),
        RouterContants.userProfile: (context) => const UserProfilePage(),
        RouterContants.newFriend: (context) => const NewFriendPage(),
        RouterContants.groupNotice: (context) => const GroupNoticePage(),
        RouterContants.settings: (context) => const SettingsPage(),
        RouterContants.applyFriend: (context) => const ApplyFriendPage(),
        RouterContants.applyGroup: (context) => const ApplyGroupPage(),
      },
      translations: LocaleMessage(),
      locale: Get.find<IndexController>().currentLocale.value,
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplahScreenPage(),
    );
  }
}
