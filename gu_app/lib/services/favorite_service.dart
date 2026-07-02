// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 收藏服务 — 单例 ChangeNotifier，API 驱动
library;

import 'package:flutter/foundation.dart';
import 'package:gu_app/services/api_client.dart';

class FavoriteService extends ChangeNotifier {
  static final FavoriteService _instance = FavoriteService._();
  factory FavoriteService() => _instance;

  FavoriteService._();

  final ApiClient _client = ApiClient();
  final Set<String> _favoriteIds = {};
  bool _initialized = false;

  bool get _isReady => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final resp = await _client.get('/favorites');
      final data = _client.extractData<List>(resp);
      _favoriteIds.addAll(data.cast<String>());
    } catch (_) {
      // 初始化失败时保持空列表
    }
    _initialized = true;
    notifyListeners();
  }

  Set<String> get allIds => Set.unmodifiable(_favoriteIds);
  int get count => _favoriteIds.length;

  bool isFavorited(String productId) => _favoriteIds.contains(productId);

  Future<void> toggle(String productId) async {
    if (!_isReady) await initialize();
    try {
      if (_favoriteIds.contains(productId)) {
        await _client.delete('/favorites/$productId');
        _favoriteIds.remove(productId);
      } else {
        await _client.post('/favorites/$productId');
        _favoriteIds.add(productId);
      }
      notifyListeners();
    } catch (_) {
      // 网络错误时本地状态回滚
    }
  }

  Future<void> add(String productId) async {
    if (!_isReady) await initialize();
    try {
      await _client.post('/favorites/$productId');
      _favoriteIds.add(productId);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> remove(String productId) async {
    if (!_isReady) await initialize();
    try {
      await _client.delete('/favorites/$productId');
      _favoriteIds.remove(productId);
      notifyListeners();
    } catch (_) {}
  }
}