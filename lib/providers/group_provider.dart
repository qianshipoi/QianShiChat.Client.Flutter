import 'package:get/get_connect/http/src/response/response.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class GroupProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> getAll() {
    return get<GlobalResponse>('group');
  }

  Future<Response<GlobalResponse>> create(List<int> friendIds,
      {String? name, int? avatarId}) {
    return post<GlobalResponse>(
        'group', {'friendIds': friendIds, 'name': name, 'avatarId': avatarId});
  }

  Future<Response<GlobalResponse>> join(int id, String remark) {
    return post<GlobalResponse>('group/$id/join', {
      'remark': remark,
    });
  }

  Future<Response<GlobalResponse>> del(int id) {
    return delete<GlobalResponse>('group/$id');
  }

  Future<Response<GlobalResponse>> leave(int id) {
    return delete<GlobalResponse>('group/$id/leave');
  }

  Future<Response<GlobalResponse>> pending(int size, {int beforeLastTime = 0}) {
    return get<GlobalResponse>('group/apply/pending', query: {
      'size': size.toString(),
      'beforeLastTime': beforeLastTime.toString(),
    });
  }

  Future<Response<GlobalResponse>> search(String searchText) {
    return get<GlobalResponse>('group/search', query: {
      'search': searchText,
    });
  }

  Future<Response<GlobalResponse>> getMembers(int groupId,
      {required int page, required int size}) {
    return get<GlobalResponse>('group/$groupId/members', query: {
      'page': page.toString(),
      'size': size.toString(),
    });
  }

  Future<Response<GlobalResponse>> getGroup(int groupId) {
    return get<GlobalResponse>('group/$groupId');
  }
}
