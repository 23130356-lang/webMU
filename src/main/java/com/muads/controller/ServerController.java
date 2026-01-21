package com.muads.controller;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.PointTypeRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.repository.ServerRepository;
import com.muads.service.ServerService;
import com.muads.util.SlugUtils;
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
@RequestMapping("/server")
public class ServerController {

    @Autowired private ServerService serverService;
    @Autowired private ServerRepository serverRepository;
    @Autowired private MuVersionRepository versionRepo;
    @Autowired private ResetTypeRepository resetRepo;
    @Autowired private PointTypeRepository pointRepo;

    @Value("${muads.upload.path}")
    private String uploadDir;

    // ============================================================
    // DỮ LIỆU DÙNG CHUNG (MENU)
    // Cách tối ưu: Dùng @ModelAttribute để tự động có trong mọi view của Controller này
    // ============================================================
    @ModelAttribute
    public void addGlobalAttributes(Model model) {
        // Hàm này sẽ chạy trước mọi RequestMapping trong Controller này
        // Đảm bảo menu luôn có dữ liệu mà không cần copy paste nhiều lần
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
    }

    // ============================================================
    // 1. URL CHÍNH (CHUẨN SEO)
    // ============================================================
    @GetMapping("/{slug}-{id}")
    public String showServerDetailSeo(
            @PathVariable("slug") String slug,
            @PathVariable("id") Long id,
            Model model) {

        Server server = serverService.getServerById(id);
        if (server == null) {
            return "redirect:/";
        }

        String correctSlug = SlugUtils.toSlug(server.getServerName());
        if (!slug.equals(correctSlug)) {
            return "redirect:/server/" + correctSlug + "-" + id;
        }

        model.addAttribute("server", server);

        // [ĐÃ CÓ SẴN DO @ModelAttribute Ở TRÊN]
        // model.addAttribute("menuVersions", versionRepo.findAll());
        // model.addAttribute("menuTypes", resetRepo.findAll());

        return "server-detail";
    }

    // ============================================================
    // 2. URL CŨ (REDIRECT)
    // ============================================================
    @GetMapping("/detail/{id}")
    public String showServerDetailLegacy(@PathVariable("id") Long id) {
        Server server = serverService.getServerById(id);
        if (server == null) return "redirect:/";
        String slug = SlugUtils.toSlug(server.getServerName());
        return "redirect:/server/" + slug + "-" + id;
    }

    // ============================================================
    // 3. ĐĂNG KÝ SERVER
    // ============================================================
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        // Các biến dùng cho Dropdown trong Form đăng ký
        model.addAttribute("versions", versionRepo.findAll());
        model.addAttribute("resetTypes", resetRepo.findAll());
        model.addAttribute("pointTypes", pointRepo.findAll());

        // [ĐÃ CÓ SẴN menuVersions, menuTypes DO @ModelAttribute Ở TRÊN CHO HEADER]

        model.addAttribute("serverDTO", new ServerRegisterDTO());

        long usedSuperVip = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(
                Server.BannerPackage.SUPER_VIP, Server.Status.APPROVED
        );
        long usedVip = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(
                Server.BannerPackage.VIP, Server.Status.APPROVED
        );

        model.addAttribute("usedSuperVip", usedSuperVip);
        model.addAttribute("usedVip", usedVip);

        return "server-register";
    }

    @PostMapping("/create")
    public String createServer(
            @ModelAttribute("serverDTO") ServerRegisterDTO serverDTO,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            MultipartFile file = serverDTO.getBannerFile();
            String finalImageUrl = null;

            if (file != null && !file.isEmpty()) {
                finalImageUrl = saveFileAndGetUrl(file);
            } else if (serverDTO.getBannerUrl() != null && !serverDTO.getBannerUrl().isBlank()) {
                finalImageUrl = serverDTO.getBannerUrl();
            }

            serverDTO.setBannerUrl(finalImageUrl);
            serverService.registerServer(serverDTO, currentUser);

            return "redirect:/server/register?status=success";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
            return "redirect:/server/register?status=error";
        }
    }

    private String saveFileAndGetUrl(MultipartFile file) throws IOException {
        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        String fileName = UUID.randomUUID().toString() + "_" + originalFilename;

        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return "/uploads/" + fileName;
    }
}