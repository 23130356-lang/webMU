package com.muads.controller; // CHÚ Ý PACKAGE NÀY

import com.muads.entity.Server;
import com.muads.service.ServerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/server")
public class ServerController {

    @Autowired
    private ServerService serverService;

    // Hiển thị form đăng ký
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        // Tạo dữ liệu giả cho Dropdown (sau này lấy từ DB bảng categories)
        List<String> versions = Arrays.asList("Season 6.9", "Season 18", "Season 19");
        List<String> resetTypes = Arrays.asList("Reset Vip", "Keep Point", "Non-Reset");
        List<String> pointTypes = Arrays.asList("65k Point", "Point Thường");

        model.addAttribute("versions", versions);
        model.addAttribute("resetTypes", resetTypes);
        model.addAttribute("pointTypes", pointTypes);

        // Thêm object rỗng để hứng dữ liệu từ form
        model.addAttribute("server", new Server());

        return "server-register"; // Trả về file jsp
    }

    // Xử lý khi bấm nút "Đăng Ký"
    @PostMapping("/create")
    public String createServer(@ModelAttribute Server server) {
        System.out.println("Đang lưu Server: " + server.getServerName());

        serverService.registerNewServer(server);

        // Lưu xong chuyển hướng về trang chủ hoặc trang thông báo thành công
        return "redirect:/login?success=true";
    }
}