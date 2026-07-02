package com.guzi.productreview.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class ProductSubmitRequest {

    @NotBlank(message = "商品名称不能为空")
    private String name;

    private String description;

    @NotNull(message = "价格不能为空")
    private java.math.BigDecimal price;

    private Integer stock;

    private Long categoryId;

    private String coverImage;

    private List<String> images;
}