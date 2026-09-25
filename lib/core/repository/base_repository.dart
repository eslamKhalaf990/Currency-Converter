import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

typedef RemoteCall<T> = Future<T> Function();
typedef MapperContext<T, R> = R Function(T data);

abstract class BaseRepository {
  Future<Either<Failure, R>> handleNetworkCall<T, R>({
    required RemoteCall<T> call,
    required MapperContext<T, R> mapper,
  }) async {
    try {
      final data = await call();
      return Right(mapper(data));
    } on BaseException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapExceptionToFailure(BaseException exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NoInternetException) {
      return NetworkFailure(exception.message);
    } else if (exception is TimeoutException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    }
    return ServerFailure(exception.message);
  }
}
