import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/pages/splash_screen_page.dart';
import 'package:qianshi_chat/stores/current_store.dart';
import 'package:qianshi_chat/stores/friend_store.dart';
import 'package:qianshi_chat/stores/index.dart';

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

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => IndexStore()),
      ChangeNotifierProvider(create: (_) => CurrentUserStore()),
      ChangeNotifierProvider(create: (_) => FriendStore()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplahScreenPage(),
    );
  }
}
