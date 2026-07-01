// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 商品卡片组件（双列瀑布流用）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/favorite_service.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '${product.ip.name}\n${product.characterName}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 商品图占位
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    if (product.imageUrls.isNotEmpty && product.imageUrls.first.isNotEmpty)
                      Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    else
                      _buildPlaceholder(),
                    // 收藏图标
                    Positioned(
                      top: 6,
                      right: 6,
                      child: ListenableBuilder(
                        listenable: FavoriteService(),
                        builder: (context, _) {
                          final isFav = FavoriteService().isFavorited(product.id);
                          return GestureDetector(
                            onTap: () => FavoriteService().toggle(product.id),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? const Color(0xFFE53935) : Colors.white,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标题
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 标签行
                  if (product.tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: product.tags.take(2).map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: _tagColor(tag).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 9,
                            color: _tagColor(tag),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  const SizedBox(height: 4),
                  // 价格
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '¥${priceFormat.format(product.price)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                      if (product.depositPrice != null) ...[
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '定¥${priceFormat.format(product.depositPrice)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFFFF9800),
                              fontWeight: FontWeight.w500,
                            ),
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
                        radius: 7,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          product.seller.nickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
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
    ));
  }
}