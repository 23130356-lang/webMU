package com.muads.controller;

import com.muads.dto.UserLoginDTO;
import com.muads.dto.UserRegisterDTO;
import com.muads.entity.User;
import com.muads.service.UserService;
import jakarta.servlet.http.HttpSession;
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

    // --- Phần Đăng Ký ---
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

    // --- PHẦN LOGIN ---

    // 1. Hiển thị form login
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("loginDTO", new UserLoginDTO());
        return "login";
    }


    @PostMapping("/login")
    public String processLogin(@ModelAttribute("loginDTO") UserLoginDTO loginDTO,
                               HttpSession session,
                               Model model) {
        try {
            System.out.println("--- BẮT ĐẦU XỬ LÝ LOGIN ---");
            System.out.println("Username nhập vào: " + loginDTO.getUsername());

            // 1. Gọi Service kiểm tra
            User user = userService.login(loginDTO);

            // 2. Nếu không lỗi -> Login thành công -> Lưu vào Session
            session.setAttribute("currentUser", user);

            // In ra thông tin User lấy được từ DB để kiểm tra
            System.out.println("Login thành công! User tìm thấy: " + user.getUsername());
            System.out.println("Role trong Database là: " + user.getRole());

            // 3. Phân quyền chuyển hướng
            // So sánh Enum trực tiếp (Chuẩn nhất)
            if (user.getRole() == User.Role.ADMIN) {
                System.out.println(">> ĐIỀU HƯỚNG: Đang chuyển sang trang ADMIN (/admin/pending)");
                return "redirect:/admin/pending";
            } else {
                System.out.println(">> ĐIỀU HƯỚNG: Đang chuyển sang trang HOME (/)");
                return "redirect:/server/register";
            }

        } catch (RuntimeException e) {
            // Trường hợp đăng nhập sai
            System.out.println(">> LỖI LOGIN: " + e.getMessage());
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