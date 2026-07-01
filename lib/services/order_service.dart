// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 订单服务 — 单例 ChangeNotifier 管理订单列表
library;

import 'package:flutter/foundation.dart';
import 'package:gu_app/models/models.dart';

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._();
  factory OrderService() => _instance;

  OrderService._();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  OrderModel createOrder({
    required String productId,
    required String productTitle,
    required double productPrice,
    String productImageUrl = '',
    String tradeTypeLabel = '一口价',
    double? depositAmount,
    required double totalAmount,
    int quantity = 1,
  }) {
    final order = OrderModel(
      id: 'ORD_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId,
      productTitle: productTitle,
      productPrice: productPrice,
      productImageUrl: productImageUrl,
      tradeTypeLabel: tradeTypeLabel,
      depositAmount: depositAmount,
      totalAmount: totalAmount,
      quantity: quantity,
      status: OrderStatus.paid,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}