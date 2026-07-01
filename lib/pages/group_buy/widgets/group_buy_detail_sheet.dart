// SECURITY-REVIEWED: 2026-07-01 | RULES: v2.6.0-draft
/// 拼团详情弹窗（底部 Sheet）
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:intl/intl.dart';

class GroupBuyDetailSheet extends StatelessWidget {
  final GroupBuyModel groupBuy;
  const GroupBuyDetailSheet({super.key, required this.groupBuy});

  @override
  Widget build(BuildContext context) {
    final deadlineFormat = DateFormat('MM-dd HH:mm', 'zh_CN');
    final remaining = groupBuy.deadline.difference(DateTime.now());
    final progress = groupBuy.currentCount / groupBuy.totalCount;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  Text(groupBuy.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(children: [
                    CircleAvatar(radius: 16, backgroundColor: Colors.grey[300]),
                    const SizedBox(width: 8),
                    Text('团长: ${groupBuy.leaderNickname}', style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
                  ]),
                  const SizedBox(height: 20),
                  _buildProgressCard(progress, remaining),
                  const SizedBox(height: 20),
                  _buildPriceRow(),
                  const SizedBox(height: 20),
                  _buildRules(deadlineFormat),
                  const SizedBox(height: 20),
                  _buildMemberList(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(groupBuy.ip.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C5CE7))),
      ),
      const SizedBox(width: 8),
      if (groupBuy.characterName.isNotEmpty)
        Text(groupBuy.characterName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      const Spacer(),
      _buildStatusBadge(),
    ]);
  }

  Widget _buildStatusBadge() {
    final isRecruiting = groupBuy.status == GroupBuyStatus.recruiting;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isRecruiting ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        groupBuy.status == GroupBuyStatus.recruiting ? '招募中' :
        groupBuy.status == GroupBuyStatus.full ? '已满员' : '已完成',
        style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500,
          color: isRecruiting ? const Color(0xFF4CAF50) : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildProgressCard(double progress, Duration remaining) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6C5CE7).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('成团进度', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          Text('剩余 ${remaining.inDays}天${remaining.inHours % 24}小时', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF6C5CE7)),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('已上车 ${groupBuy.currentCount} 人', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF6C5CE7))),
          Text('目标 ${groupBuy.totalCount} 人', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        ]),
      ]),
    );
  }

  Widget _buildPriceRow() {
    return Row(children: [
      const Text('定金 ', style: TextStyle(fontSize: 14, color: Colors.grey)),
      Text('¥${groupBuy.depositPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
      if (groupBuy.finalPrice != null) ...[
        const SizedBox(width: 12),
        Text('+ 尾款 ¥${groupBuy.finalPrice!.toStringAsFixed(0)}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    ]);
  }

  Widget _buildRules(DateFormat deadlineFormat) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('团规说明', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildRuleRow('截团时间', deadlineFormat.format(groupBuy.deadline)),
          if (groupBuy.expectedShipDate != null) ...[
            const SizedBox(height: 6),
            _buildRuleRow('预计发货', DateFormat('MM月dd日').format(groupBuy.expectedShipDate!)),
          ],
          const SizedBox(height: 6),
          _buildRuleRow('邮费说明', groupBuy.shippingFeeRule),
          const SizedBox(height: 6),
          _buildRuleRow('团规', groupBuy.rules),
        ]),
      ),
    ]);
  }

  Widget _buildRuleRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF333333)))),
    ]);
  }

  Widget _buildMemberList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('上车列表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ...List.generate(groupBuy.totalCount, (i) {
        final isOccupied = i < groupBuy.memberIds!.length;
        final isMe = i == 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF6C5CE7).withValues(alpha: 0.06) : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: isMe ? Border.all(color: const Color(0xFF6C5CE7).withValues(alpha: 0.3)) : null,
          ),
          child: Row(children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOccupied ? Colors.grey[300] : Colors.grey[200],
              ),
              child: Center(
                child: isOccupied
                    ? Icon(Icons.person, size: 14, color: Colors.grey[500])
                    : Icon(Icons.person_add_alt, size: 14, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isMe ? '我' : isOccupied ? '团员 ${i + 1}' : '空缺',
              style: TextStyle(fontSize: 13, color: isOccupied ? const Color(0xFF333333) : Colors.grey[400]),
            ),
            if (isMe) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('已付定金', style: TextStyle(fontSize: 10, color: Color(0xFF6C5CE7))),
              ),
            ],
          ]),
        );
      }),
    ]);
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity, height: 48,
          child: ElevatedButton(
            onPressed: groupBuy.status == GroupBuyStatus.recruiting ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已成功上车！定金已通过担保交易锁定'), backgroundColor: Color(0xFF4CAF50)),
              );
              Navigator.pop(context);
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: Text(
              groupBuy.status == GroupBuyStatus.recruiting
                  ? '一键上车 · 支付定金 ¥${groupBuy.depositPrice.toStringAsFixed(0)}'
                  : groupBuy.status == GroupBuyStatus.full
                      ? '已满员'
                      : '已完成',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}