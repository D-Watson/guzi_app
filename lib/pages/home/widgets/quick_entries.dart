// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 首页快捷入口 — 按IP找 / 按品类找 / IP横滑 / 品类横滑
library;

import 'package:flutter/material.dart';
import 'package:gu_app/data/mock_data.dart';
import 'package:gu_app/widgets/common/chip_button.dart';

class QuickEntries extends StatelessWidget {
  const QuickEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 快捷入口行
          const Row(
            children: [
              ChipButton(
                  icon: Icons.explore, label: '按IP找', color: Color(0xFF6C5CE7)),
              SizedBox(width: 12),
              ChipButton(
                  icon: Icons.category,
                  label: '按品类找',
                  color: Color(0xFF00B4D8)),
              SizedBox(width: 12),
              ChipButton(
                  icon: Icons.groups, label: '拼团广场', color: Color(0xFFE17055)),
              SizedBox(width: 12),
              ChipButton(
                  icon: Icons.local_fire_department,
                  label: '热门推荐',
                  color: Color(0xFFE53935)),
            ],
          ),
          const SizedBox(height: 16),
          // IP 快捷入口 - 横滑
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.ipList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final ip = MockData.ipList[index];
                final colors = [
                  const Color(0xFF6C5CE7),
                  const Color(0xFF00B4D8),
                  const Color(0xFFE17055),
                  const Color(0xFF4CAF50),
                  const Color(0xFFE53935),
                ];
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: colors[index % colors.length]
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors[index % colors.length]
                                .withValues(alpha: 0.25),
                          ),
                          image: ip.iconUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(ip.iconUrl),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: ip.iconUrl.isEmpty
                            ? Center(
                                child: Text(
                                  ip.name.substring(0,
                                      ip.name.length <= 2 ? ip.name.length : 2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colors[index % colors.length],
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ip.name,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
                  label: Text('${cat.icon} ${cat.name}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF333333))),
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
}
