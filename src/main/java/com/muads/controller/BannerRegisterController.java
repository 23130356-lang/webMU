package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.repository.UserRepository;
import com.muads.service.HomeBannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal; // Quan trọng: Để lấy thông tin đăng nhập
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Controller
public class BannerRegisterController {

    @Autowired
    private HomeBannerService bannerService;

    @Autowired
    private UserRepository userRepository; // Inject thêm Repository User

    // --- HÀM 1: GET (Hiển thị trang Dashboard) ---
    @GetMapping("/banner-register") // Có thể đổi thành /thue-quang-cao cho thân thiện SEO
    public String showRegisterDashboard(Model model) {
        // Giả lập dữ liệu thời gian trống
        Map<String, String> availability = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Logic giả lập: Hero full đến tháng sau, còn lại trống
        String nextMonth = LocalDateTime.now().plusDays(30).format(formatter);
        String availableNow = "CÒN TRỐNG - ĐẶT NGAY";

        availability.put("LEFT_SIDEBAR", availableNow);
        availability.put("RIGHT_SIDEBAR", availableNow);
        availability.put("HERO", nextMonth);
        availability.put("STD", availableNow);

        model.addAttribute("availability", availability);

        return "banner-register"; // Tên file JSP của bạn
    }

    // --- HÀM 2: POST (Xử lý Đăng ký Banner) ---
    @PostMapping("/banner-register")
    public String processRegister(
            @ModelAttribute HomeBanner banner,
            Principal principal, // Thêm tham số này để lấy User hiện tại
            RedirectAttributes redirectAttributes
    ) {
        // 1. Kiểm tra đăng nhập (Bảo mật lớp Controller)
        if (principal == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            return "redirect:/login";
        }

        try {
            // 2. Lấy thông tin User từ Database
            String username = principal.getName(); // Lấy username từ session
            User currentUser = userRepository.findByUsername(username);

            if (currentUser == null) {
                throw new Exception("Không tìm thấy thông tin người dùng.");
            }

            // 3. Thiết lập các thông số mặc định cho Banner
            banner.setActive(false);          // Chờ duyệt
            banner.setDisplayOrder(99);       // Xếp cuối cùng
            banner.setCreatedAt(LocalDateTime.now()); // Thời gian tạo

            // --- QUAN TRỌNG: Gán User vào Banner ---
            banner.setUser(currentUser);
            // ---------------------------------------

            // 4. Lưu vào DB
            bannerService.saveBanner(banner);

            redirectAttributes.addFlashAttribute("successMessage", "Đăng ký thành công! Vui lòng chờ Admin xét duyệt.");

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug nếu cần
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/banner-register";
    }
}