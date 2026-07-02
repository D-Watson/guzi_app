package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.Post;
import com.gu.repository.PostRepository;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/posts")
public class PostController {
    private final PostRepository postRepository;

    public PostController(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    @GetMapping
    public ApiResponse<Map<String, Object>> getAll() {
        List<Post> posts = postRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
        List<Map<String, Object>> content = posts.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId());
            m.put("author", Map.of(
                "id", p.getAuthor().getId(), "nickname", p.getAuthor().getNickname(),
                "avatarUrl", p.getAuthor().getAvatarUrl() != null ? p.getAuthor().getAvatarUrl() : "",
                "creditScore", p.getAuthor().getCreditScore(),
                "completedOrders", p.getAuthor().getCompletedOrders(),
                "goodRate", p.getAuthor().getGoodRate(),
                "isVerified", p.getAuthor().isVerified()
            ));
            m.put("content", p.getContent());
            m.put("imageUrls", splitToList(p.getImageUrls()));
            m.put("type", p.getType());
            m.put("createdAt", p.getCreatedAt());
            m.put("likeCount", p.getLikeCount());
            m.put("commentCount", p.getCommentCount());
            return m;
        }).toList();
        return ApiResponse.success(Map.of(
            "content", content, "totalElements", content.size(),
            "totalPages", 1, "number", 0, "size", 20
        ));
    }

    private List<String> splitToList(String str) {
        if (str == null || str.trim().isEmpty()) return List.of();
        return Arrays.stream(str.split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }
}