package com.muads.controller;

import com.muads.dto.UserLoginDTO;
import com.muads.dto.UserRegisterDTO; // Import cái cũ
import com.muads.entity.User;
import com.muads.service.UserService;
import jakarta.servlet.http.HttpSession; // Import Session
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    // --- Phần Đăng Ký (Code cũ) ---
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("userDTO", new UserRegisterDTO());
        return "register";
    }

    @PostMapping("/register")
    public String processRegister(@ModelAttribute("userDTO") UserRegisterDTO userDTO, Model model) {
        try {
            userService.registerUser(userDTO);
            return "redirect:/login?registerSuccess=true";
        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "register";
        }
    }

    // --- PHẦN LOGIN (Code Mới) ---

    // 1. Hiển thị form login
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("loginDTO", new UserLoginDTO());
        return "login";
    }

    // 2. Xử lý đăng nhập
    @PostMapping("/login")
    public String processLogin(@ModelAttribute("loginDTO") UserLoginDTO loginDTO,
                               HttpSession session,
                               Model model) {
        try {
            // Gọi service kiểm tra
            User user = userService.login(loginDTO);

            // QUAN TRỌNG: Lưu user vào Session
            session.setAttribute("currentUser", user);

            // Đăng nhập xong thì về trang chủ hoặc trang quản lý server
            return "redirect:/server/register";

        } catch (RuntimeException e) {
            // Đăng nhập lỗi -> ở lại trang login và báo lỗi
            model.addAttribute("errorMessage", e.getMessage());
            return "login";
        }
    }

    // 3. Đăng xuất (Logout)
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // Xóa sạch session
        return "redirect:/login";
    }
}