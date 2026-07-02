// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 拼团广场 — 最大差异化武器
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/widgets/common/group_buy_card.dart';
import 'package:gu_app/pages/group_buy/widgets/filter_bar.dart';
import 'package:gu_app/pages/group_buy/widgets/progress_card.dart';
import 'package:gu_app/pages/group_buy/widgets/group_buy_detail_sheet.dart';
import 'package:gu_app/services/group_buy_service.dart';

class GroupBuyPage extends StatefulWidget {
  const GroupBuyPage({super.key});

  @override
  State<GroupBuyPage> createState() => _GroupBuyPageState();
}

class _GroupBuyPageState extends State<GroupBuyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = '全部';

  final List<String> _filters = [
    '全部', '原神', '排球少年', '咒术回战', '蓝色监狱', '即将截团', '最热'
  ];

  List<GroupBuyModel> _groupBuys = [];
  List<UserGroupBuyProgress> _myProgress = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        GroupBuyService().getGroupBuys(),
        GroupBuyService().getMyProgress(),
      ]);
      if (mounted) {
        setState(() {
          _groupBuys = results[0] as List<GroupBuyModel>;
          _myProgress = results[1] as List<UserGroupBuyProgress>;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
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
        title: const Text('拼团广场',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGroupBuyHall(),
                _buildMyGroupBuys(),
              ],
            ),
    );
  }

  Widget _buildGroupBuyHall() {
    return Column(
      children: [
        FilterBar(
          filters: _filters,
          selectedFilter: _selectedFilter,
          onFilterChanged: (f) => setState(() => _selectedFilter = f),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            itemCount: _groupBuys.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final gb = _groupBuys[index];
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
    if (_myProgress.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('还没有参与拼团',
                style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('去大厅看看吧~',
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: _myProgress.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '共 ${_myProgress.length} 个拼团进行中',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          );
        }
        return ProgressCard(progress: _myProgress[index - 1]);
      },
    );
  }

  void _showGroupBuyDetail(GroupBuyModel gb) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GroupBuyDetailSheet(groupBuy: gb),
    );
  }
}