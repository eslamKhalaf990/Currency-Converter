import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'package:currency_converter/core/utils/json_parser.dart';
import 'package:currency_converter/features/converter/data/models/exchange_rate_model.dart';
import 'package:currency_converter/core/error/exceptions.dart';

/// Contract dictating the specific endpoint interaction mapping rules for the remote host.
abstract class ConverterRemoteDataSource {
  /// Pulls live real-time rate multipliers dynamically from the server endpoint based on client currency choices.
  Future<List<ExchangeRateModel>> getExchangeRates(String baseCurrency);

  /// Pulls the dynamically supported list of currencies currently valid on the server endpoint.
  Future<Map<String, String>> getCurrencies();
}

/// Implements standard REST GET requests over the dio networking library.
class ConverterRemoteDataSourceImpl implements ConverterRemoteDataSource {
  final Dio dio;

  ConverterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ExchangeRateModel>> getExchangeRates(String baseCurrency) async {
    final response = await dio.get(
      '/latest', // The correct endpoint for frankfurter.app
      queryParameters: {'base': baseCurrency},
    );

    final responseData = response.data;
    
    if (responseData is Map<String, dynamic>) {
      // Dio successfully decoded the response in an isolate. We map it using compute to avoid blocking the main thread.
      return await compute(mapFrankfurterResponse, responseData);
    } else {
      throw const ServerException('Invalid response format');
    }
  }

  @override
  Future<Map<String, String>> getCurrencies() async {
    final response = await dio.get('/currencies');
    final responseData = response.data;

    if (responseData is Map<String, dynamic>) {
      return responseData.map((key, value) => MapEntry(key, value.toString()));
    } else {
       throw const ServerException('Invalid response format');
    }
  }
}
