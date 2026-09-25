/// Base class for all remote/local exceptions handled by Data sources.
abstract class BaseException implements Exception {
  final String message;
  const BaseException(this.message);

  @override
  String toString() => message;
}

class ServerException extends BaseException {
  const ServerException(super.message);
}

class CacheException extends BaseException {
  const CacheException(super.message);
}

class NoInternetException extends BaseException {
  const NoInternetException([super.message = 'No internet connection']);
}

class TimeoutException extends BaseException {
  const TimeoutException([super.message = 'Connection timed out']);
}
