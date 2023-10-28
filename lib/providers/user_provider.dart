import 'package:get/get.dart';
import 'package:qianshi_chat/models/enums/apply_status.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class UserProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> register({
    required int defaultAvatarId,
    required String account,
    required String password,
    required String nickname,
  }) {
    return post<GlobalResponse>('user', {
      'defaultAvatarId': defaultAvatarId,
      'account': account,
      'password': password,
      'nickname': nickname,
    });
  }

  Future<Response<GlobalResponse>> getUserById(int userId) {
    return get<GlobalResponse>('user/$userId');
  }

  Future<Response<GlobalResponse>> search(String searchText,
      {required int page, int size = 3}) {
    return get<GlobalResponse>('user/$page/$size', query: {
      'nickName': searchText,
    });
  }

  Future<Response<GlobalResponse>> friendApply(int userId, String remark) {
    return post<GlobalResponse>('friendApply', {
      'userId': userId,
      'remark': remark,
    });
  }

  Future<Response<GlobalResponse>> friendApplyPending(int size,
      {int beforeLastTime = 0}) {
    return get<GlobalResponse>('friendApply/pending', query: {
      'size': size.toString(),
      'beforeLastTime': beforeLastTime.toString(),
    });
  }

  Future<Response<GlobalResponse>> friendApplyApproval(
      int id, ApplyStatus status) {
    return put<GlobalResponse>('friendApply/$id/Approval/${status.number}', {});
  }
}
