package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.dto.FavoriteToggleResponse;
import com.gu.model.entity.Product;
import com.gu.service.FavoriteService;
import com.gu.service.ProductService;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {
    private final FavoriteService favoriteService;
    private final ProductService productService;

    public FavoriteController(FavoriteService favoriteService, ProductService productService) {
        this.favoriteService = favoriteService;
        this.productService = productService;
    }

    @GetMapping
    public ApiResponse<List<String>> getFavorites() {
        return ApiResponse.success(favoriteService.getFavoriteIds("u_current"));
    }

    @GetMapping("/products")
    public ApiResponse<Map<String, Object>> getFavoriteProducts() {
        List<Product> products = favoriteService.getFavoriteProducts("u_current");
        // Use a simple map to avoid circular references
        List<Map<String, Object>> mapped = new ArrayList<>();
        for (Product p : products) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId()); m.put("title", p.getTitle());
            m.put("imageUrls", splitToList(p.getImageUrls()));
            m.put("price", p.getPrice()); m.put("depositPrice", p.getDepositPrice());
            m.put("ip", Map.of("id", p.getIp().getId(), "name", p.getIp().getName(), "iconUrl", p.getIp().getIconUrl() != null ? p.getIp().getIconUrl() : "", "characters", splitToList(p.getIp().getCharacters())));
            m.put("characterName", p.getCharacterName() != null ? p.getCharacterName() : "");
            m.put("category", Map.of("id", p.getCategory().getId(), "name", p.getCategory().getName(), "icon", p.getCategory().getIcon() != null ? p.getCategory().getIcon() : ""));
            m.put("tradeType", p.getTradeType()); m.put("condition", p.getCondition());
            m.put("seller", Map.of("id", p.getSeller().getId(), "nickname", p.getSeller().getNickname(), "avatarUrl", p.getSeller().getAvatarUrl() != null ? p.getSeller().getAvatarUrl() : "", "creditScore", p.getSeller().getCreditScore(), "completedOrders", p.getSeller().getCompletedOrders(), "goodRate", p.getSeller().getGoodRate(), "isVerified", p.getSeller().isVerified()));
            m.put("rating", p.getRating()); m.put("salesCount", p.getSalesCount()); m.put("favoriteCount", p.getFavoriteCount());
            m.put("tags", splitToList(p.getTags()));
            m.put("isSpot", p.isSpot()); m.put("isNew", p.isNew());
            m.put("sellerCompletedOrders", p.getSellerCompletedOrders()); m.put("sellerGoodRate", p.getSellerGoodRate());
            mapped.add(m);
        }
        return ApiResponse.success(Map.of("content", mapped, "totalElements", mapped.size(), "totalPages", 1, "number", 0, "size", 20));
    }

    @PostMapping("/{productId}")
    public ApiResponse<FavoriteToggleResponse> add(@PathVariable String productId) {
        boolean nowFavorited = favoriteService.toggle(productId);
        return ApiResponse.success(new FavoriteToggleResponse(productId, nowFavorited));
    }

    @DeleteMapping("/{productId}")
    public ApiResponse<FavoriteToggleResponse> remove(@PathVariable String productId) {
        boolean nowFavorited = favoriteService.toggle(productId);
        return ApiResponse.success(new FavoriteToggleResponse(productId, nowFavorited));
    }

    private List<String> splitToList(String str) {
        if (str == null || str.trim().isEmpty()) return List.of();
        return Arrays.stream(str.split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }
}