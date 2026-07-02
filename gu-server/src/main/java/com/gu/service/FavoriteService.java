// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.service;

import com.gu.admin.entity.AdminProduct;
import com.gu.admin.entity.AdminProductImage;
import com.gu.model.entity.Favorite;
import com.gu.repository.FavoriteRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final ProductService productService;
    private static final String CURRENT_USER = "u_current";

    public FavoriteService(FavoriteRepository favoriteRepository,
                           ProductService productService) {
        this.favoriteRepository = favoriteRepository;
        this.productService = productService;
    }

    public List<Long> getFavoriteIds(String userId) {
        return favoriteRepository.findByUserId(userId)
                .stream().map(Favorite::getProductId).toList();
    }

    public List<String> getFavoriteStringIds(String userId) {
        return getFavoriteIds(userId).stream()
                .map(String::valueOf).toList();
    }

    public List<Map<String, Object>> getFavoriteProductMaps(String userId) {
        List<Long> ids = getFavoriteIds(userId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Long id : ids) {
            AdminProduct p = productService.getProductByIdWithImages(id);
            if (p != null) {
                result.add(toProductMap(p));
            }
        }
        return result;
    }

    public boolean toggle(Long productId) {
        boolean exists = favoriteRepository.existsByUserIdAndProductId(CURRENT_USER, productId);
        if (exists) {
            favoriteRepository.deleteByUserIdAndProductId(CURRENT_USER, productId);
            return false;
        } else {
            Favorite fav = new Favorite();
            fav.setUserId(CURRENT_USER);
            fav.setProductId(productId);
            favoriteRepository.save(fav);
            return true;
        }
    }

    private Map<String, Object> toProductMap(AdminProduct p) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(p.getId()));
        map.put("title", p.getName());
        map.put("description", p.getDescription() != null ? p.getDescription() : "");
        map.put("price", p.getPrice());
        map.put("stock", p.getStock());

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
        map.put("category", Map.of(
                "id", p.getCategoryId() != null ? String.valueOf(p.getCategoryId()) : "0",
                "name", "", "icon", ""));
        map.put("ip", Map.of("id", "", "name", "", "iconUrl", "", "characters", List.of()));
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