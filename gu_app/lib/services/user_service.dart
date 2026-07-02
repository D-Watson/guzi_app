// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 用户 API 服务
library;

import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/api_client.dart';

class UserService {
  static final ApiClient _client = ApiClient();

  Future<UserModel> getCurrentUser() async {
    final resp = await _client.get('/users/me');
    final data = _client.extractData<Map<String, dynamic>>(resp);
    return UserModel.fromJson(data);
  }

  Future<List<UserModel>> getAllUsers() async {
    final resp = await _client.get('/users');
    final data = _client.extractData<List>(resp);
    return data.map((j) => UserModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}