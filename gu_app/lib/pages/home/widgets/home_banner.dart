// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 首页活动横幅
library;

import 'package:flutter/material.dart';
import 'package:gu_app/services/ip_service.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  List<Map<String, dynamic>>? _banners;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      final banners = await BannerService().getBanners();
      if (mounted) setState(() => _banners = banners);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final banners = _banners ?? [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SizedBox(
        height: 140,
        child: PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final b = banners[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    b['title'] as String? ?? '',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b['subtitle'] as String? ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}