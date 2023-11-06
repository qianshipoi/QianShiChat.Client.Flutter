import 'dart:io';

import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:mime/mime.dart';
import 'package:qianshi_chat/models/global_response.dart';
import 'package:qianshi_chat/providers/api_base_provider.dart';

class AttachmentProvider extends ApiBaseProvider {
  Future<Response<GlobalResponse>> upload(String filePath,
      {dynamic Function(double)? uploadProgress}) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;
    final mimeType = lookupMimeType(file.path) ?? "application/octet-stream";
    final formData = FormData({
      'file': MultipartFile(
        file.readAsBytesSync(),
        filename: fileName,
        contentType: mimeType,
      ),
    });
    return post<GlobalResponse>('attachment', formData,
        uploadProgress: uploadProgress);
  }

  Future<Response<GlobalResponse>> bindTusFile(String fileId) {
    return put<GlobalResponse>('/attachment/bind-tus-file/$fileId', {});
  }
}
