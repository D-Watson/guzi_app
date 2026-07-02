// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 卖家信用区 — 头像、昵称、信用分、成交数据
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';

class SellerCreditSection extends StatelessWidget {
  final ProductModel product;

  const SellerCreditSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final s = product.seller;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[300],
          backgroundImage: s.avatarUrl.isNotEmpty
              ? NetworkImage(s.avatarUrl)
              : null,
          child: s.avatarUrl.isEmpty
              ? Icon(Icons.person, color: Colors.grey[500], size: 22)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(s.nickname,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              if (s.isVerified)
                const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified,
                        color: Color(0xFF6C5CE7), size: 16)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4)),
                child: Text('信用${s.creditScore}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF4CAF50))),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
              '历史成交 ${product.sellerCompletedOrders} 笔 · 好评率 ${(product.sellerGoodRate * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ]),
        ),
        TextButton(
            onPressed: () {},
            child: const Text('联系卖家', style: TextStyle(fontSize: 12))),
      ]),
    );
  }
}