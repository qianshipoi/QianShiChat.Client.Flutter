import 'package:get/get.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/providers/user_provider.dart';

class UsersController extends GetxController {
  final users = <UserInfo>[];
  final UserProvider _userProvider = Get.find();
  Future<UserInfo?> getUserById(int id) async {
    var user = users.firstWhereOrNull((element) => element.id == id);

    if (user != null) return user;
    var response = await _userProvider.getUserById(id);
    var result = response.body!;
    if (!result.succeeded) {
      return null;
    }
    user = UserInfo.fromMap(result.data);
    users.add(user);
    return user;
  }
}
