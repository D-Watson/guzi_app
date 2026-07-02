package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.Category;
import com.gu.repository.CategoryRepository;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {
    private final CategoryRepository categoryRepository;

    public CategoryController(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> getAll() {
        List<Category> cats = categoryRepository.findAll();
        List<Map<String, Object>> result = cats.stream().map(c -> Map.<String, Object>of(
            "id", c.getId(),
            "name", c.getName(),
            "icon", c.getIcon() != null ? c.getIcon() : ""
        )).toList();
        return ApiResponse.success(result);
    }
}