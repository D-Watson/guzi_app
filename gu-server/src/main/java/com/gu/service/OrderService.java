package com.gu.service;

import com.gu.model.entity.Order;
import com.gu.model.entity.Product;
import com.gu.repository.OrderRepository;
import com.gu.repository.ProductRepository;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private static final String CURRENT_USER = "u_current";

    public OrderService(OrderRepository orderRepository, ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
    }

    public List<Order> getUserOrders() {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(CURRENT_USER);
    }

    public Order createOrder(String productId, int quantity, String tradeType) {
        Product product = productRepository.findById(productId).orElse(null);
        if (product == null) throw new RuntimeException("Product not found: " + productId);

        BigDecimal total;
        String tradeTypeLabel;
        BigDecimal depositAmount = null;

        if ("depositFinal".equals(tradeType) && product.getDepositPrice() != null) {
            total = product.getDepositPrice().multiply(BigDecimal.valueOf(quantity));
            depositAmount = total;
            tradeTypeLabel = "定金+尾款";
        } else {
            total = product.getPrice().multiply(BigDecimal.valueOf(quantity));
            tradeTypeLabel = "一口价";
        }

        Order order = new Order();
        order.setId("ORD_" + System.currentTimeMillis());
        order.setUserId(CURRENT_USER);
        order.setProductId(productId);
        order.setProductTitle(product.getTitle());
        order.setProductPrice(product.getPrice());
        order.setProductImageUrl(
            product.getImageUrls() != null && !product.getImageUrls().isEmpty()
                ? product.getImageUrls().split(",")[0] : "");
        order.setTradeTypeLabel(tradeTypeLabel);
        order.setDepositAmount(depositAmount);
        order.setTotalAmount(total);
        order.setQuantity(quantity);
        order.setStatus("paid");
        order.setCreatedAt(LocalDateTime.now());

        return orderRepository.save(order);
    }
}