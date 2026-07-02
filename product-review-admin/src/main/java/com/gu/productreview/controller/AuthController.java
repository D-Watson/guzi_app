package com.shizhuang.productreview.controller;

import com.shizhuang.productreview.common.ApiResult;
import com.shizhuang.productreview.dto.request.LoginRequest;
import com.shizhuang.productreview.dto.request.RegisterRequest;
import com.shizhuang.productreview.dto.response.LoginVO;
import com.shizhuang.productreview.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ApiResult<LoginVO> register(@Valid @RequestBody RegisterRequest request) {
        return ApiResult.success(authService.register(request));
    }

    @PostMapping("/login")
    public ApiResult<LoginVO> login(@Valid @RequestBody LoginRequest request) {
        return ApiResult.success(authService.login(request));
    }

    @PostMapping("/logout")
    public ApiResult<Void> logout(@AuthenticationPrincipal Long userId) {
        authService.logout(userId);
        return ApiResult.success();
    }
}