package com.guzi.productreview.entity;

import com.guzi.productreview.enums.ProductStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "product")
public class Product extends BaseEntity {

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

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ProductStatus status = ProductStatus.DRAFT;

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

    @Transient
    private List<ProductImage> images;
}