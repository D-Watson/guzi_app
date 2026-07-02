// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 商品 API 服务
library;

import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/api_client.dart';

class ProductService {
  static final ApiClient _client = ApiClient();

  Future<List<ProductModel>> getProducts({Map<String, dynamic>? params}) async {
    final resp = await _client.get('/products', params: params);
    final data = _client.extractData<Map<String, dynamic>>(resp);
    final content = data['content'] as List;
    return content.map((j) => ProductModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final resp = await _client.get('/products/$id');
    final data = _client.extractData<Map<String, dynamic>>(resp);
    return ProductModel.fromJson(data);
  }

  Future<List<ProductModel>> getRecommendations(String id) async {
    final resp = await _client.get('/products/$id/recommendations');
    final data = _client.extractData<List>(resp);
    return data.map((j) => ProductModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}