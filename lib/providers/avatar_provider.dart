import 'package:get/get.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class AvatarProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> defaults(int count,
      {int beforeId = 0}) async {
    return get<GlobalResponse>('avatar/defaults', query: {
      'count': count.toString(),
      'beforeId': beforeId.toString(),
    });
  }
}
