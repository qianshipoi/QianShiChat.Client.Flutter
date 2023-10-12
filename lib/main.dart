import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/locale/locale_message.dart';
import 'package:qianshi_chat/pages/splash_screen_page.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:qianshi_chat/stores/friend_store.dart';
import 'package:qianshi_chat/stores/index.dart';
import 'package:qianshi_chat/utils/database.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';
import 'package:qianshi_chat/utils/sputils.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => IndexStore()),
      ChangeNotifierProvider(create: (_) => CurrentUserStore()),
      ChangeNotifierProvider(create: (_) => FriendStore()),
    ], child: const MyApp()),
  );
}

Future<void> initStore() async {
  // 初始化本地存储类
  await SpUtil().init();
  // 初始化request类
  HttpUtils.init(
    baseUrl: apiBaseUrl,
  );
  // 历史记录，全局 getx全局注入，
  // await Get.putAsync(() => HistoryService().init());

  // init database
  // await Get.putAsync(() => DatabaseService().init());
  await DBProvider.db.initDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
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
