package com.shizhuang.productreview.common;

import lombok.Getter;

@Getter
public class ApiResult<T> {

    private int code;
    private String message;
    private T data;

    private ApiResult() {}

    public static <T> ApiResult<T> success(T data) {
        ApiResult<T> r = new ApiResult<>();
        r.code = 200;
        r.message = "success";
        r.data = data;
        return r;
    }

    public static <T> ApiResult<T> success() {
        return success(null);
    }

    public static <T> ApiResult<T> error(int code, String message) {
        ApiResult<T> r = new ApiResult<>();
        r.code = code;
        r.message = message;
        return r;
    }

    public static <T> ApiResult<T> error(String message) {
        return error(400, message);
    }

    public static <T> ApiResult<T> unauthorized(String message) {
        return error(401, message);
    }

    public static <T> ApiResult<T> forbidden(String message) {
        return error(403, message);
    }
}