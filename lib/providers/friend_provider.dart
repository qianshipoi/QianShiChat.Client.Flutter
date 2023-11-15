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

  Future<Response<GlobalResponse>> setAlias(int id, String alias) {
    return put<GlobalResponse>('Friend/$id/Alias', {'alias': alias});
  }

  Future<Response<GlobalResponse>> getFriendGroups() {
    return get<GlobalResponse>('friend/groups');
  }

  Future<Response<GlobalResponse>> addGroup(String name) {
    return post<GlobalResponse>('friend/groups', {'name': name});
  }

  Future<Response<GlobalResponse>> renameGroup(int id, String name) {
    return put<GlobalResponse>('friend/groups/$id', {'name': name});
  }

  Future<Response<GlobalResponse>> removeGroup(int id) {
    return delete<GlobalResponse>('friend/groups/$id');
  }

  Future<Response<GlobalResponse>> sortGroup(List<int> ids) {
    return put<GlobalResponse>('friend/groups/sort', {'state': ids});
  }

  Future<Response<GlobalResponse>> moveFriendToGroup(int id, int groupId) {
    return put<GlobalResponse>('friend/$id/move', {'groupId': groupId});
  }
}
