// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 我的收藏页 — 展示已收藏商品
library;

import 'package:flutter/material.dart';
import 'package:gu_app/services/favorite_service.dart';
import 'package:gu_app/data/mock_data.dart' as mock;
import 'package:gu_app/widgets/common/product_card.dart';
import 'package:gu_app/pages/product_detail/product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('我的收藏', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0.5,
      ),
      body: ListenableBuilder(
        listenable: FavoriteService(),
        builder: (context, _) {
          final favoriteIds = FavoriteService().allIds;
          final products = mock.MockData.productList
              .where((p) => favoriteIds.contains(p.id))
              .toList();

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('还没有收藏的商品', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Text('去首页逛逛吧~', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}