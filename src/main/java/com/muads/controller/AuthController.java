package com.muads.controller;

import com.muads.dto.UserLoginDTO;
import com.muads.dto.UserRegisterDTO;
import com.muads.entity.User;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.ResetTypeRepository;
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
    private MuVersionRepository versionRepo;

    @Autowired
    private ResetTypeRepository resetRepo;
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
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        return "login";
    }


    @PostMapping("/login")
    public String processLogin(@ModelAttribute("loginDTO") UserLoginDTO loginDTO,
                               HttpSession session,
                               Model model) {
        try {


            // 1. Gọi Service kiểm tra
            User user = userService.login(loginDTO);

            // 2. Nếu không lỗi -> Login thành công -> Lưu vào Session
            session.setAttribute("currentUser", user);

            // So sánh Enum trực tiếp (Chuẩn nhất)
            if (user.getRole() == User.Role.ADMIN) {
                return "redirect:/admin/pending";
            } else {
                return "redirect:/banner-register";
            }

        } catch (RuntimeException e) {
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