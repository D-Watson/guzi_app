package com.guzi.productreview.dto.query;

import lombok.Data;

@Data
public class UserPageQuery {

    private int page = 1;
    private int size = 10;

    private String status;
    private String keyword;
}