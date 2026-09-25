import 'dart:io';
import 'package:dio/dio.dart';
import 'package:currency_converter/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    BaseException mappedException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        mappedException = const TimeoutException();
        break;
      case DioExceptionType.connectionError:
        mappedException = const NoInternetException();
        break;
      case DioExceptionType.badResponse:
        final message =
            err.response?.data?['message'] ?? 'Server error occurred';
        mappedException = ServerException(message.toString());
        break;
      default:
        if (err.error is SocketException) {
          mappedException = const NoInternetException();
        } else {
          mappedException = ServerException(err.message ?? 'Unknown error');
        }
        break;
    }

    // Pass the mapped exception up the chain
    // Data sources will catch it and map it to Failure via BaseRepository
    return handler.reject(err.copyWith(error: mappedException));
  }
}
