package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.Banner;
import com.gu.repository.BannerRepository;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/banners")
public class BannerController {
    private final BannerRepository bannerRepository;

    public BannerController(BannerRepository bannerRepository) {
        this.bannerRepository = bannerRepository;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> getAll() {
        List<Banner> banners = bannerRepository.findAll(Sort.by(Sort.Direction.ASC, "sortOrder"));
        List<Map<String, Object>> result = banners.stream().map(b -> Map.<String, Object>of(
            "id", b.getId(),
            "imageUrl", b.getImageUrl() != null ? b.getImageUrl() : "",
            "title", b.getTitle() != null ? b.getTitle() : "",
            "subtitle", b.getSubtitle() != null ? b.getSubtitle() : ""
        )).toList();
        return ApiResponse.success(result);
    }
}