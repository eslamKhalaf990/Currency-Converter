import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:currency_converter/core/network/interceptors/error_interceptor.dart';

class ApiEndpoints {
  static const String baseUrl = 'https://api.frankfurter.app';
}

Dio buildDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(ErrorInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  return dio;
}
