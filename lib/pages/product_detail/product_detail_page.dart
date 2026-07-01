// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 商品详情页 — 解决非标品信任问题
library;

import 'package:flutter/material.dart';
import 'package:gu_app/data/mock_data.dart' as mock;
import 'package:gu_app/models/models.dart';
import 'package:gu_app/services/favorite_service.dart';
import 'package:gu_app/pages/product_detail/widgets/order_bottom_sheet.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,##0.00', 'zh_CN');
    final p = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(p.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          // 商品图片
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Color(mock.MockData.getPlaceholderColor(p.id.hashCode)),
              child: p.imageUrls.isNotEmpty && p.imageUrls.first.isNotEmpty
                  ? Image.network(p.imageUrls.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity)
                  : _buildPlaceholder(p),
            ),
          ),
          // 内容区
          _buildBasicInfo(p, priceFormat),
          _buildSellerCredit(p),
          if (p.sizeInfo != null || p.productionTime != null)
            _buildCosplayInfo(p),
          _buildTradeMode(p),
          _buildProductDetail(),
          _buildRecommendations(),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(p, priceFormat),
    );
  }

  Widget _buildBasicInfo(ProductModel p, NumberFormat priceFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              spacing: 6,
              runSpacing: 6,
              children: p.tags
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color:
                                const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(tag,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF6C5CE7))),
                      ))
                  .toList()),
          const SizedBox(height: 10),
          Text(p.title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, height: 1.4)),
          const SizedBox(height: 8),
          Row(children: [
            _buildInfoChip(Icons.movie, p.ip.name),
            const SizedBox(width: 12),
            _buildInfoChip(Icons.person,
                p.characterName.isNotEmpty ? p.characterName : '通用'),
            const SizedBox(width: 12),
            _buildInfoChip(Icons.shopping_bag, p.category.name),
          ]),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('¥${priceFormat.format(p.price)}',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935))),
            if (p.depositPrice != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4)),
                child: Text('定金¥${priceFormat.format(p.depositPrice)}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF9800),
                        fontWeight: FontWeight.w500)),
              ),
            ],
            const Spacer(),
            Text('已售${p.salesCount}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ]),
          const SizedBox(height: 6),
          if (p.tradeType == TradeType.depositFinal && p.finalPrice != null)
            Row(children: [
              Text('尾款 ¥${priceFormat.format(p.finalPrice)}',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF757575))),
              if (p.finalPaymentDeadline != null) ...[
                const SizedBox(width: 12),
                Icon(Icons.timer_outlined, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text(
                    '尾款截止 ${DateFormat('MM-dd').format(p.finalPaymentDeadline!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ]),
          const SizedBox(height: 12),
          Row(children: [
            _buildTag('担保交易', const Color(0xFF4CAF50), Icons.verified),
            const SizedBox(width: 8),
            _buildTag(
                p.isNew ? '全新' : '二手', Colors.grey[600]!, Icons.info_outline),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildTag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSellerCredit(ProductModel p) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(children: [
        CircleAvatar(radius: 22, backgroundColor: Colors.grey[300]),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(p.seller.nickname,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              if (p.seller.isVerified)
                const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified,
                        color: Color(0xFF6C5CE7), size: 16)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4)),
                child: Text('信用${p.seller.creditScore}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF4CAF50))),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
                '历史成交 ${p.sellerCompletedOrders} 笔 · 好评率 ${(p.sellerGoodRate * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ]),
        ),
        TextButton(
            onPressed: () {},
            child: const Text('联系卖家', style: TextStyle(fontSize: 12))),
      ]),
    );
  }

  Widget _buildCosplayInfo(ProductModel p) {
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
          _buildInfoRow('尺码表', p.sizeInfo!),
          const Divider(height: 20)
        ],
        if (p.productionTime != null) ...[
          _buildInfoRow('工期说明', p.productionTime!),
          const Divider(height: 20)
        ],
        if (p.includedParts != null && p.includedParts!.isNotEmpty) ...[
          _buildInfoRow('配件清单', p.includedParts!.join('、')),
          const Divider(height: 20)
        ],
        if (p.materialInfo != null) ...[
          _buildInfoRow('材质说明', p.materialInfo!),
          const Divider(height: 20)
        ],
        if (p.defectsDescription != null) ...[
          _buildInfoRow('瑕疵说明', p.defectsDescription!,
              color: const Color(0xFFFF9800))
        ],
      ]),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
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

  Widget _buildTradeMode(ProductModel p) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.swap_horiz, size: 18, color: Color(0xFF6C5CE7)),
          const SizedBox(width: 6),
          const Text('交易方式',
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

  Widget _buildProductDetail() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child:
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('商品详情',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 12),
        Text(
            '此处展示详细的商品图文描述、材质特写、上身效果图等内容。\n\n'
            '卖家会在发布时填写详细的商品描述信息，包括但不限于：\n'
            '• 商品实拍多图 / 视频\n'
            '• 细节特写\n'
            '• 尺寸测量\n'
            '• 购买记录凭证',
            style:
                TextStyle(fontSize: 13, color: Color(0xFF757575), height: 1.6)),
      ]),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('猜你喜欢',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(
                              mock.MockData.getPlaceholderColor(index + 10)),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('推荐商品 ${index + 1}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              const Text('¥99.00',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE53935))),
                            ]),
                      ),
                    ]),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildPlaceholder(ProductModel p) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 60, color: Colors.white38),
          const SizedBox(height: 8),
          Text(
            '${p.ip.name} · ${p.characterName}',
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductModel p, NumberFormat priceFormat) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(children: [
          ListenableBuilder(
            listenable: FavoriteService(),
            builder: (context, _) {
              final isFav = FavoriteService().isFavorited(p.id);
              return GestureDetector(
                onTap: () => FavoriteService().toggle(p.id),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(children: [
                    Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color:
                            isFav ? const Color(0xFFE53935) : Colors.grey[600],
                        size: 22),
                    Text(isFav ? '已收藏' : '收藏',
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey[600])),
                  ]),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(children: [
                Icon(Icons.chat_bubble_outline,
                    color: Colors.grey[600], size: 22),
                Text('联系',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF6C5CE7))),
              child: const Center(
                  child: Text('加入购物车',
                      style: TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.w600,
                          fontSize: 14))),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => OrderBottomSheet(product: p),
                );
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]),
                ),
                child: const Center(
                    child: Text('立即购买',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14))),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ]),
      ),
    );
  }
}
