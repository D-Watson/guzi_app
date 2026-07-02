// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 交易方式说明区
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';

class TradeModeSection extends StatelessWidget {
  final ProductModel product;

  const TradeModeSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.swap_horiz, size: 18, color: Color(0xFF6C5CE7)),
          SizedBox(width: 6),
          Text('交易方式',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Icon(
                p.tradeType == TradeType.fixedPrice
                    ? Icons.sell
                    : p.tradeType == TradeType.depositFinal
                        ? Icons.payments
                        : Icons.groups,
                color: const Color(0xFF6C5CE7),
                size: 20),
            const SizedBox(width: 8),
            Text(
                p.tradeType == TradeType.fixedPrice
                    ? '一口价现货'
                    : p.tradeType == TradeType.depositFinal
                        ? '定金+尾款'
                        : '拼团',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            if (p.groupBuyId != null) ...[
              const Spacer(),
              TextButton(
                  onPressed: () {},
                  child: const Text('查看拼团 >', style: TextStyle(fontSize: 12))),
            ],
          ]),
        ),
      ]),
    );
  }
}