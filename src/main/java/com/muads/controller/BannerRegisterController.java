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

@Controller
public class BannerRegisterController {

    @Autowired
    private HomeBannerService bannerService;

    // 1. Hiển thị Form đăng ký
    @GetMapping("/banner-register")
    public String showRegisterForm(Model model) {
        model.addAttribute("banner", new HomeBanner());
        return "banner-register"; // Trả về file jsp
    }

    // 2. Xử lý khi khách bấm nút Gửi
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
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        return "redirect:/banner-register";
    }
}