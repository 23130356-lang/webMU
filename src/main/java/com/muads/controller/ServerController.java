package com.muads.controller;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.User;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.PointTypeRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.service.ServerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/server")
public class ServerController {

    @Autowired
    private ServerService serverService;

    // Inject Repository để lấy dữ liệu đổ vào Dropdown
    @Autowired
    private MuVersionRepository versionRepo;
    @Autowired
    private ResetTypeRepository resetRepo;
    @Autowired
    private PointTypeRepository pointRepo;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        // Đổ dữ liệu danh mục vào select-box
        model.addAttribute("versions", versionRepo.findAll());
        model.addAttribute("resetTypes", resetRepo.findAll());
        model.addAttribute("pointTypes", pointRepo.findAll());

        // Gửi một DTO rỗng để form hứng dữ liệu
        model.addAttribute("serverDTO", new ServerRegisterDTO());

        return "server-register";
    }

    @PostMapping("/create")
    public String createServer(@ModelAttribute("serverDTO") ServerRegisterDTO serverDTO,
                               HttpSession session) { // Thêm tham số Session

        // 1. Kiểm tra xem đã login chưa
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login"; // Chưa login thì đá về trang login
        }

        try {
            // 2. Truyền cả User vào service
            serverService.registerServer(serverDTO, currentUser);
            return "redirect:/server/register?success=true";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/server/register?error=true";
        }
    }
}