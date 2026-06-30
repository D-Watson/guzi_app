// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 商品卡片组件（双列瀑布流用）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/data/mock_data.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  Color _tagColor(String tag) {
    if (tag.contains('现货')) return const Color(0xFF4CAF50);
    if (tag.contains('定金') || tag.contains('拼团')) return const Color(0xFFFF9800);
    if (tag.contains('C服')) return const Color(0xFF9C27B0);
    if (tag.contains('全新')) return const Color(0xFF2196F3);
    if (tag.contains('二手')) return const Color(0xFF607D8B);
    return const Color(0xFF757575);
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,##0.00', 'zh_CN');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图占位
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  color: Color(MockData.getPlaceholderColor(product.id.hashCode)),
                  alignment: Alignment.center,
                  child: Text(
                    '${product.ip.name}\n${product.characterName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 标签行
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: product.tags.take(3).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _tagColor(tag).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: _tagColor(tag),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 6),
                  // 价格
                  Row(
                    children: [
                      Text(
                        '¥${priceFormat.format(product.price)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      if (product.depositPrice != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          '定¥${priceFormat.format(product.depositPrice)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFFF9800),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 卖家信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.seller.nickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}