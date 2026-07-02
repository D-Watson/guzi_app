// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.admin.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "product_image")
public class AdminProductImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "product_id", nullable = false)
    private Long productId;

    @Column(nullable = false, length = 500)
    private String url;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(name = "create_time", nullable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createTime;

    public AdminProductImage() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}