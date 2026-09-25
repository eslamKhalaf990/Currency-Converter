import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

typedef RemoteCall<T> = Future<T> Function();
typedef MapperContext<T, R> = R Function(T data);
typedef CacheSave<T> = Future<void> Function(T data);
typedef CacheFetch<T> = Future<T> Function();
typedef ActionCall<T> = Future<T> Function();

abstract class BaseRepository {
  /// Handles tasks that fetch from remote falling back to cache if remote fails.
  /// Converts exceptions to correct functional failures securely.
  Future<Either<Failure, R>> handleNetworkCall<T, R>({
    required RemoteCall<T> call,
    CacheSave<T>? cacheSave,
    CacheFetch<T>? cacheFetch,
    required MapperContext<T, R> mapper,
  }) async {
    try {
      final remoteData = await call();
      if (cacheSave != null) {
        await cacheSave(remoteData);
      }
      return Right(mapper(remoteData));
    } catch (e) {
      if (cacheFetch != null) {
        try {
          final cachedData = await cacheFetch();
          return Right(mapper(cachedData));
        } catch (_) {
          return Left(_mapExceptionToFailure(e));
        }
      }
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Handles clean local data operations mapping Exceptions locally.
  Future<Either<Failure, T>> handleLocalAction<T>({
    required ActionCall<T> action,
  }) async {
    try {
      final result = await action();
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object exception) {
    Object mapped = exception;

    if (exception is DioException) {
      if (exception.error != null && exception.error is BaseException) {
        mapped = exception.error!;
      } else {
        if (exception.type == DioExceptionType.connectionTimeout ||
            exception.type == DioExceptionType.connectionError ||
            exception.type == DioExceptionType.receiveTimeout ||
            exception.type == DioExceptionType.unknown) {
          return const NetworkFailure(
            'Network Error and no offline cache available.',
          );
        }
      }
    }

    if (mapped is BaseException) {
      if (mapped is ServerException) {
        return ServerFailure(mapped.message);
      } else if (mapped is NoInternetException) {
        return NetworkFailure(mapped.message);
      } else if (mapped is TimeoutException) {
        return NetworkFailure(mapped.message);
      } else if (mapped is CacheException) {
        return CacheFailure(mapped.message);
      }
      return ServerFailure(mapped.message);
    }

    if (mapped is HiveError) {
      return CacheFailure(mapped.message);
    }

    return ServerFailure(mapped.toString());
  }
}
