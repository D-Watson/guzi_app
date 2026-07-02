// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.service;

import com.gu.admin.entity.AdminProduct;
import com.gu.admin.repository.AdminProductImageRepository;
import com.gu.admin.repository.AdminProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final AdminProductRepository adminProductRepository;
    private final AdminProductImageRepository adminProductImageRepository;

    public ProductService(AdminProductRepository adminProductRepository,
                          AdminProductImageRepository adminProductImageRepository) {
        this.adminProductRepository = adminProductRepository;
        this.adminProductImageRepository = adminProductImageRepository;
    }

    public List<AdminProduct> getAllProducts() {
        List<AdminProduct> products = adminProductRepository
                .findByStatusAndDeletedFalseOrderByCreateTimeDesc("APPROVED");
        products.forEach(p -> p.setImages(
                adminProductImageRepository.findByProductIdOrderBySortOrderAsc(p.getId())));
        return products;
    }

    public List<AdminProduct> getAllProducts(Long categoryId) {
        List<AdminProduct> products = adminProductRepository
                .findByStatusAndDeletedFalseAndCategoryIdOrderByCreateTimeDesc("APPROVED", categoryId);
        products.forEach(p -> p.setImages(
                adminProductImageRepository.findByProductIdOrderBySortOrderAsc(p.getId())));
        return products;
    }

    public AdminProduct getProductById(Long id) {
        return adminProductRepository.findByIdAndDeletedFalse(id).orElse(null);
    }

    public AdminProduct getProductByIdWithImages(Long id) {
        AdminProduct product = getProductById(id);
        if (product != null) {
            product.setImages(
                    adminProductImageRepository.findByProductIdOrderBySortOrderAsc(id));
        }
        return product;
    }

    public List<AdminProduct> getRecommendations(Long productId) {
        AdminProduct product = getProductById(productId);
        if (product == null) return List.of();
        List<AdminProduct> sameCategory = adminProductRepository
                .findByStatusAndDeletedFalseAndCategoryIdOrderByCreateTimeDesc("APPROVED", product.getCategoryId());
        return sameCategory.stream()
                .filter(p -> !p.getId().equals(productId))
                .peek(p -> p.setImages(
                        adminProductImageRepository.findByProductIdOrderBySortOrderAsc(p.getId())))
                .toList();
    }
}