package com.muads.controller;

import com.muads.dto.UserProfileDTO;
import com.muads.entity.User;
import com.muads.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
@Controller
public class UserProfileController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        // 1. Lấy user từ session (đã lưu ở AuthController lúc login)
        User sessionUser = (User) session.getAttribute("currentUser");

        // 2. Kiểm tra nếu chưa đăng nhập -> Đá về trang login
        if (sessionUser == null) {
            return "redirect:/login";
        }

        // 3. Gọi Service lấy dữ liệu mới nhất từ DB (để cập nhật số Coin đúng nhất)
        try {
            UserProfileDTO userProfile = userService.getUserProfile(sessionUser.getId());
            model.addAttribute("profile", userProfile);
            return "profile"; // Trả về file profile.jsp
        } catch (RuntimeException e) {
            // Trường hợp hãn hữu: User trong session có nhưng trong DB bị xóa
            session.invalidate();
            return "redirect:/login";
        }
    }
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute UserProfileDTO userProfileDTO,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        // 1. Lấy user từ session để biết ai đang sửa
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            return "redirect:/login";
        }

        try {
            // 2. Gọi Service xử lý update
            userService.updateUserProfile(sessionUser.getId(), userProfileDTO);

            // 3. Thông báo thành công
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công!");

            // Cập nhật lại session user (để hiển thị đúng tên trên header ngay lập tức)
            sessionUser.setFullName(userProfileDTO.getFullName());
            sessionUser.setEmail(userProfileDTO.getEmail());
            session.setAttribute("currentUser", sessionUser);

        } catch (RuntimeException e) {
            // 4. Thông báo lỗi (ví dụ trùng email)
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/profile";
    }
}