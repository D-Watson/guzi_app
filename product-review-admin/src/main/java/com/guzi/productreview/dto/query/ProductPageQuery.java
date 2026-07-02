package com.guzi.productreview.dto.query;

import lombok.Data;

@Data
public class ProductPageQuery {

    private int page = 1;
    private int size = 10;

    private String status;
    private Long merchantId;
    private Long categoryId;
    private String keyword;
}