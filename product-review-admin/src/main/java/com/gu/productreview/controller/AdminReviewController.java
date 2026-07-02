package com.shizhuang.productreview.controller;

import com.shizhuang.productreview.common.ApiResult;
import com.shizhuang.productreview.dto.query.ProductPageQuery;
import com.shizhuang.productreview.dto.request.ReviewRequest;
import com.shizhuang.productreview.dto.response.ProductVO;
import com.shizhuang.productreview.common.PageResult;
import com.shizhuang.productreview.service.ReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminReviewController {

    private final ReviewService reviewService;

    @GetMapping("/reviews/pending")
    public ApiResult<PageResult<ProductVO>> pendingList(ProductPageQuery query) {
        return ApiResult.success(reviewService.getPendingList(query));
    }

    @GetMapping("/products")
    public ApiResult<PageResult<ProductVO>> allProducts(ProductPageQuery query) {
        return ApiResult.success(reviewService.listAll(query));
    }

    @GetMapping("/products/{id}")
    public ApiResult<ProductVO> productDetail(@PathVariable Long id) {
        return ApiResult.success(reviewService.getDetail(id));
    }

    @PostMapping("/reviews/{id}/approve")
    public ApiResult<Void> approve(@AuthenticationPrincipal Long userId, @PathVariable Long id) {
        reviewService.approve(id, userId);
        return ApiResult.success();
    }

    @PostMapping("/reviews/{id}/reject")
    public ApiResult<Void> reject(@AuthenticationPrincipal Long userId,
                                  @PathVariable Long id,
                                  @Valid @RequestBody ReviewRequest request) {
        reviewService.reject(id, userId, request.getReason());
        return ApiResult.success();
    }
}