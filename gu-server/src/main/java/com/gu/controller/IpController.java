package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.Ip;
import com.gu.repository.IpRepository;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/ips")
public class IpController {
    private final IpRepository ipRepository;

    public IpController(IpRepository ipRepository) {
        this.ipRepository = ipRepository;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> getAll() {
        List<Ip> ips = ipRepository.findAll();
        List<Map<String, Object>> result = ips.stream().map(ip -> {
            List<String> chars = ip.getCharacters() != null && !ip.getCharacters().isEmpty()
                ? Arrays.stream(ip.getCharacters().split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList()
                : List.of();
            return Map.<String, Object>of(
                "id", ip.getId(),
                "name", ip.getName(),
                "iconUrl", ip.getIconUrl() != null ? ip.getIconUrl() : "",
                "characters", chars
            );
        }).toList();
        return ApiResponse.success(result);
    }
}