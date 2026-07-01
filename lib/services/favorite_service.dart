// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 收藏服务 — 单例 ChangeNotifier 跨页面共享收藏状态
library;

import 'package:flutter/foundation.dart';

class FavoriteService extends ChangeNotifier {
  static final FavoriteService _instance = FavoriteService._();
  factory FavoriteService() => _instance;

  FavoriteService._() {
    // 预置几个收藏 demo
    _favoriteIds.addAll(['p_1', 'p_7']);
  }

  final Set<String> _favoriteIds = {};

  Set<String> get allIds => Set.unmodifiable(_favoriteIds);
  int get count => _favoriteIds.length;

  bool isFavorited(String productId) => _favoriteIds.contains(productId);

  void toggle(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void add(String productId) {
    _favoriteIds.add(productId);
    notifyListeners();
  }

  void remove(String productId) {
    _favoriteIds.remove(productId);
    notifyListeners();
  }
}