import 'package:get/get.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/models/userinfo.dart';
import 'package:qianshi_chat/utils/http/http_util.dart';

class UsersController extends GetxController {
  final users = <UserInfo>[];

  Future<UserInfo?> getUserById(int id) async {
    var user = users.firstWhereOrNull((element) => element.id == id);

    if (user != null) return user;

    var response = await HttpUtils.get('user/$id');
    var result = GlobalResponse.fromMap(response.data);
    if (!result.succeeded) {
      return null;
    }
    user = UserInfo.fromMap(result.data);
    users.add(user);
    return user;
  }
}
