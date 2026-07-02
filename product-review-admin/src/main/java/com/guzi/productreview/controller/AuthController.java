package com.guzi.productreview.controller;

import com.guzi.productreview.common.ApiResult;
import com.guzi.productreview.dto.request.LoginRequest;
import com.guzi.productreview.dto.request.RegisterRequest;
import com.guzi.productreview.dto.response.LoginVO;
import com.guzi.productreview.service.AuthService;
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