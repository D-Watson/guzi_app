package com.gu.service;

import com.gu.model.entity.Product;
import com.gu.repository.ProductRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductService {
    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public Product getProductById(String id) {
        return productRepository.findById(id).orElse(null);
    }

    public List<Product> getRecommendations(String productId) {
        Product product = getProductById(productId);
        if (product == null) return List.of();
        return productRepository.findByIpIdAndIdNot(product.getIp().getId(), productId);
    }
}