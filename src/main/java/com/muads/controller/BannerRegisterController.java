package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.service.HomeBannerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
public class BannerRegisterController {

    @Autowired
    private HomeBannerService bannerService;

    // Lấy đường dẫn "uploads" từ file application.properties
    @Value("${muads.upload.path}")
    private String uploadDir;

    // Cấu hình giới hạn số lượng Banner cho từng vị trí
    private final int LIMIT_HERO = 1;
    private final int LIMIT_STD = 5;
    private final int LIMIT_SIDEBAR = 3;

    // === 1. HIỂN THỊ TRANG ĐĂNG KÝ ===
    @GetMapping("/banner-register")
    public String showRegisterDashboard(Model model, HttpSession session) {
        // Kiểm tra User trong Session
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            model.addAttribute("currentUser", currentUser);
        }

        // Đếm số lượng banner đang active theo từng vị trí
        long countHero = bannerService.countActiveBanners("HERO");
        long countStd = bannerService.countActiveBanners("STD");
        long countLeft = bannerService.countActiveBanners("LEFT_SIDEBAR");
        long countRight = bannerService.countActiveBanners("RIGHT_SIDEBAR");

        // Gửi thông tin số lượng (Ví dụ: 1/5)
        Map<String, String> qtyMap = new HashMap<>();
        qtyMap.put("HERO", countHero + "/" + LIMIT_HERO);
        qtyMap.put("STD", countStd + "/" + LIMIT_STD);
        qtyMap.put("LEFT_SIDEBAR", countLeft + "/" + LIMIT_SIDEBAR);
        qtyMap.put("RIGHT_SIDEBAR", countRight + "/" + LIMIT_SIDEBAR);
        model.addAttribute("qtyInfo", qtyMap);

        // Gửi thông tin trạng thái (Hết slot hay còn trống)
        Map<String, String> availability = new HashMap<>();
        availability.put("HERO", countHero >= LIMIT_HERO ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        availability.put("STD", countStd >= LIMIT_STD ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        availability.put("LEFT_SIDEBAR", countLeft >= LIMIT_SIDEBAR ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        availability.put("RIGHT_SIDEBAR", countRight >= LIMIT_SIDEBAR ? "HẾT SLOT (Full)" : "CÒN TRỐNG");
        model.addAttribute("availability", availability);

        // Các biến boolean để disable nút trên giao diện nếu cần
        model.addAttribute("isFullHero", countHero >= LIMIT_HERO);
        model.addAttribute("isFullStd", countStd >= LIMIT_STD);
        model.addAttribute("isFullLeft", countLeft >= LIMIT_SIDEBAR);
        model.addAttribute("isFullRight", countRight >= LIMIT_SIDEBAR);

        return "banner-register";
    }

    // === 2. XỬ LÝ FORM ĐĂNG KÝ (UPLOAD ẢNH) ===
    @PostMapping("/banner-register")
    public String processRegister(
            @ModelAttribute HomeBanner banner,                                            // Nhận các field: targetUrl, positionCode
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile, // Nhận file từ máy tính
            @RequestParam(value = "imageUrl", required = false) String imageUrl,          // Nhận link ảnh online
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // 1. Kiểm tra đăng nhập
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            String finalImageUrl = null;

            // 2. LOGIC XỬ LÝ ẢNH
            // Ưu tiên 1: Nếu người dùng có upload file
            if (imageFile != null && !imageFile.isEmpty()) {
                finalImageUrl = saveFileAndGetUrl(imageFile);
            }
            // Ưu tiên 2: Nếu không upload file, kiểm tra xem có nhập Link ảnh không
            else if (imageUrl != null && !imageUrl.isBlank()) {
                finalImageUrl = imageUrl;
            }

            // Nếu cả 2 đều trống -> Báo lỗi
            if (finalImageUrl == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng chọn file ảnh hoặc nhập đường dẫn ảnh!");
                return "redirect:/banner-register";
            }

            // 3. Thiết lập thông tin cho Banner
            banner.setImageUrl(finalImageUrl); // Lưu đường dẫn (VD: /uploads/abc.gif hoặc https://imgur...)
            banner.setUser(user);
            banner.setActive(false);           // Mặc định là chưa duyệt
            banner.setCreatedAt(LocalDateTime.now());

            // 4. Lưu vào Database
            bannerService.saveBanner(banner);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Đăng ký thành công! Admin sẽ duyệt yêu cầu của bạn sớm nhất.");

        } catch (IOException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu file: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        return "redirect:/banner-register";
    }

    // === HÀM HỖ TRỢ: LƯU FILE VÀO THƯ MỤC UPLOADS ===
    private String saveFileAndGetUrl(MultipartFile file) throws IOException {
        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        String fileName = UUID.randomUUID().toString() + "_" + originalFilename;

        Path uploadPath = Paths.get(uploadDir);

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);

        // --- THÊM DÒNG NÀY ĐỂ DEBUG ---
        System.out.println("==========================================");
        System.out.println("FILE ĐÃ LƯU TẠI: " + filePath.toAbsolutePath().toString());
        System.out.println("==========================================");
        // -----------------------------

        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return "/uploads/" + fileName;
    }
}