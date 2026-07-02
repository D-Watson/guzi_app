// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 发布步骤指示器
library;

import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['选IP品类', '上传图文', '交易方式', '定价发布'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == currentStep;
          final isDone = i < currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? const Color(0xFF6C5CE7) : isDone ? const Color(0xFF4CAF50) : Colors.grey[300],
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text('${i + 1}', style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : Colors.grey[600])),
                  ),
                ),
                const SizedBox(width: 4),
                Text(steps[i], style: TextStyle(
                  fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? const Color(0xFF6C5CE7) : Colors.grey[500])),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: isDone ? const Color(0xFF4CAF50) : Colors.grey[300],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}