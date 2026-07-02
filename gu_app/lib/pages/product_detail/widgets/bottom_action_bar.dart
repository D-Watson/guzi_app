// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 底部操作栏 — 收藏/联系/加入购物车/立即购买
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/favorite_service.dart';
import 'package:gu_app/pages/product_detail/widgets/order_bottom_sheet.dart';
import 'package:intl/intl.dart';

class BottomActionBar extends StatelessWidget {
  final ProductModel product;
  final NumberFormat priceFormat;

  const BottomActionBar({
    super.key,
    required this.product,
    required this.priceFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(children: [
          _buildFavoriteButton(),
          _buildContactButton(),
          const SizedBox(width: 8),
          Expanded(child: _buildAddToCartButton()),
          const SizedBox(width: 8),
          Expanded(child: _buildBuyNowButton(context)),
          const SizedBox(width: 16),
        ]),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return ListenableBuilder(
      listenable: FavoriteService(),
      builder: (context, _) {
        final isFav = FavoriteService().isFavorited(product.id);
        return GestureDetector(
          onTap: () => FavoriteService().toggle(product.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: [
              Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? const Color(0xFFE53935) : Colors.grey[600],
                  size: 22),
              Text(isFav ? '已收藏' : '收藏',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildContactButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(children: [
        Icon(Icons.chat_bubble_outline, color: Colors.grey[600], size: 22),
        Text('联系', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ]),
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF6C5CE7))),
      child: const Center(
          child: Text('加入购物车',
              style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontWeight: FontWeight.w600,
                  fontSize: 14))),
    );
  }

  Widget _buildBuyNowButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => OrderBottomSheet(product: product),
        );
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]),
        ),
        child: const Center(
            child: Text('立即购买',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14))),
      ),
    );
  }
}