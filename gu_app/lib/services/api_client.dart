// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// API 客户端 — 单例 Dio
library;

import 'package:dio/dio.dart';
import 'dart:io' show Platform;

class ApiClient {
  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;
  ApiClient._();

  // Android emulator 用 10.0.2.2, iOS 模拟器用 localhost
  static String get _baseUrl {
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8082/api';
    } catch (_) {}
    return 'http://localhost:8082/api';
  }

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? params}) async {
    final response = await _dio.get(path, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path,
      {Map<String, dynamic>? body}) async {
    final response = await _dio.post(path, data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    return response.data as Map<String, dynamic>;
  }

  /// 从统一响应中提取 data，非 200 时抛异常
  T extractData<T>(Map<String, dynamic> apiResponse) {
    if (apiResponse['code'] != 200) {
      throw Exception(apiResponse['message'] ?? '请求失败');
    }
    return apiResponse['data'] as T;
  }
}
