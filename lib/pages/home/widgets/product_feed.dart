// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 首页商品流 — 双列瀑布流，商品与帖子穿插
library;

import 'package:flutter/material.dart';
import 'package:gu_app/data/mock_data.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/widgets/common/product_card.dart';
import 'package:gu_app/widgets/common/post_card.dart';
import 'package:gu_app/pages/product_detail/product_detail_page.dart';

enum _FeedType { product, post }

class _FeedItem {
  final _FeedType type;
  final ProductModel? product;
  final PostModel? post;

  _FeedItem.product(this.product) : type = _FeedType.product, post = null;
  _FeedItem.post(this.post) : type = _FeedType.post, product = null;
}

class ProductFeed extends StatefulWidget {
  const ProductFeed({super.key});

  @override
  State<ProductFeed> createState() => _ProductFeedState();
}

class _ProductFeedState extends State<ProductFeed> {
  final List<_FeedItem> _feedItems = [];

  @override
  void initState() {
    super.initState();
    _buildFeed();
  }

  void _buildFeed() {
    _feedItems.clear();
    int postIdx = 0;
    for (int i = 0; i < MockData.productList.length; i++) {
      _feedItems.add(_FeedItem.product(MockData.productList[i]));
      if (i > 0 && i % 3 == 0 && postIdx < MockData.postList.length) {
        _feedItems.add(_FeedItem.post(MockData.postList[postIdx]));
        postIdx++;
      }
    }
    while (postIdx < MockData.postList.length) {
      _feedItems.add(_FeedItem.post(MockData.postList[postIdx]));
      postIdx++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _feedItems.length) return null;
            final item = _feedItems[index];
            if (item.type == _FeedType.product) {
              return ProductCard(
                product: item.product!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: item.product!),
                    ),
                  );
                },
              );
            } else {
              return PostCard(post: item.post!);
            }
          },
          childCount: _feedItems.length,
        ),
      ),
    );
  }
}