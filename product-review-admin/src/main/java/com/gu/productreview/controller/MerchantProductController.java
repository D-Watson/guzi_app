package com.shizhuang.productreview.controller;

import com.shizhuang.productreview.common.ApiResult;
import com.shizhuang.productreview.dto.query.ProductPageQuery;
import com.shizhuang.productreview.dto.request.ProductSubmitRequest;
import com.shizhuang.productreview.dto.response.ProductVO;
import com.shizhuang.productreview.common.PageResult;
import com.shizhuang.productreview.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/merchant/products")
@RequiredArgsConstructor
@PreAuthorize("hasRole('MERCHANT')")
public class MerchantProductController {

    private final ProductService productService;

    @PostMapping
    public ApiResult<ProductVO> create(@AuthenticationPrincipal Long userId,
                                       @Valid @RequestBody ProductSubmitRequest request) {
        return ApiResult.success(productService.create(userId, request));
    }

    @PutMapping("/{id}")
    public ApiResult<ProductVO> update(@AuthenticationPrincipal Long userId,
                                       @PathVariable Long id,
                                       @Valid @RequestBody ProductSubmitRequest request) {
        return ApiResult.success(productService.update(userId, id, request));
    }

    @PostMapping("/{id}/submit")
    public ApiResult<Void> submit(@AuthenticationPrincipal Long userId, @PathVariable Long id) {
        productService.submit(userId, id);
        return ApiResult.success();
    }

    @GetMapping
    public ApiResult<PageResult<ProductVO>> list(@AuthenticationPrincipal Long userId, ProductPageQuery query) {
        return ApiResult.success(productService.listMerchantProducts(userId, query));
    }

    @GetMapping("/{id}")
    public ApiResult<ProductVO> detail(@AuthenticationPrincipal Long userId, @PathVariable Long id) {
        return ApiResult.success(productService.getDetail(userId, id));
    }

    @DeleteMapping("/{id}")
    public ApiResult<Void> delete(@AuthenticationPrincipal Long userId, @PathVariable Long id) {
        productService.delete(userId, id);
        return ApiResult.success();
    }
}