// SECURITY-REVIEWED: 2026-06-30 | RULES: v2.6.0-draft
/// 社区帖子卡片（穿插在商品流中）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _typeColor(post.type),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    _typeLabel(post.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(radius: 8, backgroundColor: Colors.grey[300]),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          post.author.nickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
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
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            // 互动数据
            Row(
              children: [
                Icon(Icons.favorite_border, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 2),
                Text('${post.likeCount}', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                const SizedBox(width: 12),
                Icon(Icons.chat_bubble_outline, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 2),
                Text('${post.commentCount}', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}