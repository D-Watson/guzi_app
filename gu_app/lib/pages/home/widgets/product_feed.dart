// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 首页商品流 — 双列瀑布流，商品与帖子穿插
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/widgets/common/product_card.dart';
import 'package:gu_app/widgets/common/post_card.dart';
import 'package:gu_app/pages/product_detail/product_detail_page.dart';
import 'package:gu_app/services/product_service.dart';
import 'package:gu_app/services/post_service.dart';

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
  List<_FeedItem> _feedItems = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    try {
      final results = await Future.wait([
        ProductService().getProducts(),
        PostService().getPosts(),
      ]);
      final products = results[0] as List<ProductModel>;
      final posts = results[1] as List<PostModel>;
      _buildFeed(products, posts);
    } catch (e) {
      _error = '加载失败，请下拉刷新';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _buildFeed(List<ProductModel> products, List<PostModel> posts) {
    final items = <_FeedItem>[];
    int postIdx = 0;
    for (int i = 0; i < products.length; i++) {
      items.add(_FeedItem.product(products[i]));
      if (i > 0 && i % 3 == 0 && postIdx < posts.length) {
        items.add(_FeedItem.post(posts[postIdx]));
        postIdx++;
      }
    }
    while (postIdx < posts.length) {
      items.add(_FeedItem.post(posts[postIdx]));
      postIdx++;
    }
    _feedItems = items;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_error != null) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!, style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 8),
                TextButton(onPressed: _loadFeed, child: const Text('重试')),
              ],
            ),
          ),
        ),
      );
    }

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