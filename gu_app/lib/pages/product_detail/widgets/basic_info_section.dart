// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 商品基本信息区 — 标签、标题、IP角色品类、价格、交易标签
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:intl/intl.dart';

class BasicInfoSection extends StatelessWidget {
  final ProductModel product;
  final NumberFormat priceFormat;

  const BasicInfoSection({
    super.key,
    required this.product,
    required this.priceFormat,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTags(p),
          const SizedBox(height: 10),
          Text(p.title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, height: 1.4)),
          const SizedBox(height: 8),
          _buildMetaRow(p),
          const SizedBox(height: 12),
          _buildPriceRow(p),
          const SizedBox(height: 6),
          if (p.tradeType == TradeType.depositFinal && p.finalPrice != null)
            _buildFinalPaymentInfo(p),
          const SizedBox(height: 12),
          _buildTradeTags(p),
        ],
      ),
    );
  }

  Widget _buildTags(ProductModel p) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: p.tags
          .map((tag) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(tag,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF6C5CE7))),
              ))
          .toList(),
    );
  }

  Widget _buildMetaRow(ProductModel p) {
    return Row(children: [
      _infoChip(Icons.movie, p.ip.name),
      const SizedBox(width: 12),
      _infoChip(Icons.person,
          p.characterName.isNotEmpty ? p.characterName : '通用'),
      const SizedBox(width: 12),
      _infoChip(Icons.shopping_bag, p.category.name),
    ]);
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildPriceRow(ProductModel p) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('¥${priceFormat.format(p.price)}',
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE53935))),
        if (p.depositPrice != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4)),
            child: Text('定金¥${priceFormat.format(p.depositPrice)}',
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF9800),
                    fontWeight: FontWeight.w500)),
          ),
        ],
        const Spacer(),
        Text('已售${p.salesCount}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildFinalPaymentInfo(ProductModel p) {
    return Row(children: [
      Text('尾款 ¥${priceFormat.format(p.finalPrice)}',
          style: const TextStyle(fontSize: 14, color: Color(0xFF757575))),
      if (p.finalPaymentDeadline != null) ...[
        const SizedBox(width: 12),
        Icon(Icons.timer_outlined, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text('尾款截止 ${DateFormat('MM-dd').format(p.finalPaymentDeadline!)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    ]);
  }

  Widget _buildTradeTags(ProductModel p) {
    return Row(children: [
      _tag('担保交易', const Color(0xFF4CAF50), Icons.verified),
      const SizedBox(width: 8),
      _tag(p.isNew ? '全新' : '二手', Colors.grey[600]!, Icons.info_outline),
    ]);
  }

  Widget _tag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}