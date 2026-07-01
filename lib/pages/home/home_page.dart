// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 首页 — 流量分发与社区氛围
library;

import 'package:flutter/material.dart';
import 'package:gu_app/pages/home/widgets/home_header.dart';
import 'package:gu_app/pages/home/widgets/home_banner.dart';
import 'package:gu_app/pages/home/widgets/quick_entries.dart';
import 'package:gu_app/pages/home/widgets/product_feed.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeHeader()),
            SliverToBoxAdapter(child: HomeBanner()),
            SliverToBoxAdapter(child: QuickEntries()),
            ProductFeed(),
          ],
        ),
      ),
    );
  }
}