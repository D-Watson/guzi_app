package com.guzi.productreview.dto.response;

import com.guzi.productreview.entity.User;
import com.guzi.productreview.enums.UserRole;
import lombok.Data;

@Data
public class LoginVO {

    private String token;
    private String tokenType = "Bearer";
    private long expiresIn;
    private UserInfo user;

    @Data
    public static class UserInfo {
        private Long id;
        private String username;
        private String nickname;
        private UserRole role;
    }

    public static LoginVO of(String token, long expiresIn, User user) {
        LoginVO vo = new LoginVO();
        vo.token = token;
        vo.tokenType = "Bearer";
        vo.expiresIn = expiresIn;

        UserInfo info = new UserInfo();
        info.setId(user.getId());
        info.setUsername(user.getUsername());
        info.setNickname(user.getNickname());
        info.setRole(user.getRole());
        vo.user = info;
        return vo;
    }
}