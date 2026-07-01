// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 我的订单页 — 展示已下单记录
library;

import 'package:flutter/material.dart';
import 'package:gu_app/services/order_service.dart';
import 'package:gu_app/models/models.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('我的订单', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0.5,
      ),
      body: ListenableBuilder(
        listenable: OrderService(),
        builder: (context, _) {
          final orders = OrderService().orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('暂无订单', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Text('去挑选心仪的商品吧~', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildOrderCard(context, orders[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final timeFormat = DateFormat('MM-dd HH:mm', 'zh_CN');

    Color statusColor;
    String statusLabel;
    switch (order.status) {
      case OrderStatus.pendingPayment:
        statusColor = const Color(0xFFFF9800);
        statusLabel = '待付款';
      case OrderStatus.paid:
        statusColor = const Color(0xFF4CAF50);
        statusLabel = '已付款';
      case OrderStatus.shipped:
        statusColor = const Color(0xFF2196F3);
        statusLabel = '已发货';
      case OrderStatus.received:
        statusColor = const Color(0xFF757575);
        statusLabel = '已收货';
      case OrderStatus.cancelled:
        statusColor = Colors.grey;
        statusLabel = '已取消';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 订单头部
          Row(
            children: [
              Text(
                order.id,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 商品信息
          Row(
            children: [
              // 商品图片
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.grey, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.tradeTypeLabel} · ×${order.quantity}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '¥${NumberFormat('#,##0.00', 'zh_CN').format(order.totalAmount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 底部
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 3),
              Text(
                timeFormat.format(order.createdAt),
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
              if (order.status == OrderStatus.pendingPayment) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '去付款',
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}