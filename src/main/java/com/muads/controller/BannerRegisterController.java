package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.service.HomeBannerService;
import jakarta.servlet.http.HttpSession; // Import Session
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Controller
public class BannerRegisterController {

    @Autowired
    private HomeBannerService bannerService;

    // Cấu hình số lượng Slot tối đa
    private final int LIMIT_HERO = 1;
    private final int LIMIT_STD = 5;
    private final int LIMIT_SIDEBAR = 3;

    @GetMapping("/banner-register")
    public String showRegisterDashboard(Model model, HttpSession session) {

        // --- SỬA ĐỔI: Lấy User từ Session thay vì Principal ---
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser != null) {
            // Gửi thông tin user ra view để hiển thị nút
            model.addAttribute("currentUser", currentUser);
        }
        // -----------------------------------------------------

        // 2. Các logic đếm số lượng (Giữ nguyên)
        long countHero = bannerService.countActiveBanners("HERO");
        long countStd = bannerService.countActiveBanners("STD");
        long countLeft = bannerService.countActiveBanners("LEFT_SIDEBAR");
        long countRight = bannerService.countActiveBanners("RIGHT_SIDEBAR");

        Map<String, String> qtyMap = new HashMap<>();
        qtyMap.put("HERO", countHero + "/" + LIMIT_HERO);
        qtyMap.put("STD", countStd + "/" + LIMIT_STD);
        qtyMap.put("LEFT_SIDEBAR", countLeft + "/" + LIMIT_SIDEBAR);
        qtyMap.put("RIGHT_SIDEBAR", countRight + "/" + LIMIT_SIDEBAR);
        model.addAttribute("qtyInfo", qtyMap);

        Map<String, String> availability = new HashMap<>();
        availability.put("HERO", countHero >= LIMIT_HERO ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        availability.put("STD", countStd >= LIMIT_STD ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        availability.put("LEFT_SIDEBAR", countLeft >= LIMIT_SIDEBAR ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        availability.put("RIGHT_SIDEBAR", countRight >= LIMIT_SIDEBAR ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        model.addAttribute("availability", availability);

        model.addAttribute("isFullHero", countHero >= LIMIT_HERO);
        model.addAttribute("isFullStd", countStd >= LIMIT_STD);
        model.addAttribute("isFullLeft", countLeft >= LIMIT_SIDEBAR);
        model.addAttribute("isFullRight", countRight >= LIMIT_SIDEBAR);

        return "banner-register";
    }

    @PostMapping("/banner-register")
    public String processRegister(
            @ModelAttribute HomeBanner banner,
            HttpSession session, // <--- Dùng HttpSession ở đây
            RedirectAttributes redirectAttributes
    ) {
        // 1. Kiểm tra User trong Session
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            // Nếu session null nghĩa là chưa đăng nhập hoặc hết phiên -> Về Login
            return "redirect:/login";
        }

        try {
            // 2. Gán thông tin User từ Session vào Banner
            banner.setUser(user);

            banner.setActive(false);
            banner.setCreatedAt(LocalDateTime.now());

            // 3. Lưu vào DB
            bannerService.saveBanner(banner);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Đăng ký thành công! Admin sẽ duyệt yêu cầu của bạn sớm nhất.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        return "redirect:/banner-register";
    }
}