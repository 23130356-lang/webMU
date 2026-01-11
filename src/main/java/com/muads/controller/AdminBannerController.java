package com.muads.controller;

import com.muads.entity.User;
import com.muads.service.HomeBannerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
public class AdminBannerController {

    @Autowired
    private HomeBannerService bannerService;

    // === 1. QUẢN LÝ BANNER (CHỈ CẦN XEM VÀ XÓA) ===
    @GetMapping("/banners")
    public String showBannerManager(Model model, HttpSession session) {
        // 1. Kiểm tra quyền Admin
        User user = (User) session.getAttribute("currentUser");

        // Lưu ý: Sửa logic check role tùy theo Enum hay String trong code của bạn
        // Ví dụ: if (user == null || user.getRole() != User.Role.ADMIN)
        if (user == null || !"ADMIN".equalsIgnoreCase(String.valueOf(user.getRole()))) {
            return "redirect:/login";
        }

        // 2. Lấy danh sách để hiển thị
        // - Danh sách đang chạy (Active) để kiểm tra nội dung
        model.addAttribute("activeList", bannerService.getActiveBanners());

        // - Danh sách toàn bộ (nếu muốn xem cả lịch sử cũ)
        model.addAttribute("allList", bannerService.getAllBanners());

        return "admin/admin-banners";
    }

    // === 2. XÓA BANNER (NẾU VI PHẠM) ===
    @GetMapping("/banner/delete/{id}")
    public String deleteBanner(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            // Vì user đã trả tiền, nên nếu xóa admin có thể cần cân nhắc việc hoàn tiền thủ công
            // hoặc quy định rõ trong điều khoản là "Vi phạm sẽ xóa không hoàn tiền".

            bannerService.deleteBanner(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã gỡ bỏ banner vi phạm thành công.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa: " + e.getMessage());
        }
        return "redirect:/admin/banners";
    }
}