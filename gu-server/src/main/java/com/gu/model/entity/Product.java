package com.gu.model.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "products")
public class Product {
    @Id @Column(length = 32)
    private String id;
    @Column(nullable = false, length = 200)
    private String title;
    @Column(columnDefinition = "TEXT")
    private String imageUrls = "";
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;
    @Column(precision = 10, scale = 2)
    private BigDecimal depositPrice;
    @Column(precision = 10, scale = 2)
    private BigDecimal finalPrice;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ip_id", nullable = false)
    private Ip ip;
    @Column(length = 50)
    private String characterName = "";
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;
    @Column(nullable = false, length = 20)
    private String tradeType = "fixedPrice";
    @Column(length = 20)
    private String status = "active";
    @Column(length = 20)
    private String condition = "brandNew";
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "seller_id", nullable = false)
    private User seller;
    private double rating = 5.0;
    private int salesCount = 0;
    private int favoriteCount = 0;
    @Column(columnDefinition = "TEXT")
    private String tags = "";
    @Column(length = 32)
    private String groupBuyId;
    private LocalDateTime finalPaymentDeadline;
    private boolean isSpot = false;
    private boolean isNew = true;
    @Column(length = 500)
    private String sizeInfo;
    @Column(length = 200)
    private String productionTime;
    @Column(columnDefinition = "TEXT")
    private String includedParts;
    @Column(length = 500)
    private String materialInfo;
    @Column(columnDefinition = "TEXT")
    private String defectsDescription;
    private int sellerCompletedOrders = 0;
    private double sellerGoodRate = 1.0;
    private LocalDateTime createdAt = LocalDateTime.now();

    public Product() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getImageUrls() { return imageUrls; }
    public void setImageUrls(String imageUrls) { this.imageUrls = imageUrls; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public BigDecimal getDepositPrice() { return depositPrice; }
    public void setDepositPrice(BigDecimal depositPrice) { this.depositPrice = depositPrice; }
    public BigDecimal getFinalPrice() { return finalPrice; }
    public void setFinalPrice(BigDecimal finalPrice) { this.finalPrice = finalPrice; }
    public Ip getIp() { return ip; }
    public void setIp(Ip ip) { this.ip = ip; }
    public String getCharacterName() { return characterName; }
    public void setCharacterName(String characterName) { this.characterName = characterName; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public String getTradeType() { return tradeType; }
    public void setTradeType(String tradeType) { this.tradeType = tradeType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }
    public User getSeller() { return seller; }
    public void setSeller(User seller) { this.seller = seller; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public int getSalesCount() { return salesCount; }
    public void setSalesCount(int salesCount) { this.salesCount = salesCount; }
    public int getFavoriteCount() { return favoriteCount; }
    public void setFavoriteCount(int favoriteCount) { this.favoriteCount = favoriteCount; }
    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
    public String getGroupBuyId() { return groupBuyId; }
    public void setGroupBuyId(String groupBuyId) { this.groupBuyId = groupBuyId; }
    public LocalDateTime getFinalPaymentDeadline() { return finalPaymentDeadline; }
    public void setFinalPaymentDeadline(LocalDateTime finalPaymentDeadline) { this.finalPaymentDeadline = finalPaymentDeadline; }
    public boolean isSpot() { return isSpot; }
    public void setSpot(boolean spot) { isSpot = spot; }
    public boolean isNew() { return isNew; }
    public void setNew(boolean aNew) { isNew = aNew; }
    public String getSizeInfo() { return sizeInfo; }
    public void setSizeInfo(String sizeInfo) { this.sizeInfo = sizeInfo; }
    public String getProductionTime() { return productionTime; }
    public void setProductionTime(String productionTime) { this.productionTime = productionTime; }
    public String getIncludedParts() { return includedParts; }
    public void setIncludedParts(String includedParts) { this.includedParts = includedParts; }
    public String getMaterialInfo() { return materialInfo; }
    public void setMaterialInfo(String materialInfo) { this.materialInfo = materialInfo; }
    public String getDefectsDescription() { return defectsDescription; }
    public void setDefectsDescription(String defectsDescription) { this.defectsDescription = defectsDescription; }
    public int getSellerCompletedOrders() { return sellerCompletedOrders; }
    public void setSellerCompletedOrders(int sellerCompletedOrders) { this.sellerCompletedOrders = sellerCompletedOrders; }
    public double getSellerGoodRate() { return sellerGoodRate; }
    public void setSellerGoodRate(double sellerGoodRate) { this.sellerGoodRate = sellerGoodRate; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}