import 'dart:convert';

/// compute()-based json decoding helper
Map<String, dynamic> parseJsonObject(String responseBody) {
  return jsonDecode(responseBody) as Map<String, dynamic>;
}

List<dynamic> parseJsonList(String responseBody) {
  return jsonDecode(responseBody) as List<dynamic>;
}
