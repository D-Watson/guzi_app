// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 我的拼团进度卡片
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';

class _StageData {
  final String label;
  final bool isCompleted;
  final IconData icon;
  _StageData(this.label, this.isCompleted, this.icon);
}

class ProgressCard extends StatelessWidget {
  final UserGroupBuyProgress progress;

  const ProgressCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final stages = [
      _StageData('已付定金', progress.hasPaidDeposit, Icons.payments),
      _StageData('等待补款', progress.waitingForSupplement, Icons.schedule),
      _StageData('已发货', progress.shipped, Icons.local_shipping),
      _StageData('已收货', progress.received, Icons.check_circle),
    ];

    int activeStage = 0;
    if (progress.received) activeStage = 3;
    else if (progress.shipped) activeStage = 2;
    else if (progress.waitingForSupplement) activeStage = 1;
    else if (progress.hasPaidDeposit) activeStage = 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(progress.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: List.generate(stages.length, (i) {
              final isActive = i <= activeStage;
              final isLast = i == stages.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? const Color(0xFF6C5CE7) : Colors.grey[200],
                      ),
                      child: Icon(stages[i].icon, size: 14, color: isActive ? Colors.white : Colors.grey[400]),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(height: 2, color: i < activeStage ? const Color(0xFF6C5CE7) : Colors.grey[200]),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(stages.length, (i) {
              final isActive = i <= activeStage;
              return Expanded(
                child: Text(
                  stages[i].label,
                  textAlign: i == 0 ? TextAlign.left : i == stages.length - 1 ? TextAlign.right : TextAlign.center,
                  style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF6C5CE7) : Colors.grey[400]),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (progress.status == GroupBuyStatus.recruiting)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('查看详情', style: TextStyle(fontSize: 12, color: Color(0xFF6C5CE7), fontWeight: FontWeight.w500)),
                ),
              if (progress.waitingForSupplement)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('去补款', style: TextStyle(fontSize: 12, color: Color(0xFFE53935), fontWeight: FontWeight.w500)),
                ),
              if (progress.received)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('已完成', style: TextStyle(fontSize: 12, color: Color(0xFF4CAF50), fontWeight: FontWeight.w500)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}