import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../../core/utils/json_parser.dart';
import '../models/exchange_rate_model.dart';

/// Contract dictating the specific endpoint interaction mapping rules for the remote host.
abstract class CurrencyRemoteDataSource {
  /// Pulls live real-time rate multipliers dynamically from the server endpoint based on client currency choices.
  Future<List<ExchangeRateModel>> getExchangeRates(String baseCurrency);

  /// Pulls the dynamically supported list of currencies currently valid on the server endpoint.
  Future<Map<String, String>> getCurrencies();
}

/// Implements standard REST GET requests over the dio networking library.
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ExchangeRateModel>> getExchangeRates(String baseCurrency) async {
    final response = await dio.get(
      '/latest', // The correct endpoint for frankfurter.app
      queryParameters: {'base': baseCurrency},
    );

    final responseData = response.data;
    // To strictly use compute() with a String as requested:
    final rawJson = responseData is String
        ? responseData
        : jsonEncode(responseData);

    // Call the specific parser for Frankfurter's nested object structure
    return await compute(parseFrankfurterResponse, rawJson);
  }

  @override
  Future<Map<String, String>> getCurrencies() async {
    final response = await dio.get('/currencies');
    final responseData = response.data;

    final rawJson = responseData is String
        ? responseData
        : jsonEncode(responseData);

    final Map<String, dynamic> parsedJson = await compute(
      parseJsonObject,
      rawJson,
    );
    return parsedJson.map((key, value) => MapEntry(key, value.toString()));
  }
}
