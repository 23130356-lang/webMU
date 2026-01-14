package com.muads.controller;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.PointTypeRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.repository.ServerRepository;
import com.muads.service.ServerService;
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

    @Autowired
    private ServerService serverService;

    @Autowired
    private ServerRepository serverRepository;

    @Autowired
    private MuVersionRepository versionRepo;
    @Autowired
    private ResetTypeRepository resetRepo;
    @Autowired
    private PointTypeRepository pointRepo;

    @Value("${muads.upload.path}")
    private String uploadDir;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("versions", versionRepo.findAll());
        model.addAttribute("resetTypes", resetRepo.findAll());
        model.addAttribute("pointTypes", pointRepo.findAll());
        model.addAttribute("serverDTO", new ServerRegisterDTO());

        // Đếm slot đang sử dụng
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
            // Xử lý file ảnh
            MultipartFile file = serverDTO.getBannerFile();
            String finalImageUrl = null;

            // 1. Nếu có upload file -> Lưu file và lấy đường dẫn
            if (file != null && !file.isEmpty()) {
                finalImageUrl = saveFileAndGetUrl(file);
            }
            // 2. Nếu không upload mà điền link ảnh -> Lấy link
            else if (serverDTO.getBannerUrl() != null && !serverDTO.getBannerUrl().isBlank()) {
                finalImageUrl = serverDTO.getBannerUrl();
            }

            serverDTO.setBannerUrl(finalImageUrl);

            // Gọi Service để lưu dữ liệu xuống DB
            serverService.registerServer(serverDTO, currentUser);

            // [SỬA ĐOẠN NÀY] Thay vì addFlashAttribute message, ta redirect kèm param status=success
            // Để bên JSP bắt được param này và hiện SweetAlert2
            return "redirect:/server/register?status=success";

        } catch (Exception e) {
            e.printStackTrace();
            // Giữ lại flash message để debug nếu cần, nhưng cũng thêm param error
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
            return "redirect:/server/register?status=error";
        }
    }

    @GetMapping("/detail/{id}")
    public String showServerDetail(@PathVariable("id") Long id, Model model) {
        Server server = serverService.getServerById(id);
        if (server == null) {
            return "redirect:/";
        }
        model.addAttribute("server", server);
        return "server-detail";
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