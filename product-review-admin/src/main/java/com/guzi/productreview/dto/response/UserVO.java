package com.guzi.productreview.dto.response;

import com.guzi.productreview.entity.User;
import com.guzi.productreview.enums.UserRole;
import com.guzi.productreview.enums.UserStatus;
import lombok.Data;

import java.util.Date;

@Data
public class UserVO {

    private Long id;
    private String username;
    private String nickname;
    private String phone;
    private String email;
    private UserRole role;
    private UserStatus status;
    private String companyName;
    private String contactPerson;
    private Date createTime;

    public static UserVO from(User user) {
        UserVO vo = new UserVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setPhone(user.getPhone());
        vo.setEmail(user.getEmail());
        vo.setRole(user.getRole());
        vo.setStatus(user.getStatus());
        vo.setCompanyName(user.getCompanyName());
        vo.setContactPerson(user.getContactPerson());
        vo.setCreateTime(user.getCreateTime());
        return vo;
    }
}