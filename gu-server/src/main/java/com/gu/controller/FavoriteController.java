// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.dto.FavoriteToggleResponse;
import com.gu.service.FavoriteService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {

    private final FavoriteService favoriteService;

    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @GetMapping
    public ApiResponse<List<Long>> getFavorites() {
        return ApiResponse.success(favoriteService.getFavoriteIds("u_current"));
    }

    @GetMapping("/products")
    public ApiResponse<Map<String, Object>> getFavoriteProducts() {
        List<Map<String, Object>> mapped = favoriteService.getFavoriteProductMaps("u_current");
        return ApiResponse.success(Map.of(
                "content", mapped,
                "totalElements", mapped.size(),
                "totalPages", 1,
                "number", 0,
                "size", 20
        ));
    }

    @PostMapping("/{productId}")
    public ApiResponse<FavoriteToggleResponse> add(@PathVariable Long productId) {
        boolean nowFavorited = favoriteService.toggle(productId);
        return ApiResponse.success(new FavoriteToggleResponse(productId, nowFavorited));
    }

    @DeleteMapping("/{productId}")
    public ApiResponse<FavoriteToggleResponse> remove(@PathVariable Long productId) {
        boolean nowFavorited = favoriteService.toggle(productId);
        return ApiResponse.success(new FavoriteToggleResponse(productId, nowFavorited));
    }
}