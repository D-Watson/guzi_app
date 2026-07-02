package com.shizhuang.productreview.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PageResult<T> {

    private long total;
    private int page;
    private int size;
    private List<T> records;

    public static <T> PageResult<T> of(long total, int page, int size, List<T> records) {
        return new PageResult<>(total, page, size, records);
    }
}