// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 下单弹窗 — 三步流：确认订单 → 处理中 → 下单成功
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/utils/colors.dart';
import 'package:gu_app/services/order_service.dart';
import 'package:gu_app/pages/orders/orders_page.dart';
import 'package:intl/intl.dart';

enum _SheetState { review, processing, success }

class OrderBottomSheet extends StatefulWidget {
  final ProductModel product;
  const OrderBottomSheet({super.key, required this.product});

  @override
  State<OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  _SheetState _state = _SheetState.review;
  int _quantity = 1;
  OrderModel? _order;

  ProductModel get p => widget.product;
  NumberFormat get _priceFormat => NumberFormat('#,##0.00', 'zh_CN');

  bool get _isDeposit => p.tradeType == TradeType.depositFinal && p.depositPrice != null;

  double get _totalPrice {
    if (_isDeposit) {
      return p.depositPrice! * _quantity;
    }
    return p.price * _quantity;
  }

  void _submitOrder() {
    setState(() => _state = _SheetState.processing);

    Future.delayed(const Duration(milliseconds: 1500), () async {
      final order = await OrderService().createOrder(
        productId: p.id,
        productTitle: p.title,
        productPrice: p.price,
        productImageUrl: p.imageUrls.isNotEmpty ? p.imageUrls.first : '',
        tradeTypeLabel: _isDeposit ? '定金+尾款' : '一口价',
        depositAmount: _isDeposit ? _totalPrice : null,
        totalAmount: _totalPrice,
        quantity: _quantity,
      );
      setState(() {
        _order = order;
        _state = _SheetState.success;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 拖拽指示器
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          // 内容
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case _SheetState.review:
        return _buildReview();
      case _SheetState.processing:
        return _buildProcessing();
      case _SheetState.success:
        return _buildSuccess();
    }
  }

  Widget _buildReview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              const Text('确认订单', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, size: 20, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 商品信息
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // 商品图片占位
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 64,
                    height: 64,
                    color: Color(AppColors.getPlaceholderColor(p.id.hashCode)),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, color: Colors.white38, size: 28),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${p.ip.name} · ${p.characterName}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 交易方式
          Row(
            children: [
              Icon(
                _isDeposit ? Icons.payments : Icons.sell,
                size: 16,
                color: const Color(0xFF6C5CE7),
              ),
              const SizedBox(width: 6),
              Text(
                _isDeposit ? '定金+尾款' : '一口价现货',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 数量选择器
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('购买数量', style: TextStyle(fontSize: 13, color: Color(0xFF333333))),
                const Spacer(),
                GestureDetector(
                  onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 24,
                    color: _quantity > 1 ? const Color(0xFF6C5CE7) : Colors.grey[300],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: _quantity < 99 ? () => setState(() => _quantity++) : null,
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 24,
                    color: _quantity < 99 ? const Color(0xFF6C5CE7) : Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 价格明细
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (_isDeposit) ...[
                  _priceRow('定金', p.depositPrice!, _quantity),
                  if (p.finalPrice != null)
                    _priceRow('尾款', p.finalPrice!, _quantity),
                ] else
                  _priceRow('商品金额', p.price, _quantity),
                const Divider(height: 20),
                Row(
                  children: [
                    const Text('合计', style: TextStyle(fontSize: 13, color: Color(0xFF333333))),
                    const Spacer(),
                    Text(
                      '¥${_priceFormat.format(_totalPrice)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 提交按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: Text(
                _isDeposit ? '支付定金 ¥${_priceFormat.format(_totalPrice)}' : '提交订单',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double price, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const Spacer(),
          Text(
            '¥${_priceFormat.format(price)} × $quantity',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Text(
            '¥${_priceFormat.format(price * quantity)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: Color(0xFF6C5CE7),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '订单处理中...',
            style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          Text(
            '请稍候，正在为您创建订单',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Color(0xFF4CAF50)),
            const SizedBox(height: 16),
            const Text(
              '下单成功！',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 12),
            if (_order != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('订单编号', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        Text(
                          _order!.id,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('支付金额', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        Text(
                          '¥${_priceFormat.format(_order!.totalAmount)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE53935)),
                        ),
                      ],
                    ),
                    if (_isDeposit) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('尾款', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                          Text(
                            '到货后通知补款',
                            style: TextStyle(fontSize: 12, color: Colors.orange[600]),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text('查看订单', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('继续逛逛', style: TextStyle(fontSize: 14, color: Color(0xFF757575))),
            ),
          ],
        ),
      ),
    );
  }
}