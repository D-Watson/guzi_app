// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.controller;

import com.gu.admin.entity.AdminCategory;
import com.gu.admin.repository.AdminCategoryRepository;
import com.gu.model.dto.ApiResponse;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final AdminCategoryRepository adminCategoryRepository;

    public CategoryController(AdminCategoryRepository adminCategoryRepository) {
        this.adminCategoryRepository = adminCategoryRepository;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> getAll() {
        List<AdminCategory> cats = adminCategoryRepository.findByParentIdIsNullOrderBySortOrderAsc();
        List<Map<String, Object>> result = cats.stream().map(c -> Map.<String, Object>of(
                "id", c.getId(),
                "name", c.getName(),
                "icon", c.getIcon() != null ? c.getIcon() : ""
        )).toList();
        return ApiResponse.success(result);
    }
}