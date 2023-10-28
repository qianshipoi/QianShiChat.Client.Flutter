import 'package:get/get.dart';
import 'package:qianshi_chat/models/enums/message_send_type.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class ChatProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> history(
    String roomId,
    int page, {
    int size = 20,
  }) {
    return get<GlobalResponse>('chat/$roomId/history', query: {
      'page': page.toString(),
      'size': size.toString(),
    });
  }

  Future<Response<GlobalResponse>> sendText(
    int toId,
    String message,
    MessageSendType type,
  ) {
    return post<GlobalResponse>('chat/text', {
      'toId': toId,
      'message': message,
      'sendType': type.number,
    });
  }

  Future<Response<GlobalResponse>> sendFile(
      int toId, int attachmentId, MessageSendType type) {
    return post<GlobalResponse>('chat/file', {
      'toId': toId,
      'attachmentId': attachmentId,
      'sendType': type.number,
    });
  }
}
