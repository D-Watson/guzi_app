// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 商品图片头部 — 支持本地 asset 与网络图片，加载失败自动回退占位图
library;

import 'package:flutter/material.dart';
import 'package:gu_app/models/models.dart';
import 'package:gu_app/utils/colors.dart';

class ProductImageHeader extends StatelessWidget {
  final ProductModel product;

  const ProductImageHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        color: Color(AppColors.getPlaceholderColor(product.id.hashCode)),
        child: _buildImage(),
      ),
    );
  }

  String? get _imageUrl {
    if (product.imageUrls.isEmpty) return null;
    final url = product.imageUrls.first.trim();
    return url.isEmpty ? null : url;
  }

  bool get _isAsset => _imageUrl?.startsWith('assets/') ?? false;

  Widget _buildImage() {
    final url = _imageUrl;
    if (url == null) return _buildPlaceholder();

    if (_isAsset) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    // 网络图片
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            color: Colors.white,
            strokeWidth: 2,
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 60, color: Colors.white38),
          const SizedBox(height: 8),
          Text(
            '${product.ip.name} · ${product.characterName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}