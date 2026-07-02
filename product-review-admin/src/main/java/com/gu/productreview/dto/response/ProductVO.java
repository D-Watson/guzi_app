package com.shizhuang.productreview.dto.response;

import com.shizhuang.productreview.entity.Product;
import com.shizhuang.productreview.entity.ProductImage;
import com.shizhuang.productreview.enums.ProductStatus;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class ProductVO {

    private Long id;
    private Long merchantId;
    private Long categoryId;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stock;
    private ProductStatus status;
    private String coverImage;
    private String rejectReason;
    private Long reviewerId;
    private Date reviewTime;
    private Date listedAt;
    private Date createTime;
    private List<String> images;

    public static ProductVO from(Product product) {
        ProductVO vo = new ProductVO();
        vo.setId(product.getId());
        vo.setMerchantId(product.getMerchantId());
        vo.setCategoryId(product.getCategoryId());
        vo.setName(product.getName());
        vo.setDescription(product.getDescription());
        vo.setPrice(product.getPrice());
        vo.setStock(product.getStock());
        vo.setStatus(product.getStatus());
        vo.setCoverImage(product.getCoverImage());
        vo.setRejectReason(product.getRejectReason());
        vo.setReviewerId(product.getReviewerId());
        vo.setReviewTime(product.getReviewTime());
        vo.setListedAt(product.getListedAt());
        vo.setCreateTime(product.getCreateTime());
        if (product.getImages() != null) {
            vo.setImages(product.getImages().stream()
                    .map(ProductImage::getUrl)
                    .collect(Collectors.toList()));
        }
        return vo;
    }
}