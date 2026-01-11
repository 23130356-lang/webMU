package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.repository.UserRepository;
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
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
public class BannerRegisterController {

    @Autowired
    private HomeBannerService bannerService;

    @Autowired
    private UserRepository userRepository;

    @Value("${muads.upload.path}")
    private String uploadDir;

    // Định nghĩa giới hạn Slot
    private final int LIMIT_HERO = 1;
    private final int LIMIT_STD = 5;
    private final int LIMIT_SIDEBAR = 3;

    // Bảng giá
    private Map<String, Integer> getPriceList() {
        Map<String, Integer> priceList = new HashMap<>();
        priceList.put("HERO", 500000);
        priceList.put("STD", 100000);
        priceList.put("LEFT_SIDEBAR", 50000);
        priceList.put("RIGHT_SIDEBAR", 50000);
        return priceList;
    }

    @GetMapping("/banner-register")
    public String showRegisterDashboard(Model model, HttpSession session) {
        // 1. Cập nhật thông tin User (Số dư mới nhất)
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            User freshUser = userRepository.findById(currentUser.getId()).orElse(currentUser);
            session.setAttribute("currentUser", freshUser);
            model.addAttribute("currentUser", freshUser);
        }

        // 2. Lấy số lượng Banner đang chạy
        long countHero = bannerService.countActiveBanners("HERO");
        long countStd = bannerService.countActiveBanners("STD");
        long countLeft = bannerService.countActiveBanners("LEFT_SIDEBAR");
        long countRight = bannerService.countActiveBanners("RIGHT_SIDEBAR");

        // 3. Map hiển thị số lượng (VD: 1/5)
        Map<String, String> qtyMap = new HashMap<>();
        qtyMap.put("HERO", countHero + "/" + LIMIT_HERO);
        qtyMap.put("STD", countStd + "/" + LIMIT_STD);
        qtyMap.put("LEFT_SIDEBAR", countLeft + "/" + LIMIT_SIDEBAR);
        qtyMap.put("RIGHT_SIDEBAR", countRight + "/" + LIMIT_SIDEBAR);
        model.addAttribute("qtyInfo", qtyMap);

        // 4. Map kiểm tra Full Slot (để đổi màu/khóa nút)
        boolean isFullHero = countHero >= LIMIT_HERO;
        boolean isFullStd = countStd >= LIMIT_STD;
        boolean isFullLeft = countLeft >= LIMIT_SIDEBAR;
        boolean isFullRight = countRight >= LIMIT_SIDEBAR;

        model.addAttribute("isFullHero", isFullHero);
        model.addAttribute("isFullStd", isFullStd);
        model.addAttribute("isFullLeft", isFullLeft);
        model.addAttribute("isFullRight", isFullRight);

        // 5. [LOGIC MỚI] Tính thời gian Slot tiếp theo sẽ trống
        Map<String, String> nextAvailableMap = new HashMap<>();

        if (isFullHero) nextAvailableMap.put("HERO", bannerService.getNextAvailableDate("HERO", LIMIT_HERO));
        if (isFullStd) nextAvailableMap.put("STD", bannerService.getNextAvailableDate("STD", LIMIT_STD));
        if (isFullLeft) nextAvailableMap.put("LEFT_SIDEBAR", bannerService.getNextAvailableDate("LEFT_SIDEBAR", LIMIT_SIDEBAR));
        if (isFullRight) nextAvailableMap.put("RIGHT_SIDEBAR", bannerService.getNextAvailableDate("RIGHT_SIDEBAR", LIMIT_SIDEBAR));

        model.addAttribute("nextAvailableMap", nextAvailableMap);

        // 6. Gửi bảng giá và text trạng thái
        model.addAttribute("prices", getPriceList());

        // Map text trạng thái (Còn chỗ / Hết chỗ)
        Map<String, String> availability = new HashMap<>();
        availability.put("HERO", isFullHero ? "Hết Slot" : "Còn Chỗ");
        availability.put("STD", isFullStd ? "Hết Slot" : "Còn Chỗ");
        availability.put("LEFT_SIDEBAR", isFullLeft ? "Hết Slot" : "Còn Chỗ");
        availability.put("RIGHT_SIDEBAR", isFullRight ? "Hết Slot" : "Còn Chỗ");
        model.addAttribute("availability", availability);

        return "banner-register";
    }

    @PostMapping("/banner-register")
    public String processRegister(
            @ModelAttribute HomeBanner banner,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) return "redirect:/login";

        try {
            // Check lại lần cuối xem slot còn không (tránh trường hợp 2 người mua cùng lúc)
            // Lấy limit dựa trên positionCode gửi lên
            int currentLimit = 0;
            String pos = banner.getPositionCode();
            if ("HERO".equals(pos)) currentLimit = LIMIT_HERO;
            else if ("STD".equals(pos)) currentLimit = LIMIT_STD;
            else if ("LEFT_SIDEBAR".equals(pos)) currentLimit = LIMIT_SIDEBAR;
            else if ("RIGHT_SIDEBAR".equals(pos)) currentLimit = LIMIT_SIDEBAR;

            if (bannerService.countActiveBanners(pos) >= currentLimit) {
                redirectAttributes.addFlashAttribute("errorMessage", "Rất tiếc, vị trí này vừa bị người khác mua mất rồi!");
                return "redirect:/banner-register";
            }

            // 1. Xử lý Ảnh
            String finalImageUrl = null;
            if (imageFile != null && !imageFile.isEmpty()) {
                finalImageUrl = saveFileAndGetUrl(imageFile);
            } else if (imageUrl != null && !imageUrl.isBlank()) {
                finalImageUrl = imageUrl;
            }

            if (finalImageUrl == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng chọn ảnh!");
                return "redirect:/banner-register";
            }
            banner.setImageUrl(finalImageUrl);

            // 2. Mua và Kích hoạt
            bannerService.purchaseAndActivateBanner(banner, sessionUser.getId());

            // 3. Update Session
            User updatedUser = userRepository.findById(sessionUser.getId()).orElse(sessionUser);
            session.setAttribute("currentUser", updatedUser);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Thanh toán thành công! Banner đã hiển thị (7 ngày).");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        return "redirect:/banner-register";
    }

    private String saveFileAndGetUrl(MultipartFile file) throws IOException {
        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        // Thêm UUID để tránh trùng tên file
        String fileName = UUID.randomUUID().toString() + "_" + originalFilename;

        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return "/uploads/" + fileName;
    }
}