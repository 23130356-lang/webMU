package com.muads.controller;

import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.repository.ServerRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ServerRepository serverRepository;

    // --- HÀM KIỂM TRA QUYỀN ADMIN ---
    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    // --- 1. DANH SÁCH CHỜ DUYỆT ---
    @GetMapping("/pending")
    public String listPending(Model model, HttpSession session) {
        // Debug: In ra console để biết code đã chạy đến đây
        System.out.println(">>> AdminController: Đang vào trang Pending List");

        if (!isAdmin(session)) {
            return "redirect:/login";
        }

        // Lấy danh sách server có trạng thái PENDING
        List<Server> pendingServers = serverRepository.findByStatus(Server.Status.PENDING);

        // Đưa dữ liệu sang JSP
        model.addAttribute("servers", pendingServers);

        // Trả về file: /WEB-INF/jsp/admin/pending-list.jsp
        return "admin/pending-list";
    }

    // --- 2. XEM CHI TIẾT ---
    @GetMapping("/server/{id}")
    public String serverDetail(@PathVariable Long id, Model model, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);

        if (server == null) {
            return "redirect:/admin/pending";
        }

        model.addAttribute("sv", server);
        return "admin/server-detail";
    }

    // --- 3. DUYỆT BÀI (APPROVE) ---
    @PostMapping("/approve/{id}")
    public String approveServer(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);
        if (server != null) {
            server.setStatus(Server.Status.ACTIVE);
            serverRepository.save(server);
        }
        return "redirect:/admin/pending";
    }

    // --- 4. TỪ CHỐI / XÓA (REJECT) ---
    @PostMapping("/reject/{id}")
    public String rejectServer(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        // Xóa luôn khỏi database
        serverRepository.deleteById(id);

        return "redirect:/admin/pending";
    }
}