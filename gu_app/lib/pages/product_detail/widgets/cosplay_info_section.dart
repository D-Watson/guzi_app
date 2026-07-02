// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// C服专属信息区 — 尺码、工期、配件、材质、瑕疵说明
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';

class CosplayInfoSection extends StatelessWidget {
  final ProductModel product;

  const CosplayInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;

    // 没有任何 C 服信息时隐藏整个区块
    if (p.sizeInfo == null &&
        p.productionTime == null &&
        (p.includedParts == null || p.includedParts!.isEmpty) &&
        p.materialInfo == null &&
        p.defectsDescription == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.checkroom, size: 18, color: Color(0xFF6C5CE7)),
          SizedBox(width: 6),
          Text('C服专属信息',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        if (p.sizeInfo != null) ...[
          _infoRow('尺码表', p.sizeInfo!),
          const Divider(height: 20)
        ],
        if (p.productionTime != null) ...[
          _infoRow('工期说明', p.productionTime!),
          const Divider(height: 20)
        ],
        if (p.includedParts != null && p.includedParts!.isNotEmpty) ...[
          _infoRow('配件清单', p.includedParts!.join('、')),
          const Divider(height: 20)
        ],
        if (p.materialInfo != null) ...[
          _infoRow('材质说明', p.materialInfo!),
          const Divider(height: 20)
        ],
        if (p.defectsDescription != null) ...[
          _infoRow('瑕疵说明', p.defectsDescription!,
              color: const Color(0xFFFF9800)),
        ],
      ]),
    );
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 70,
            child: Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]))),
        Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 13,
                    color: color ?? const Color(0xFF333333),
                    height: 1.4))),
      ]),
    );
  }
}