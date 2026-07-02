// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 吃谷App — 二次元周边交易平台
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gu_app/pages/home/home_page.dart';
import 'package:gu_app/pages/publish/publish_page.dart';
import 'package:gu_app/pages/group_buy/group_buy_page.dart';
import 'package:gu_app/pages/favorites/favorites_page.dart';
import 'package:gu_app/pages/orders/orders_page.dart';
import 'package:gu_app/services/favorite_service.dart';
import 'package:gu_app/services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'zh_CN';
  await initializeDateFormatting('zh_CN');

  // 初始化需提前加载的服务
  await FavoriteService().initialize();
  await OrderService().initialize();

  runApp(const GuApp());
}

class GuApp extends StatelessWidget {
  const GuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '吃谷',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7),
        useMaterial3: true,
        fontFamily: null,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    GroupBuyPage(),
    PublishPage(),
    _MessagePage(),
    _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C5CE7),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: '拼团',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 32),
            activeIcon: Icon(Icons.add_circle, size: 32),
            label: '发布',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

// ========== 占位页面 ==========

class _MessagePage extends StatelessWidget {
  const _MessagePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('消息', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('暂无消息', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('和卖家沟通从这里开始', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('我的', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 用户信息卡片
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: Color(0xFF6C5CE7), size: 32),
              ),
              const SizedBox(width: 16),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('谷子收藏家', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.verified, size: 14, color: Color(0xFF6C5CE7)),
                  SizedBox(width: 4),
                  Text('已实名 · 信用98', style: TextStyle(fontSize: 12, color: Color(0xFF757575))),
                ]),
              ]),
              const Spacer(),
              TextButton(onPressed: null, child: Text('编辑资料', style: TextStyle(fontSize: 12))),
            ]),
          ),
          const SizedBox(height: 16),
          // 交易数据
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('42', '成交', Icons.check_circle),
                _buildStatItem('99%', '好评率', Icons.star),
                ListenableBuilder(
                  listenable: FavoriteService(),
                  builder: (context, _) {
                    return _buildStatItem('${FavoriteService().count}', '收藏', Icons.favorite);
                  },
                ),
                _buildStatItem('3', '在售', Icons.sell),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 功能列表
          _buildMenuItem(context, Icons.shopping_bag_outlined, '我的订单', '查看全部订单', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersPage()));
          }),
          _buildMenuItem(context, Icons.inventory_2_outlined, '在售商品', '管理已发布的商品', () {}),
          _buildMenuItem(context, Icons.favorite_outline, '我的收藏', '收藏的商品和帖子', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
          }),
          _buildMenuItem(context, Icons.groups_outlined, '我的拼团', '参与的拼团进度', () {}),
          _buildMenuItem(context, Icons.history, '浏览历史', '最近浏览的商品', () {}),
          _buildMenuItem(context, Icons.settings_outlined, '设置', '账号与偏好设置', () {}),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(children: [
      Icon(icon, size: 20, color: const Color(0xFF6C5CE7)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
    ]);
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF6C5CE7)),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }
}