package com.guzi.productreview.controller;

import com.guzi.productreview.common.ApiResult;
import com.guzi.productreview.dto.query.UserPageQuery;
import com.guzi.productreview.dto.response.UserVO;
import com.guzi.productreview.common.PageResult;
import com.guzi.productreview.service.UserService;
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