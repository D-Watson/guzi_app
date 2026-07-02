// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.controller;

import com.gu.admin.entity.AdminCategory;
import com.gu.admin.entity.AdminProduct;
import com.gu.admin.entity.AdminProductImage;
import com.gu.admin.repository.AdminCategoryRepository;
import com.gu.model.dto.ApiResponse;
import com.gu.service.ProductService;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;
    private final AdminCategoryRepository categoryRepository;

    public ProductController(ProductService productService,
                             AdminCategoryRepository categoryRepository) {
        this.productService = productService;
        this.categoryRepository = categoryRepository;
    }

    @GetMapping
    public ApiResponse<Map<String, Object>> getAll(
            @RequestParam(required = false) Long categoryId) {
        List<AdminProduct> products;
        if (categoryId != null) {
            products = productService.getAllProducts(categoryId);
        } else {
            products = productService.getAllProducts();
        }

        List<Map<String, Object>> content = products.stream().map(this::toProductMap).toList();
        return ApiResponse.success(Map.of(
                "content", content,
                "totalElements", content.size(),
                "totalPages", 1,
                "number", 0,
                "size", 20
        ));
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> getById(@PathVariable Long id) {
        AdminProduct p = productService.getProductByIdWithImages(id);
        if (p == null) return ApiResponse.error(404, "Product not found");
        return ApiResponse.success(toProductMap(p));
    }

    @GetMapping("/{id}/recommendations")
    public ApiResponse<List<Map<String, Object>>> getRecommendations(@PathVariable Long id) {
        List<AdminProduct> recs = productService.getRecommendations(id);
        List<Map<String, Object>> result = recs.stream().map(this::toProductMap).collect(Collectors.toList());
        if (result.size() < 4) {
            List<AdminProduct> allOthers = productService.getAllProducts().stream()
                    .filter(p -> !p.getId().equals(id))
                    .filter(p -> result.stream().noneMatch(r -> r.get("id").equals(p.getId())))
                    .toList();
            for (int i = 0; result.size() < 4 && i < allOthers.size(); i++) {
                result.add(toProductMap(allOthers.get(i)));
            }
        }
        return ApiResponse.success(result);
    }

    private Map<String, Object> toProductMap(AdminProduct p) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(p.getId()));
        map.put("title", p.getName());
        map.put("description", p.getDescription() != null ? p.getDescription() : "");
        map.put("price", p.getPrice());
        map.put("stock", p.getStock());

        // 图片列表：优先用 images，降级到 coverImage
        List<String> imageUrls = new ArrayList<>();
        if (p.getImages() != null && !p.getImages().isEmpty()) {
            imageUrls = p.getImages().stream()
                    .sorted(Comparator.comparingInt(AdminProductImage::getSortOrder))
                    .map(AdminProductImage::getUrl)
                    .collect(Collectors.toList());
        } else if (p.getCoverImage() != null && !p.getCoverImage().isEmpty()) {
            imageUrls = List.of(p.getCoverImage());
        }
        map.put("imageUrls", imageUrls);
        map.put("coverImage", p.getCoverImage() != null ? p.getCoverImage() : "");

        // 品类嵌套结构
        Map<String, Object> category = new LinkedHashMap<>();
        if (p.getCategoryId() != null) {
            AdminCategory cat = categoryRepository.findById(p.getCategoryId()).orElse(null);
            category.put("id", String.valueOf(p.getCategoryId()));
            category.put("name", cat != null ? cat.getName() : "");
            category.put("icon", cat != null && cat.getIcon() != null ? cat.getIcon() : "");
        } else {
            category.put("id", "0");
            category.put("name", "");
            category.put("icon", "");
        }
        map.put("category", category);
        map.put("categoryId", p.getCategoryId());

        // IP 占位（商品表暂无 IP 关联）
        map.put("ip", Map.of("id", "", "name", "", "iconUrl", "", "characters", List.of()));

        // 卖家占位（商品表暂无用户关联）
        map.put("seller", Map.of(
                "id", "", "nickname", "商家", "avatarUrl", "",
                "creditScore", 100, "completedOrders", 0,
                "goodRate", 1.0, "isVerified", false));

        map.put("tradeType", "fixedPrice");
        map.put("condition", "brandNew");
        map.put("status", p.getStatus());
        map.put("listedAt", p.getListedAt());
        map.put("createTime", p.getCreateTime());
        return map;
    }
}