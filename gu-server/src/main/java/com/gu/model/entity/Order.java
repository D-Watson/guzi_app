package com.gu.model.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
public class Order {
    @Id @Column(length = 32)
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

    public Order() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public String getProductTitle() { return productTitle; }
    public void setProductTitle(String productTitle) { this.productTitle = productTitle; }
    public BigDecimal getProductPrice() { return productPrice; }
    public void setProductPrice(BigDecimal productPrice) { this.productPrice = productPrice; }
    public String getProductImageUrl() { return productImageUrl; }
    public void setProductImageUrl(String productImageUrl) { this.productImageUrl = productImageUrl; }
    public String getTradeTypeLabel() { return tradeTypeLabel; }
    public void setTradeTypeLabel(String tradeTypeLabel) { this.tradeTypeLabel = tradeTypeLabel; }
    public BigDecimal getDepositAmount() { return depositAmount; }
    public void setDepositAmount(BigDecimal depositAmount) { this.depositAmount = depositAmount; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}