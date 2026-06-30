// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 拼团广场 — 最大差异化武器
library;

import 'package:flutter/material.dart';
import 'package:gu_app/data/mock_data.dart' as mock;
import 'package:gu_app/models/models.dart';
import 'package:gu_app/widgets/common/group_buy_card.dart';
import 'package:intl/intl.dart';

class GroupBuyPage extends StatefulWidget {
  const GroupBuyPage({super.key});

  @override
  State<GroupBuyPage> createState() => _GroupBuyPageState();
}

class _GroupBuyPageState extends State<GroupBuyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = '全部';

  final List<String> _filters = ['全部', '原神', '排球少年', '咒术回战', '蓝色监狱', '即将截团', '最热'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('拼团广场', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6C5CE7),
          labelColor: const Color(0xFF6C5CE7),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '拼团大厅'),
            Tab(text: '我的拼团'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGroupBuyHall(),
          _buildMyGroupBuys(),
        ],
      ),
    );
  }

  Widget _buildGroupBuyHall() {
    final list = mock.MockData.groupBuyList;
    return Column(
      children: [
        // 筛选条
        Container(
          height: 44,
          color: Colors.white,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedFilter == _filters[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = _filters[index]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        // 拼团列表
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final gb = list[index];
              return GroupBuyCard(
                groupBuy: gb,
                onTap: () => _showGroupBuyDetail(gb),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyGroupBuys() {
    final progress = mock.MockData.myGroupBuyProgress;
    if (progress.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('还没有参与拼团', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('去大厅看看吧~', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: progress.length + 1, // +1 for the header
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '共 ${progress.length} 个拼团进行中',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          );
        }
        final item = progress[index - 1];
        return _buildProgressCard(item);
      },
    );
  }

  Widget _buildProgressCard(UserGroupBuyProgress item) {
    final stages = [
      _StageData('已付定金', item.hasPaidDeposit, Icons.payments),
      _StageData('等待补款', item.waitingForSupplement, Icons.schedule),
      _StageData('已发货', item.shipped, Icons.local_shipping),
      _StageData('已收货', item.received, Icons.check_circle),
    ];

    // 计算当前阶段
    int activeStage = 0;
    if (item.received) activeStage = 3;
    else if (item.shipped) activeStage = 2;
    else if (item.waitingForSupplement) activeStage = 1;
    else if (item.hasPaidDeposit) activeStage = 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          // 进度条
          Row(
            children: List.generate(stages.length, (i) {
              final isActive = i <= activeStage;
              final isLast = i == stages.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    // 阶段图标
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? const Color(0xFF6C5CE7) : Colors.grey[200],
                      ),
                      child: Icon(stages[i].icon, size: 14, color: isActive ? Colors.white : Colors.grey[400]),
                    ),
                    // 连线
                    if (!isLast)
                      Expanded(
                        child: Container(height: 2, color: i < activeStage ? const Color(0xFF6C5CE7) : Colors.grey[200]),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // 阶段文字
          Row(
            children: List.generate(stages.length, (i) {
              final isActive = i <= activeStage;
              return Expanded(
                child: Text(
                  stages[i].label,
                  textAlign: i == 0 ? TextAlign.left : i == stages.length - 1 ? TextAlign.right : TextAlign.center,
                  style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF6C5CE7) : Colors.grey[400]),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          // 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (item.status == GroupBuyStatus.recruiting)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('查看详情', style: TextStyle(fontSize: 12, color: Color(0xFF6C5CE7), fontWeight: FontWeight.w500)),
                ),
              if (item.waitingForSupplement)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('去补款', style: TextStyle(fontSize: 12, color: Color(0xFFE53935), fontWeight: FontWeight.w500)),
                ),
              if (item.received)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('已完成', style: TextStyle(fontSize: 12, color: Color(0xFF4CAF50), fontWeight: FontWeight.w500)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGroupBuyDetail(GroupBuyModel gb) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GroupBuyDetailSheet(groupBuy: gb),
    );
  }
}

class _GroupBuyDetailSheet extends StatelessWidget {
  final GroupBuyModel groupBuy;
  const _GroupBuyDetailSheet({required this.groupBuy});

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
          // 拖拽指示器
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
                  // IP + 状态
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(groupBuy.ip.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C5CE7))),
                    ),
                    const SizedBox(width: 8),
                    if (groupBuy.characterName.isNotEmpty)
                      Text(groupBuy.characterName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: groupBuy.status == GroupBuyStatus.recruiting
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        groupBuy.status == GroupBuyStatus.recruiting ? '招募中' :
                        groupBuy.status == GroupBuyStatus.full ? '已满员' : '已完成',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500,
                          color: groupBuy.status == GroupBuyStatus.recruiting
                              ? const Color(0xFF4CAF50) : Colors.grey[600],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  // 标题
                  Text(groupBuy.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // 团长信息
                  Row(children: [
                    CircleAvatar(radius: 16, backgroundColor: Colors.grey[300]),
                    const SizedBox(width: 8),
                    Text('团长: ${groupBuy.leaderNickname}', style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
                  ]),
                  const SizedBox(height: 20),

                  // 进度卡片
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('成团进度', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        Text('剩余 ${remaining.inDays}天${remaining.inHours % 24}小时',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
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
                  ),
                  const SizedBox(height: 20),

                  // 价格
                  Row(children: [
                    const Text('定金 ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('¥${groupBuy.depositPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
                    if (groupBuy.finalPrice != null) ...[
                      const SizedBox(width: 12),
                      Text('+ 尾款 ¥${groupBuy.finalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ]),
                  const SizedBox(height: 20),

                  // 团规
                  const Text('团规说明', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _buildRuleRow('截团时间', deadlineFormat.format(groupBuy.deadline)),
                      const SizedBox(height: 6),
                      if (groupBuy.expectedShipDate != null)
                        _buildRuleRow('预计发货', DateFormat('MM月dd日').format(groupBuy.expectedShipDate!)),
                      const SizedBox(height: 6),
                      _buildRuleRow('邮费说明', groupBuy.shippingFeeRule),
                      const SizedBox(height: 6),
                      _buildRuleRow('团规', groupBuy.rules),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // 上车列表
                  const Text('上车列表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...List.generate(groupBuy.totalCount, (i) {
                    final isOccupied = i < groupBuy.memberIds!.length;
                    final isMe = i == 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF6C5CE7).withOpacity(0.06) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: isMe ? Border.all(color: const Color(0xFF6C5CE7).withOpacity(0.3)) : null,
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
                              color: const Color(0xFF6C5CE7).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('已付定金', style: TextStyle(fontSize: 10, color: Color(0xFF6C5CE7))),
                          ),
                        ],
                      ]),
                    );
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          // 底部操作
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 48,
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
                    groupBuy.status == GroupBuyStatus.recruiting ? '一键上车 · 支付定金 ¥${groupBuy.depositPrice.toStringAsFixed(0)}' :
                    groupBuy.status == GroupBuyStatus.full ? '已满员' : '已完成',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF333333)))),
    ]);
  }
}

class _StageData {
  final String label;
  final bool isCompleted;
  final IconData icon;
  _StageData(this.label, this.isCompleted, this.icon);
}