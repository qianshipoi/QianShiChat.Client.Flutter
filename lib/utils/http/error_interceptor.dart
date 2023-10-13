import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'app_exception.dart';

class MyDioSocketException extends SocketException {
  set message(String message) => this.message = message;

  MyDioSocketException(
    message, {
    osError,
    address,
    port,
  }) : super(
          message,
          osError: osError,
          address: address,
          port: port,
        );
}

class ErrorInterceptor extends Interceptor {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 自定义一个socket实例，因为dio原生的实例，message属于是只读的
    // 这里是我单独加的，型，缺少无网络情况下的错误提示信息
    // 这里我手动做处因为默认的dio err实例，的几种类理，来加工一手，效果，看下面的图片，你就知道

    if (err.error is SocketException) {
      dynamic error = err.error;
      err = err.copyWith(
          error: MyDioSocketException(
        err.message,
        osError: error.osError,
        address: error.address,
        port: error.port,
      ));
    }
    // dio默认的错误实例，如果是没有网络，只能得到一个未知错误，无法精准的得知是否是无网络的情况
    if (err.type == DioExceptionType.unknown) {
      bool isConnectNetWork = await isConnected();
      if (!isConnectNetWork && err.error is MyDioSocketException) {
        dynamic error = err.error;
        error.message = "当前网络不可用，请检查您的网络";
      }
    }
    // error统一处理
    AppException appException = AppException.create(err);
    // 错误提示
    debugPrint('DioError===: ${appException.toString()}');
    err = err.copyWith(error: appException);
    return super.onError(err, handler);
  }
}
