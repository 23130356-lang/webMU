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

    // --- 3. Hành động: DUYỆT BÀI (Approve) ---
    @PostMapping("/approve/{id}")
    public String approveServer(@PathVariable Long id, HttpSession session) {
        // Check quyền admin
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);
        if (server != null) {
            // CẬP NHẬT TRẠNG THÁI MỚI
            server.setStatus(Server.Status.APPROVED); // <-- Sửa ACTIVE thành APPROVED

            // LƯU VÀO DATABASE
            serverRepository.save(server);
        }
        return "redirect:/admin/pending";
    }

    // --- 4. Hành động: TỪ CHỐI (Reject) ---
    @PostMapping("/reject/{id}")
    public String rejectServer(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);
        if (server != null) {
            // Cách 1: Xóa luôn khỏi DB (như code cũ)
            // serverRepository.deleteById(id);

            // Cách 2: Cập nhật trạng thái REJECTED (để lưu lịch sử) -> Khuyên dùng cách này nếu DB đã có ENUM REJECTED
            server.setStatus(Server.Status.REJECTED);
            serverRepository.save(server);
        }
        return "redirect:/admin/pending";
    }
}