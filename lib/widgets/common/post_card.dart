// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 社区帖子卡片（穿插在商品流中）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/data/mock_data.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  Color _typeColor(PostType type) {
    switch (type) {
      case PostType.showOff:
        return const Color(0xFF2196F3);
      case PostType.avoidPit:
        return const Color(0xFFE53935);
      case PostType.tradeRequest:
        return const Color(0xFFFF9800);
    }
  }

  String _typeLabel(PostType type) {
    switch (type) {
      case PostType.showOff:
        return '晒单';
      case PostType.avoidPit:
        return '避雷';
      case PostType.tradeRequest:
        return '换谷';
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('MM-dd HH:mm', 'zh_CN');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _typeColor(post.type).withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _typeColor(post.type).withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：类型标签 + 作者
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _typeColor(post.type),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _typeLabel(post.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(radius: 10, backgroundColor: Colors.grey[300]),
                const SizedBox(width: 4),
                Text(
                  post.author.nickname,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  timeFormat.format(post.createdAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 内容
            Text(
              post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            // 互动数据
            Row(
              children: [
                Icon(Icons.favorite_border, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text('${post.likeCount}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text('${post.commentCount}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}