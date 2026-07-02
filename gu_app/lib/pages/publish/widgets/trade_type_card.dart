// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 交易类型选择卡片 + 二选一卡片
library;

import 'package:flutter/material.dart';

class TradeTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isSelected;
  final VoidCallback onTap;

  const TradeTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Row(children: [
          Icon(icon, size: 28, color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: isSelected ? const Color(0xFF6C5CE7) : const Color(0xFF333333))),
            const SizedBox(height: 2),
            Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ])),
          if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF6C5CE7), size: 20),
        ]),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ChoiceCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Column(children: [
          Icon(icon, size: 24, color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[500]),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: isSelected ? const Color(0xFF6C5CE7) : const Color(0xFF333333))),
        ]),
      ),
    );
  }
}