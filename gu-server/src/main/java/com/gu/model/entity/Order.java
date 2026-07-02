package com.gu.model.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
@Data
public class Order {
    @Id
    @Column(length = 32)
    private String id;
    @Column(length = 32)
    private String userId;
    @Column(name = "product_id")
    private Long productId;
    @Column(nullable = false, length = 200)
    private String productTitle;
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal productPrice;
    @Column(length = 500)
    private String productImageUrl = "";
    @Column(length = 50)
    private String tradeTypeLabel = "一口价";
    @Column(precision = 10, scale = 2)
    private BigDecimal depositAmount;
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;
    private int quantity = 1;
    @Column(length = 20)
    private String status = "pendingPayment";
    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

}