// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.service;

import com.gu.admin.entity.AdminProduct;
import com.gu.model.entity.Order;
import com.gu.repository.OrderRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final ProductService productService;
    private static final String CURRENT_USER = "u_current";

    public OrderService(OrderRepository orderRepository, ProductService productService) {
        this.orderRepository = orderRepository;
        this.productService = productService;
    }

    public List<Order> getUserOrders() {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(CURRENT_USER);
    }

    public Order createOrder(Long productId, int quantity, String tradeType) {
        AdminProduct product = productService.getProductByIdWithImages(productId);
        if (product == null) throw new RuntimeException("Product not found: " + productId);

        BigDecimal total;
        String tradeTypeLabel;
        BigDecimal depositAmount = null;

        if ("depositFinal".equals(tradeType)) {
            total = product.getPrice().multiply(BigDecimal.valueOf(quantity));
            depositAmount = total;
            tradeTypeLabel = "定金+尾款";
        } else {
            total = product.getPrice().multiply(BigDecimal.valueOf(quantity));
            tradeTypeLabel = "一口价";
        }

        String coverImage = product.getCoverImage() != null ? product.getCoverImage() : "";
        if (coverImage.isEmpty() && product.getImages() != null && !product.getImages().isEmpty()) {
            coverImage = product.getImages().get(0).getUrl();
        }

        Order order = new Order();
        order.setId("ORD_" + System.currentTimeMillis());
        order.setUserId(CURRENT_USER);
        order.setProductId(productId);
        order.setProductTitle(product.getName());
        order.setProductPrice(product.getPrice());
        order.setProductImageUrl(coverImage);
        order.setTradeTypeLabel(tradeTypeLabel);
        order.setDepositAmount(depositAmount);
        order.setTotalAmount(total);
        order.setQuantity(quantity);
        order.setStatus("paid");
        order.setCreatedAt(LocalDateTime.now());

        return orderRepository.save(order);
    }
}