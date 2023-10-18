import 'package:get/get.dart';
import 'package:qianshi_chat/models/enums/apply_status.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class FriendProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> getFriends() {
    return get<GlobalResponse>('friend');
  }

  Future<Response<GlobalResponse>> getFriendApplies() {
    return get<GlobalResponse>('FriendApply/Pending');
  }

  Future<Response<GlobalResponse>> clearAllAppies() {
    return delete<GlobalResponse>('FriendApply/clear');
  }

  Future<Response<GlobalResponse>> deleteApply(int id) {
    return delete<GlobalResponse>('FriendApply/$id');
  }

  Future<Response<GlobalResponse>> approval(int id, ApplyStatus status) {
    return put<GlobalResponse>('FriendApply/$id/Approval/${status.number}', {});
  }
}
