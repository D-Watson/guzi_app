// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 帖子 API 服务
library;

import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/api_client.dart';

class PostService {
  static final ApiClient _client = ApiClient();

  Future<List<PostModel>> getPosts({Map<String, dynamic>? params}) async {
    final resp = await _client.get('/posts', params: params);
    final data = _client.extractData<Map<String, dynamic>>(resp);
    final content = data['content'] as List;
    return content.map((j) => PostModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}