package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.service.HomeBannerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Controller
@RequestMapping("/admin")
public class AdminBannerController {

    @Autowired
    private HomeBannerService bannerService;

    // 1. Hiển thị danh sách Banner
    @GetMapping("/banners")
    public String showBannerManager(Model model, HttpSession session) {
        // Check quyền Admin
        User user = (User) session.getAttribute("currentUser");
        if (user == null || user.getRole() != User.Role.ADMIN) {
            return "redirect:/login"; // Đá về login nếu không phải Admin
        }

        // Lấy danh sách
        model.addAttribute("pendingList", bannerService.getPendingBanners());
        model.addAttribute("activeList", bannerService.getActiveBanners());

        return "admin/admin-banners";
    }

    // 2. Xử lý Duyệt Banner
    @PostMapping("/banner/approve")
    public String approveBanner(
            @RequestParam("id") Long id,
            @RequestParam("startDate") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            RedirectAttributes redirectAttributes
    ) {
        try {
            HomeBanner banner = bannerService.findById(id);
            if (banner != null) {
                // Chuyển LocalDate (chọn từ lịch) sang LocalDateTime
                banner.setStartDate(LocalDateTime.of(startDate, LocalTime.MIN));
                banner.setEndDate(LocalDateTime.of(endDate, LocalTime.MAX));
                banner.setActive(true); // Kích hoạt

                bannerService.saveBanner(banner);
                redirectAttributes.addFlashAttribute("successMessage", "Đã duyệt banner thành công!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/banners";
    }

    // 3. Xóa Banner
    @GetMapping("/banner/delete/{id}")
    public String deleteBanner(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            bannerService.deleteBanner(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa banner.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa: " + e.getMessage());
        }
        return "redirect:/admin/banners";
    }
}