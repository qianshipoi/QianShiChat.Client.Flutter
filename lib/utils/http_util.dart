import 'package:dio/dio.dart';

class BaseUrl {
  static const String url = "https://chat-api.kuriyama.top/api/";
}

class HttpUtil {
  static void get(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Function? success,
      Function? error}) async {
    if (data != null && data.isNotEmpty) {
      StringBuffer options = StringBuffer('?');
      data.forEach((key, value) {
        options.write("$key=$value&");
      });
      url += options.toString();
      url = url.substring(0, url.length - 1);
    }

    await _sendRequest(url, 'get', success, headers: headers, error: error);
  }

  static void post(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Function? success,
      Function? error}) async {
    await _sendRequest(url, 'post', success,
        data: data, headers: headers, error: error);
  }

  static Future _sendRequest(String url, String method, Function? success,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Function? error}) async {
    int code;
    String msg;
    if (!url.startsWith('http')) {
      url = BaseUrl.url + url;
    }

    try {
      Map<String, dynamic> dataMap = data ?? {};
      Map<String, dynamic> headersMap = headers ?? {};

      // 配置dio请求信息
      Response response;
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 10); // 服务器链接超时，毫秒
      dio.options.receiveTimeout =
          const Duration(seconds: 3); // 响应流上前后两次接受到数据的间隔，毫秒
      dio.options.headers
          .addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

      if (method == 'get') {
        response = await dio.get(url);
      } else {
        response = await dio.post(url, data: dataMap);
      }

      if (response.statusCode != 200) {
        msg = '网络请求错误,状态码:${response.statusCode}';
        _handError(error, msg);
        return;
      }

      // 返回结果处理
      Map<String, dynamic> resCallbackMap = response.data;
      code = resCallbackMap['code'];
      msg = resCallbackMap['msg'];
      var backData = resCallbackMap['data'];

      if (success != null) {
        if (code == 0) {
          success(backData);
        } else {
          String errorMsg = '$code:$msg';
          _handError(error, errorMsg);
        }
      }
    } catch (exception) {
      _handError(error, '数据请求错误：$exception');
    }
  }

  static _handError(Function? errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }
}
