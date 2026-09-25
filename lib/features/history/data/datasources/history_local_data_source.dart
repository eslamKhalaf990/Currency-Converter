import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:currency_converter/core/utils/json_parser.dart';
import 'package:currency_converter/features/history/data/models/conversion_record_model.dart';

abstract class HistoryLocalDataSource {
  Future<void> saveConversion(ConversionRecordModel record);
  Future<List<ConversionRecordModel>> getHistory();
  Future<void> deleteHistoryEntry(String id);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final Box<String> historyBox;

  HistoryLocalDataSourceImpl({required this.historyBox});

  @override
  Future<void> saveConversion(ConversionRecordModel record) async {
    final jsonStr = jsonEncode(record.toJson());
    await historyBox.put(record.id, jsonStr);
  }

  @override
  Future<List<ConversionRecordModel>> getHistory() async {
    final values = historyBox.values.toList();
    return await compute(parseHistoryRecords, values);
  }

  @override
  Future<void> deleteHistoryEntry(String id) async {
    await historyBox.delete(id);
  }
}
