// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 订单服务 — 单例 ChangeNotifier，API 驱动
library;

import 'package:flutter/foundation.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/api_client.dart';

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._();
  factory OrderService() => _instance;

  OrderService._();

  final ApiClient _client = ApiClient();
  final List<OrderModel> _orders = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final resp = await _client.get('/orders');
      final data = _client.extractData<Map<String, dynamic>>(resp);
      final content = data['content'] as List;
      _orders.addAll(
          content.map((j) => OrderModel.fromJson(j as Map<String, dynamic>)));
    } catch (_) {}
    _initialized = true;
    notifyListeners();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  Future<OrderModel> createOrder({
    required String productId,
    required String productTitle,
    required double productPrice,
    String productImageUrl = '',
    String tradeTypeLabel = '一口价',
    double? depositAmount,
    required double totalAmount,
    int quantity = 1,
  }) async {
    final tradeType = tradeTypeLabel == '定金+尾款' ? 'depositFinal' : 'fixedPrice';
    final resp = await _client.post('/orders', body: {
      'productId': productId,
      'quantity': quantity,
      'tradeType': tradeType,
    });
    final data = _client.extractData<Map<String, dynamic>>(resp);
    final order = OrderModel.fromJson(data);
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}