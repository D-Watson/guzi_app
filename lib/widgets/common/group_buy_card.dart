// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 拼团卡片（用于拼团大厅列表）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';

class GroupBuyCard extends StatelessWidget {
  final GroupBuyModel groupBuy;
  final VoidCallback? onTap;

  const GroupBuyCard({super.key, required this.groupBuy, this.onTap});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 左侧商品图片
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 90,
                height: 110,
                color: Colors.grey[100],
                child: groupBuy.imageUrl.isNotEmpty
                    ? Image.network(
                        groupBuy.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                      )
                    : _buildPlaceholder(context),
              ),
            ),
            const SizedBox(width: 12),
            // 右侧信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IP + 状态
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          groupBuy.ip.name,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (groupBuy.characterName.isNotEmpty)
                        Text(
                          groupBuy.characterName,
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          groupBuy.status == GroupBuyStatus.recruiting ? '招募中' :
                          groupBuy.status == GroupBuyStatus.full ? '已满员' :
                          groupBuy.status == GroupBuyStatus.shipping ? '发货中' : '已完成',
                          style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 标题
                  Text(
                    groupBuy.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  // 团长 + 截止时间
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text('团长: ${groupBuy.leaderNickname}',
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                      ),
                      Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 2),
                      Text(remainingText, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${groupBuy.currentCount}/${groupBuy.totalCount}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 价格
                  Row(
                    children: [
                      Text(
                        '定金 ¥${groupBuy.depositPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      if (groupBuy.finalPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '+ 尾款 ¥${groupBuy.finalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(Icons.image, size: 32, color: Colors.grey[300]),
    );
  }
}