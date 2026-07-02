// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.controller;

import com.gu.admin.entity.AdminProduct;
import com.gu.admin.entity.AdminProductImage;
import com.gu.model.dto.ApiResponse;
import com.gu.service.ProductService;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
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
        map.put("id", p.getId());
        map.put("title", p.getName());
        map.put("description", p.getDescription());
        map.put("price", p.getPrice());
        map.put("stock", p.getStock());
        map.put("coverImage", p.getCoverImage() != null ? p.getCoverImage() : "");
        map.put("categoryId", p.getCategoryId());

        List<String> imageUrls = new ArrayList<>();
        if (p.getImages() != null) {
            imageUrls = p.getImages().stream()
                    .sorted(Comparator.comparingInt(AdminProductImage::getSortOrder))
                    .map(AdminProductImage::getUrl)
                    .toList();
        }
        map.put("images", imageUrls);
        map.put("status", p.getStatus());
        map.put("listedAt", p.getListedAt());
        map.put("createTime", p.getCreateTime());
        return map;
    }
}