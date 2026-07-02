package com.shizhuang.productreview.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterRequest {

    @NotBlank(message = "用户名不能为空")
    @Size(min = 4, max = 50, message = "用户名长度4-50个字符")
    private String username;

    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 100, message = "密码长度6-100个字符")
    private String password;

    private String nickname;

    private String phone;

    private String email;

    @NotBlank(message = "公司名称不能为空")
    private String companyName;

    private String contactPerson;
}