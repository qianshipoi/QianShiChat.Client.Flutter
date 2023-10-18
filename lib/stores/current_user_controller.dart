import 'package:get/get.dart';
import 'package:qianshi_chat/models/userinfo.dart';

class CurrentUserController extends GetxController {
  Rx<UserInfo?> current = Rx<UserInfo?>(null);
}
