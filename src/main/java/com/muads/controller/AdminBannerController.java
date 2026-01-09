package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.service.HomeBannerService;
import com.muads.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
@RequestMapping("/admin/banners")
public class AdminBannerController {

    @Autowired
    private HomeBannerService bannerService;
    @Autowired
    private UserService userService;
    // 1. Danh sách Banner
    @GetMapping("")
    public String listBanners(Model model) {
        model.addAttribute("banners", bannerService.getAllBanners());
        return "admin/banner-list"; // File JSP danh sách
    }

    // 2. Form thêm mới
    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("banner", new HomeBanner());
        model.addAttribute("pageTitle", "Thêm Banner Mới");
        return "admin/banner-form"; // File JSP form
    }

    // 3. Form chỉnh sửa
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        HomeBanner banner = bannerService.getBannerById(id);
        if (banner == null) {
            return "redirect:/admin/banners";
        }
        model.addAttribute("banner", banner);
        model.addAttribute("pageTitle", "Cập Nhật Banner (ID: " + id + ")");
        return "admin/banner-form";
    }

    // 4. Lưu dữ liệu (Create & Update)
    @PostMapping("/save")
    public String saveBanner(@ModelAttribute("banner") HomeBanner banner, Principal principal) {

        // 1. Lấy thông tin User đang đăng nhập hiện tại
        String currentUsername = principal.getName();
        User currentUser = userService.findByUsername(currentUsername);
        // Lưu ý: hàm findByUsername tùy thuộc vào bên UserService của bạn viết thế nào

        if (banner.getId() != null) {
            // === TRƯỜNG HỢP SỬA (UPDATE) ===
            HomeBanner oldBanner = bannerService.getBannerById(banner.getId());
            if (oldBanner != null) {
                // Giữ lại ngày tạo cũ
                banner.setCreatedAt(oldBanner.getCreatedAt());
                // Giữ lại người đăng cũ (không đổi người đăng khi sửa)
                banner.setUser(oldBanner.getUser());
            }
        } else {
            // === TRƯỜNG HỢP THÊM MỚI (CREATE) ===
            banner.setCreatedAt(java.time.LocalDateTime.now());
            // Gán người đang đăng nhập là người tạo
            banner.setUser(currentUser);
        }

        bannerService.saveBanner(banner);
        return "redirect:/admin/banners";
    }

    // 5. Xóa banner
    @GetMapping("/delete/{id}")
    public String deleteBanner(@PathVariable Long id) {
        bannerService.deleteBanner(id);
        return "redirect:/admin/banners";
    }

    // 6. Duyệt nhanh (Bật/Tắt hiển thị)
    @GetMapping("/toggle/{id}")
    public String toggleStatus(@PathVariable Long id) {
        bannerService.toggleStatus(id);
        return "redirect:/admin/banners";
    }
}