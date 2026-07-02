// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 拼团 API 服务
library;

import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/api_client.dart';

class GroupBuyService {
  static final ApiClient _client = ApiClient();

  Future<List<GroupBuyModel>> getGroupBuys({Map<String, dynamic>? params}) async {
    final resp = await _client.get('/group-buys', params: params);
    final data = _client.extractData<Map<String, dynamic>>(resp);
    final content = data['content'] as List;
    return content.map((j) => GroupBuyModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<GroupBuyModel> getGroupBuyById(String id) async {
    final resp = await _client.get('/group-buys/$id');
    final data = _client.extractData<Map<String, dynamic>>(resp);
    return GroupBuyModel.fromJson(data);
  }

  Future<List<UserGroupBuyProgress>> getMyProgress() async {
    final resp = await _client.get('/group-buys/my-progress');
    final data = _client.extractData<List>(resp);
    return data.map((j) => UserGroupBuyProgress.fromJson(j as Map<String, dynamic>)).toList();
  }
}