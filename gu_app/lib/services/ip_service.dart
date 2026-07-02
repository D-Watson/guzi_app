// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// IP、品类、Banner 等基础数据 API
library;

import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/api_client.dart';

class IpService {
  static final ApiClient _client = ApiClient();

  Future<List<IPModel>> getIps() async {
    final resp = await _client.get('/ips');
    final data = _client.extractData<List>(resp);
    return data.map((j) => IPModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}

class CategoryService {
  static final ApiClient _client = ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    final resp = await _client.get('/categories');
    final data = _client.extractData<List>(resp);
    return data.map((j) => CategoryModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}

class BannerService {
  static final ApiClient _client = ApiClient();

  Future<List<Map<String, dynamic>>> getBanners() async {
    final resp = await _client.get('/banners');
    final data = _client.extractData<List>(resp);
    return data.cast<Map<String, dynamic>>();
  }
}