package com.shizhuang.productreview.controller;

import com.shizhuang.productreview.common.ApiResult;
import com.shizhuang.productreview.dto.query.UserPageQuery;
import com.shizhuang.productreview.dto.response.UserVO;
import com.shizhuang.productreview.common.PageResult;
import com.shizhuang.productreview.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final UserService userService;

    @GetMapping
    public ApiResult<PageResult<UserVO>> list(UserPageQuery query) {
        return ApiResult.success(userService.listMerchants(query));
    }

    @PutMapping("/{id}/status")
    public ApiResult<Void> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        userService.updateStatus(id, body.get("status"));
        return ApiResult.success();
    }
}