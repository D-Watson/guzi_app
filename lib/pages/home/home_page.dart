// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 首页 — 流量分发与社区氛围
library;

import 'package:flutter/material.dart';
import 'package:gu_app/data/mock_data.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/widgets/common/product_card.dart';
import 'package:gu_app/widgets/common/post_card.dart';
import 'package:gu_app/pages/product_detail/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> _feedItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _buildFeed();
  }

  void _buildFeed() {
    _feedItems.clear();
    // 模拟穿插：商品流 + 社区帖子
    int postIdx = 0;
    for (int i = 0; i < MockData.productList.length; i++) {
      _feedItems.add(_FeedItem.product(MockData.productList[i]));
      // 每隔3-4个商品插入一个帖子
      if (i > 0 && i % 3 == 0 && postIdx < MockData.postList.length) {
        _feedItems.add(_FeedItem.post(MockData.postList[postIdx]));
        postIdx++;
      }
    }
    // 如果帖子还有剩余，追加到末尾
    while (postIdx < MockData.postList.length) {
      _feedItems.add(_FeedItem.post(MockData.postList[postIdx]));
      postIdx++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 顶部搜索和快捷入口
            SliverToBoxAdapter(child: _buildHeader()),

            // Banner
            SliverToBoxAdapter(child: _buildBanner()),

            // 快捷入口（按IP找 / 按品类找）
            SliverToBoxAdapter(child: _buildQuickEntries()),

            // 双列瀑布流商品流
            _buildProductFlow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Colors.white,
      child: Column(
        children: [
          // Logo + 搜索框
          Row(
            children: [
              // App Logo / 标题
              const Text(
                '吃谷',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C5CE7),
                ),
              ),
              const SizedBox(width: 12),
              // 搜索框
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 12),
                      Icon(Icons.search, color: Colors.grey, size: 20),
                      SizedBox(width: 6),
                      Text(
                        '搜索IP名、角色、商品...',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 消息按钮
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF333333)),
                onPressed: () {},
                iconSize: 22,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Banner 装饰
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.auto_awesome, size: 120, color: Colors.white.withOpacity(0.15)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '夏日动漫嘉年华',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '漫展专场 · 热门IP上新 · 限时优惠',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 12),
                Chip(
                  label: Text('查看活动', style: TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.white24,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickEntries() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 快捷入口：按IP找 & 按品类找
          Row(
            children: [
              _buildQuickEntryChip(Icons.explore, '按IP找', const Color(0xFF6C5CE7)),
              const SizedBox(width: 12),
              _buildQuickEntryChip(Icons.category, '按品类找', const Color(0xFF00B4D8)),
              const SizedBox(width: 12),
              _buildQuickEntryChip(Icons.groups, '拼团广场', const Color(0xFFE17055)),
              const SizedBox(width: 12),
              _buildQuickEntryChip(Icons.local_fire_department, '热门推荐', const Color(0xFFE53935)),
            ],
          ),
          const SizedBox(height: 16),
          // IP 快捷入口
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.ipList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final ip = MockData.ipList[index];
                return ActionChip(
                  label: Text(ip.name, style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
                  backgroundColor: Colors.grey[100],
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {},
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // 品类快捷入口
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.categoryList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = MockData.categoryList[index];
                return ActionChip(
                  label: Text('${cat.icon} ${cat.name}', style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
                  backgroundColor: Colors.grey[100],
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickEntryChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductFlow() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
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

enum _FeedType { product, post }

class _FeedItem {
  final _FeedType type;
  final ProductModel? product;
  final PostModel? post;

  _FeedItem.product(this.product) : type = _FeedType.product, post = null;
  _FeedItem.post(this.post) : type = _FeedType.post, product = null;
}