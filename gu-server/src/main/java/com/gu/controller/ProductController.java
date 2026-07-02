package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.Product;
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
            @RequestParam(required = false) String ipId,
            @RequestParam(required = false) String categoryId) {
        List<Product> products = productService.getAllProducts();
        if (ipId != null) products = products.stream().filter(p -> p.getIp().getId().equals(ipId)).toList();
        if (categoryId != null) products = products.stream().filter(p -> p.getCategory().getId().equals(categoryId)).toList();

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
    public ApiResponse<Map<String, Object>> getById(@PathVariable String id) {
        Product p = productService.getProductById(id);
        if (p == null) return ApiResponse.error(404, "Product not found");
        return ApiResponse.success(toProductMap(p));
    }

    @GetMapping("/{id}/recommendations")
    public ApiResponse<List<Map<String, Object>>> getRecommendations(@PathVariable String id) {
        List<Product> recs = productService.getRecommendations(id);
        List<Map<String, Object>> result = recs.stream().map(this::toProductMap).collect(Collectors.toList());
        if (result.size() < 4) {
            // Fill with some other products if not enough recommendations
            List<Product> allOthers = productService.getAllProducts().stream()
                .filter(p -> !p.getId().equals(id))
                .filter(p -> result.stream().noneMatch(r -> r.get("id").equals(p.getId())))
                .toList();
            for (int i = 0; result.size() < 4 && i < allOthers.size(); i++) {
                result.add(toProductMap(allOthers.get(i)));
            }
        }
        return ApiResponse.success(result);
    }

    private Map<String, Object> toProductMap(Product p) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", p.getId());
        map.put("title", p.getTitle());
        map.put("imageUrls", splitToList(p.getImageUrls()));
        map.put("price", p.getPrice());
        map.put("depositPrice", p.getDepositPrice());
        map.put("finalPrice", p.getFinalPrice());
        map.put("ip", Map.of(
            "id", p.getIp().getId(),
            "name", p.getIp().getName(),
            "iconUrl", p.getIp().getIconUrl() != null ? p.getIp().getIconUrl() : "",
            "characters", splitToList(p.getIp().getCharacters())
        ));
        map.put("characterName", p.getCharacterName() != null ? p.getCharacterName() : "");
        map.put("category", Map.of(
            "id", p.getCategory().getId(),
            "name", p.getCategory().getName(),
            "icon", p.getCategory().getIcon() != null ? p.getCategory().getIcon() : ""
        ));
        map.put("tradeType", p.getTradeType());
        map.put("status", p.getStatus());
        map.put("condition", p.getCondition());
        map.put("seller", Map.of(
            "id", p.getSeller().getId(),
            "nickname", p.getSeller().getNickname(),
            "avatarUrl", p.getSeller().getAvatarUrl() != null ? p.getSeller().getAvatarUrl() : "",
            "creditScore", p.getSeller().getCreditScore(),
            "completedOrders", p.getSeller().getCompletedOrders(),
            "goodRate", p.getSeller().getGoodRate(),
            "isVerified", p.getSeller().isVerified()
        ));
        map.put("rating", p.getRating());
        map.put("salesCount", p.getSalesCount());
        map.put("favoriteCount", p.getFavoriteCount());
        map.put("tags", splitToList(p.getTags()));
        map.put("groupBuyId", p.getGroupBuyId());
        map.put("finalPaymentDeadline", p.getFinalPaymentDeadline());
        map.put("isSpot", p.isSpot());
        map.put("isNew", p.isNew());
        map.put("sizeInfo", p.getSizeInfo());
        map.put("productionTime", p.getProductionTime());
        map.put("includedParts", splitToList(p.getIncludedParts()));
        map.put("materialInfo", p.getMaterialInfo());
        map.put("defectsDescription", p.getDefectsDescription());
        map.put("sellerCompletedOrders", p.getSellerCompletedOrders());
        map.put("sellerGoodRate", p.getSellerGoodRate());
        return map;
    }

    private List<String> splitToList(String str) {
        if (str == null || str.trim().isEmpty()) return List.of();
        return Arrays.stream(str.split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }
}