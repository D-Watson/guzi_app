package com.guzi.productreview.dto.response;

import lombok.Data;

@Data
public class UploadVO {

    private String url;
    private String originalName;
    private long size;
}