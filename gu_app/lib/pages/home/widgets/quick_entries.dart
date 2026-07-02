// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 首页快捷入口 — IP 精选 + 品类导航
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/ip_service.dart';

class QuickEntries extends StatefulWidget {
  const QuickEntries({super.key});

  @override
  State<QuickEntries> createState() => _QuickEntriesState();
}

class _QuickEntriesState extends State<QuickEntries> {
  List<IPModel>? _ips;
  List<CategoryModel>? _categories;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        IpService().getIps(),
        CategoryService().getCategories(),
      ]);
      if (mounted) {
        setState(() {
          _ips = results[0] as List<IPModel>;
          _categories = results[1] as List<CategoryModel>;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_ips == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('热门IP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _ips!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final ip = _ips![index];
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF6C5CE7)
                            .withValues(alpha: 0.1),
                        child: Text(
                          ip.name.length > 2
                              ? ip.name.substring(0, 2)
                              : ip.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C5CE7)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(ip.name,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[700])),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('品类',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories!
                .map((cat) => ActionChip(
                      avatar: Text(cat.icon,
                          style: const TextStyle(fontSize: 16)),
                      label: Text(cat.name,
                          style: const TextStyle(fontSize: 12)),
                      onPressed: () {},
                      backgroundColor: const Color(0xFFF5F5F5),
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}