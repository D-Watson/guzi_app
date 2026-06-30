// SECURITY-REVIEWED: 2026-06-29 | RULES: v2.6.0-draft
/// 发布页 — 降低门槛，规范信息
library;

import 'package:flutter/material.dart';
import 'package:gu_app/data/mock_data.dart' as mock;
import 'package:gu_app/models/models.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  int _currentStep = 0;
  final _pageController = PageController();

  // 表单状态
  IPModel? _selectedIP;
  String? _selectedCharacter;
  CategoryModel? _selectedCategory;
  TradeType _tradeType = TradeType.fixedPrice;
  bool _isNew = true;
  bool _isSpot = true;

  final List<String> _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('发布商品', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        actions: [
          if (_currentStep > 0)
            TextButton(onPressed: () => _prevStep(), child: Text('上一步', style: TextStyle(color: Colors.grey[600]))),
        ],
      ),
      body: Column(
        children: [
          // 步骤指示器
          _buildStepIndicator(),
          // 步骤内容
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentStep = i),
              children: [
                _buildStep1SelectIP(),
                _buildStep2UploadMedia(),
                _buildStep3TradeMode(),
                _buildStep4PriceAndConfirm(),
              ],
            ),
          ),
          // 底部按钮
          _buildBottomButtons(),
          // 防骗提示
          if (_currentStep < 4)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFFFFF3E0),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFFF9800)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '请勿脱离平台交易，谨防诈骗！平台不会以任何理由要求您线下转账。',
                      style: TextStyle(fontSize: 11, color: Colors.orange[800], height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['选IP品类', '上传图文', '交易方式', '定价发布'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;
          return Expanded(
            child: Row(
              children: [
                // 圆圈
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

  // ========== Step 1: 选择IP和品类 ==========
  Widget _buildStep1SelectIP() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('选择作品 (IP)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          // IP 选择
          ...mock.MockData.ipList.map((ip) => _buildIPItem(ip)),
          const SizedBox(height: 24),
          if (_selectedIP != null) ...[
            const Text('选择角色', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _selectedIP!.characters.map((char) => ChoiceChip(
                label: Text(char),
                selected: _selectedCharacter == char,
                selectedColor: const Color(0xFF6C5CE7).withOpacity(0.2),
                onSelected: (selected) => setState(() => _selectedCharacter = selected ? char : null),
              )).toList(),
            ),
            const SizedBox(height: 24),
          ],
          const Text('选择品类', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: mock.MockData.categoryList.map((cat) => ChoiceChip(
              label: Text('${cat.icon} ${cat.name}'),
              selected: _selectedCategory?.id == cat.id,
              selectedColor: const Color(0xFF6C5CE7).withOpacity(0.2),
              onSelected: (selected) => setState(() => _selectedCategory = selected ? cat : null),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIPItem(IPModel ip) {
    final isSelected = _selectedIP?.id == ip.id;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedIP = ip;
        _selectedCharacter = null;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(
            color: Color(mock.MockData.getPlaceholderColor(ip.id.hashCode)),
            borderRadius: BorderRadius.circular(8),
          )),
          const SizedBox(width: 12),
          Expanded(child: Text(ip.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
          if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF6C5CE7), size: 20),
        ]),
      ),
    );
  }

  // ========== Step 2: 上传图文 ==========
  Widget _buildStep2UploadMedia() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('上传图片/视频', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('支持多图和视频，清晰的展示有助于更快卖出', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 12),
          // 上传区域
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == _imageUrls.length) {
                  return GestureDetector(
                    onTap: () => setState(() => _imageUrls.add('')),
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 28, color: Colors.grey),
                          SizedBox(height: 4),
                          Text('添加图片', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }
                return Stack(
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: Color(mock.MockData.getPlaceholderColor(index)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Icon(Icons.image, color: Colors.white38, size: 30)),
                    ),
                    Positioned(
                      top: 4, right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => _imageUrls.removeAt(index)),
                        child: Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          // C服专属强制填写区
          const Text('C服专属信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('如果商品属于 C服/道具 品类，建议完整填写以下信息', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 12),
          _buildFormField('尺码信息', hint: '如：S/M/L/XL，具体尺寸数据'),
          const SizedBox(height: 12),
          _buildFormField('工期说明', hint: '如：定制工期约30天，现货3天内发货'),
          const SizedBox(height: 12),
          _buildFormField('配件清单', hint: '如：外套、裙子、假发、道具等'),
          const SizedBox(height: 12),
          _buildFormField('材质说明', hint: '如：涤纶+仿丝绸'),
          const SizedBox(height: 12),
          _buildFormField('瑕疵说明', hint: '如有瑕疵请如实填写，无则写"无瑕疵"', maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333))),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  // ========== Step 3: 交易方式 ==========
  Widget _buildStep3TradeMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('选择交易方式', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),

        _buildTradeTypeCard(
          icon: Icons.sell, title: '一口价现货',
          desc: '买家直接付款，24小时内安排发货，适合有现货的卖家',
          isSelected: _tradeType == TradeType.fixedPrice,
          onTap: () => setState(() => _tradeType = TradeType.fixedPrice),
        ),
        const SizedBox(height: 10),
        _buildTradeTypeCard(
          icon: Icons.payments, title: '定金+尾款',
          desc: '买家先付定金锁定名额，到货后支付尾款，适合定制/预售商品',
          isSelected: _tradeType == TradeType.depositFinal,
          onTap: () => setState(() => _tradeType = TradeType.depositFinal),
        ),
        const SizedBox(height: 10),
        _buildTradeTypeCard(
          icon: Icons.groups, title: '发起拼团',
          desc: '招募同好一起购买，满员后统一发货，适合批量购买降低单价',
          isSelected: _tradeType == TradeType.groupBuy,
          onTap: () => setState(() => _tradeType = TradeType.groupBuy),
        ),
        const SizedBox(height: 24),

        if (_tradeType != TradeType.groupBuy) ...[
          const Text('商品状态', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildChoiceCard('全新', Icons.new_releases, _isNew, () => setState(() => _isNew = true))),
            const SizedBox(width: 12),
            Expanded(child: _buildChoiceCard('二手', Icons.replay, !_isNew, () => setState(() => _isNew = false))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildChoiceCard('现货', Icons.inventory_2, _isSpot, () => setState(() => _isSpot = true))),
            const SizedBox(width: 12),
            Expanded(child: _buildChoiceCard('预售/定制', Icons.schedule, !_isSpot, () => setState(() => _isSpot = false))),
          ]),
        ],
      ]),
    );
  }

  Widget _buildTradeTypeCard({required IconData icon, required String title, required String desc, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.06) : Colors.white,
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

  Widget _buildChoiceCard(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.08) : Colors.white,
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

  // ========== Step 4: 定价与确认 ==========
  Widget _buildStep4PriceAndConfirm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('定价与发布', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),

        _buildPriceField('售价（¥）', hint: '请输入商品价格'),
        const SizedBox(height: 12),
        if (_tradeType == TradeType.depositFinal) ...[
          _buildPriceField('定金（¥）', hint: '请输入定金金额'),
          const SizedBox(height: 12),
          _buildPriceField('尾款（¥）', hint: '请输入尾款金额（选填）'),
          const SizedBox(height: 12),
          _buildFormField('尾款截止时间', hint: '如：到货后7天内'),
        ],
        if (_tradeType == TradeType.groupBuy) ...[
          _buildPriceField('目标人数', hint: '满几人成团'),
          const SizedBox(height: 12),
          _buildPriceField('每人定金（¥）', hint: '请输入定金金额'),
          const SizedBox(height: 12),
          _buildFormField('拼团规则', hint: '描述截团时间、邮费说明、跑单规则等', maxLines: 4),
        ],
        const SizedBox(height: 12),
        _buildFormField('商品标题', hint: '如：原神·钟离「天星」C服全套'),
        const SizedBox(height: 12),
        _buildFormField('商品描述', hint: '描述商品的成色、使用情况、购买渠道等', maxLines: 4),

        const SizedBox(height: 24),
        // 发布预览
        const Text('发布预览', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (_selectedIP != null) Text('IP: ${_selectedIP!.name}${_selectedCharacter != null ? ' · $_selectedCharacter' : ''}', style: const TextStyle(fontSize: 13)),
            if (_selectedCategory != null) Text('品类: ${_selectedCategory!.icon} ${_selectedCategory!.name}', style: const TextStyle(fontSize: 13)),
            Text('交易方式: ${_tradeType == TradeType.fixedPrice ? "一口价" : _tradeType == TradeType.depositFinal ? "定金+尾款" : "拼团"}', style: const TextStyle(fontSize: 13)),
            Text('商品状态: ${_isNew ? "全新" : "二手"} · ${_isSpot ? "现货" : "预售/定制"}', style: const TextStyle(fontSize: 13)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPriceField(String label, {String? hint}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333))),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ),
    ]);
  }

  // ========== 导航按钮 ==========
  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // 发布
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('商品发布成功！'), backgroundColor: Color(0xFF4CAF50)),
      );
      Navigator.pop(context);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0: return _selectedIP != null && _selectedCategory != null;
      case 1: return true;
      case 2: return true;
      case 3: return true;
      default: return false;
    }
  }

  Widget _buildBottomButtons() {
    if (_currentStep > 3) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: _canProceed ? _nextStep : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
              elevation: 0,
            ),
            child: Text(
              _currentStep == 3 ? '确认发布' : '下一步',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _canProceed ? Colors.white : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }
}