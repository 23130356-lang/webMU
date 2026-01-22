package com.muads.controller;

import com.muads.dto.AdminBannerDto;
import com.muads.entity.User;
import com.muads.service.HomeBannerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
public class AdminBannerController {

    @Autowired
    private HomeBannerService bannerService;

    // Lấy cấu hình đường dẫn upload từ application.properties
    @Value("${muads.upload.path}")
    private String uploadDir;

    // === 1. QUẢN LÝ BANNER (HIỂN THỊ) ===
    @GetMapping("/banners")
    public String showBannerManager(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");

        // Kiểm tra quyền Admin
        if (user == null || !"ADMIN".equalsIgnoreCase(String.valueOf(user.getRole()))) {
            return "redirect:/login";
        }

        // Load danh sách banner
        model.addAttribute("activeList", bannerService.getActiveBanners());
        model.addAttribute("allList", bannerService.getAllBanners());

        return "admin/admin-banners";
    }

    // === 2. XỬ LÝ TẠO BANNER MỚI (FIX LỖI KÍCH HOẠT NGAY) ===
    @PostMapping("/banner/create")
    public String createBannerByAdmin(@ModelAttribute AdminBannerDto dto,
                                      RedirectAttributes redirectAttributes) {
        try {
            String finalUrl = "";

            // LOGIC UPLOAD ẢNH (Giống bên User)
            // Trường hợp 1: Admin upload file
            if ("file".equals(dto.getUploadType()) && dto.getImageFile() != null && !dto.getImageFile().isEmpty()) {
                finalUrl = saveFileAndGetUrl(dto.getImageFile());
            }
            // Trường hợp 2: Admin dán link ảnh
            else if ("url".equals(dto.getUploadType()) && dto.getImageUrl() != null && !dto.getImageUrl().isBlank()) {
                finalUrl = dto.getImageUrl();
            }

            // Kiểm tra nếu không có ảnh nào được chọn
            if (finalUrl == null || finalUrl.isBlank()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng chọn file ảnh hoặc nhập URL!");
                return "redirect:/admin/banners";
            }

            // Gọi Service để lưu banner
            bannerService.createAdminBanner(dto, finalUrl);

            redirectAttributes.addFlashAttribute("successMessage", "Kích hoạt banner thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        return "redirect:/admin/banners";
    }

    // === 3. XÓA BANNER ===
    @GetMapping("/banner/delete/{id}")
    public String deleteBanner(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            bannerService.deleteBanner(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa banner thành công.");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa: " + e.getMessage());
        }
        return "redirect:/admin/banners";
    }

    // === UTILS: HÀM LƯU FILE VÀO THƯ MỤC UPLOADS ===
    private String saveFileAndGetUrl(MultipartFile file) throws IOException {
        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        // Thêm UUID để tránh trùng tên file
        String fileName = UUID.randomUUID().toString() + "_" + originalFilename;

        Path uploadPath = Paths.get(uploadDir);
        // Tạo thư mục nếu chưa tồn tại
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Trả về đường dẫn để lưu vào DB
        return "/uploads/" + fileName;
    }
}