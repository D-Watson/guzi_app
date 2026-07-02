// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.admin.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "product")
public class AdminProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "merchant_id", nullable = false)
    private Long merchantId;

    @Column(name = "category_id")
    private Long categoryId;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    private Integer stock = 0;

    @Column(nullable = false, length = 20)
    private String status;

    @Column(name = "cover_image", length = 500)
    private String coverImage;

    @Column(name = "reject_reason", length = 500)
    private String rejectReason;

    @Column(name = "reviewer_id")
    private Long reviewerId;

    @Column(name = "review_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date reviewTime;

    @Column(name = "listed_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date listedAt;

    @Column(name = "create_time", nullable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createTime;

    @Column(name = "update_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updateTime;

    @Column(name = "deleted")
    private Boolean deleted = false;

    @Transient
    private List<AdminProductImage> images;

    public AdminProduct() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }

    public Long getReviewerId() { return reviewerId; }
    public void setReviewerId(Long reviewerId) { this.reviewerId = reviewerId; }

    public Date getReviewTime() { return reviewTime; }
    public void setReviewTime(Date reviewTime) { this.reviewTime = reviewTime; }

    public Date getListedAt() { return listedAt; }
    public void setListedAt(Date listedAt) { this.listedAt = listedAt; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }

    public Boolean getDeleted() { return deleted; }
    public void setDeleted(Boolean deleted) { this.deleted = deleted; }

    public List<AdminProductImage> getImages() { return images; }
    public void setImages(List<AdminProductImage> images) { this.images = images; }
}