import 'dart:core';

import 'package:get/get.dart';
import 'package:qianshi_chat/constants.dart';
import 'package:qianshi_chat/main.dart';
import 'package:qianshi_chat/models/message.dart';
import 'package:qianshi_chat/utils/global.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ChatHubController extends GetxController {
  final httpOptions = HttpConnectionOptions(
    accessTokenFactory: () => Future(() => Global.accessToken!),
  );
  late HubConnection _hubConnection;
  var isConnection = false.obs;
  final List<Function(Message)> _listeners = [];

  ChatHubController() {
    _hubConnection = HubConnectionBuilder()
        .withUrl(signalrBaseUrl, options: httpOptions)
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({error}) {
      isConnection.value = false;
      logger.i("signalr连接断开");
    });

    _hubConnection.on('PrivateChat', (arguments) {
      logger.i(arguments);
      if (arguments?.isEmpty ?? true) return;
      dynamic messageMap = arguments![0];
      var message = Message.fromMap(messageMap);
      for (var element in _listeners) {
        element(message);
      }
    });
  }

  void addPrivateChatListener(Function(Message) listener) {
    _listeners.add(listener);
  }

  void removePrivateChatListener(Function(Message) listener) {
    _listeners.remove(listener);
  }

  Future<void> start() async {
    await _hubConnection.start();
    isConnection.value = true;
    logger.i("signalr连接成功");
  }

  Future<void> stop() async {
    await _hubConnection.stop();
    isConnection.value = false;
    logger.i("signalr连接断开");
  }
}
