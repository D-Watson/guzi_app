package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.User;
import com.gu.service.UserService;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    public ApiResponse<Map<String, Object>> getCurrentUser() {
        User u = userService.getCurrentUser();
        if (u == null) return ApiResponse.error(404, "User not found");
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", u.getId());
        m.put("nickname", u.getNickname());
        m.put("avatarUrl", u.getAvatarUrl() != null ? u.getAvatarUrl() : "");
        m.put("creditScore", u.getCreditScore());
        m.put("completedOrders", u.getCompletedOrders());
        m.put("goodRate", u.getGoodRate());
        m.put("isVerified", u.isVerified());
        return ApiResponse.success(m);
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        List<Map<String, Object>> result = users.stream().map(u -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", u.getId());
            m.put("nickname", u.getNickname());
            m.put("avatarUrl", u.getAvatarUrl() != null ? u.getAvatarUrl() : "");
            m.put("creditScore", u.getCreditScore());
            m.put("completedOrders", u.getCompletedOrders());
            m.put("goodRate", u.getGoodRate());
            m.put("isVerified", u.isVerified());
            return m;
        }).toList();
        return ApiResponse.success(result);
    }
}