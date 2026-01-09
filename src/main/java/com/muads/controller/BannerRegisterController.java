package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.service.HomeBannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Controller
public class BannerRegisterController {

    @Autowired
    private HomeBannerService bannerService;

    // --- HÀM 1: GET (Hiển thị trang Dashboard) ---
    // Chỉ được phép có 1 hàm @GetMapping("/banner-register") duy nhất trong file này
    @GetMapping("/banner-register")
    public String showRegisterDashboard(Model model) {
        // Giả lập dữ liệu thời gian trống (sau này thay bằng logic DB thật)
        Map<String, String> availability = new HashMap<>();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy | HH:mm");
        String nextMonth = LocalDateTime.now().plusDays(30).format(formatter);
        String availableNow = "CÒN TRỐNG - ĐẶT NGAY";

        availability.put("LEFT_SIDEBAR", nextMonth);
        availability.put("RIGHT_SIDEBAR", availableNow);
        availability.put("HERO", "15/05/2026 | 09:00");
        availability.put("STD", availableNow);

        model.addAttribute("availability", availability);

        return "banner-register";
    }

    // --- HÀM 2: POST (Xử lý khi bấm nút Đăng ký trong Modal) ---
    @PostMapping("/banner-register")
    public String processRegister(@ModelAttribute HomeBanner banner, RedirectAttributes redirectAttributes) {
        try {
            // Mặc định là KHÔNG hiển thị (Chờ Admin duyệt)
            banner.setActive(false);

            // Mặc định thứ tự là 0
            banner.setDisplayOrder(0);

            // Lưu vào DB
            bannerService.saveBanner(banner);

            redirectAttributes.addFlashAttribute("successMessage", "Đăng ký thành công! Admin sẽ liên hệ để duyệt quảng cáo của bạn.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/banner-register";
    }
}