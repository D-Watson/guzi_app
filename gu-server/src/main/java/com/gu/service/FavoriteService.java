package com.gu.service;

import com.gu.model.entity.Favorite;
import com.gu.model.entity.Product;
import com.gu.repository.FavoriteRepository;
import com.gu.repository.ProductRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class FavoriteService {
    private final FavoriteRepository favoriteRepository;
    private final ProductRepository productRepository;
    private static final String CURRENT_USER = "u_current";

    public FavoriteService(FavoriteRepository favoriteRepository,
                           ProductRepository productRepository) {
        this.favoriteRepository = favoriteRepository;
        this.productRepository = productRepository;
    }

    public List<String> getFavoriteIds(String userId) {
        return favoriteRepository.findByUserId(userId)
                .stream().map(Favorite::getProductId).toList();
    }

    public List<Product> getFavoriteProducts(String userId) {
        List<String> ids = getFavoriteIds(userId);
        return productRepository.findAllById(ids);
    }

    public boolean toggle(String productId) {
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
}