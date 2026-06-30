// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 拼团卡片（用于拼团大厅列表）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:intl/intl.dart';

class GroupBuyCard extends StatelessWidget {
  final GroupBuyModel groupBuy;
  final VoidCallback? onTap;

  const GroupBuyCard({super.key, required this.groupBuy, this.onTap});

  @override
  Widget build(BuildContext context) {
    final deadlineFormat = DateFormat('MM-dd HH:mm', 'zh_CN');
    final remaining = groupBuy.deadline.difference(DateTime.now());
    final remainingText = remaining.inDays > 0
        ? '剩余${remaining.inDays}天${remaining.inHours % 24}小时'
        : '剩余${remaining.inHours}小时';
    final progress = groupBuy.currentCount / groupBuy.totalCount;

    Color statusColor;
    switch (groupBuy.status) {
      case GroupBuyStatus.recruiting:
        statusColor = const Color(0xFF4CAF50);
      case GroupBuyStatus.full:
        statusColor = const Color(0xFFFF9800);
      case GroupBuyStatus.shipping:
        statusColor = const Color(0xFF2196F3);
      case GroupBuyStatus.completed:
        statusColor = const Color(0xFF757575);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP标识 + 状态
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    groupBuy.ip.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (groupBuy.characterName.isNotEmpty)
                  Text(
                    groupBuy.characterName,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    groupBuy.status == GroupBuyStatus.recruiting ? '招募中' :
                    groupBuy.status == GroupBuyStatus.full ? '已满员' :
                    groupBuy.status == GroupBuyStatus.shipping ? '发货中' : '已完成',
                    style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 标题
            Text(
              groupBuy.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // 团长 + 截止时间
            Row(
              children: [
                Icon(Icons.person_outline, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text('团长: ${groupBuy.leaderNickname}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text(remainingText, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 10),
            // 进度条
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(statusColor),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '已上车 ${groupBuy.currentCount}/${groupBuy.totalCount}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 定金 + 尾款
            Row(
              children: [
                Text(
                  '定金 ¥${groupBuy.depositPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                ),
                if (groupBuy.finalPrice != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '+ 尾款 ¥${groupBuy.finalPrice!.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}