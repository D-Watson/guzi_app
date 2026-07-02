package com.shizhuang.productreview.controller;

import com.shizhuang.productreview.common.ApiResult;
import com.shizhuang.productreview.dto.request.CategoryRequest;
import com.shizhuang.productreview.dto.response.CategoryVO;
import com.shizhuang.productreview.service.CategoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping("/tree")
    public ApiResult<List<CategoryVO>> getTree() {
        return ApiResult.success(categoryService.getTree());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResult<Void> create(@Valid @RequestBody CategoryRequest request) {
        categoryService.create(request);
        return ApiResult.success();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResult<Void> update(@PathVariable Long id, @Valid @RequestBody CategoryRequest request) {
        categoryService.update(id, request);
        return ApiResult.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResult<Void> delete(@PathVariable Long id) {
        categoryService.delete(id);
        return ApiResult.success();
    }
}