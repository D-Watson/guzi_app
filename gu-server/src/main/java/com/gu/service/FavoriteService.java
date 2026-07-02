// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.service;

import com.gu.admin.entity.AdminProduct;
import com.gu.admin.entity.AdminProductImage;
import com.gu.model.entity.Favorite;
import com.gu.repository.FavoriteRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
                    .sorted(java.util.Comparator.comparingInt(AdminProductImage::getSortOrder))
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