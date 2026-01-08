package com.muads.dto;

import lombok.Data;

@Data
public class UserRegisterDTO {
    private String username;
    private String password;
    private String confirmPassword; // Trường này chỉ dùng để check, không lưu db
    private String email;
    private String phone;
    private String coin;
}