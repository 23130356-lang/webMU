package com.muads.controller;

import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.repository.ServerRepository;
import com.muads.repository.UserRepository;
import com.muads.service.ServerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ServerRepository serverRepository;
    @Autowired

    private ServerService serverService;

    @Autowired
    private UserRepository userRepository;

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    // --- DANH SÁCH CHỜ ---
    @GetMapping("/pending")
    public String listPending(Model model, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        List<Server> pendingServers = serverRepository.findByStatus(Server.Status.PENDING);
        model.addAttribute("servers", pendingServers);
        return "admin/pending-list";
    }

    // --- DANH SÁCH ĐÃ DUYỆT (Trang mới) ---
    @GetMapping("/approved")
    public String listApproved(Model model, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        // Lấy danh sách đã duyệt, sắp xếp mới nhất
        List<Server> approvedServers = serverRepository.findByStatusOrderByCreatedAtDesc(Server.Status.APPROVED);
        model.addAttribute("servers", approvedServers);
        return "admin/approved-list";
    }

    // --- CHI TIẾT ---
    @GetMapping("/server/{id}")
    public String serverDetail(@PathVariable Long id, Model model, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        Server server = serverRepository.findById(id).orElse(null);
        if (server == null) return "redirect:/admin/pending";
        model.addAttribute("sv", server);
        return "admin/server-detail";
    }

    // --- [LOGIC QUAN TRỌNG] DUYỆT BÀI & TÍNH NGÀY ---
    // File: com.muads.controller.AdminController.java

    @PostMapping("/approve/{id}")
    public String approveServer(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        // 1. Check quyền Admin
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);

        if (server != null) {

            // --- [FIX LỖI] KIỂM TRA ĐÃ DUYỆT CHƯA ---
            // Nếu trạng thái đã là APPROVED thì báo lỗi và thoát ngay
            if (server.getStatus() == Server.Status.APPROVED) {
                redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: Server này đã được duyệt trước đó rồi!");
                return "redirect:/admin/server/" + id;
            }
            // ----------------------------------------

            User owner = server.getUser();
            Server.BannerPackage pack = server.getBannerPackage();

            int cost = (pack != null) ? pack.getPrice() : 0;
            int days = (pack != null) ? pack.getDurationDays() : 7;

            // Kiểm tra số dư
            if (owner.getCoin() < cost) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chủ tài khoản không đủ Coin (Cần " + cost + " xu).");
                return "redirect:/admin/server/" + id;
            }

            // Trừ tiền và cập nhật server (Logic cũ giữ nguyên)
            owner.setCoin(owner.getCoin() - cost);
            userRepository.save(owner);

            server.setStatus(Server.Status.APPROVED);
            server.setIsActive(true);

            LocalDateTime now = LocalDateTime.now();
            server.setApprovedAt(now);
            server.setExpiredAt(now.plusDays(days));

            serverRepository.save(server);

            redirectAttributes.addFlashAttribute("successMessage", "Duyệt thành công! Đã trừ " + cost + " xu.");
        }
        return "redirect:/admin/pending";
    }

    @PostMapping("/reject/{id}")
    public String rejectServer(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) return "redirect:/login";
        Server server = serverRepository.findById(id).orElse(null);
        if (server != null) {
            server.setStatus(Server.Status.REJECTED);
            serverRepository.save(server);
            redirectAttributes.addFlashAttribute("successMessage", "Đã từ chối server.");
        }
        return "redirect:/admin/pending";
    }
    @PostMapping("/server/delete/{id}")
    public String deleteServer(@PathVariable Long id,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        // 1. Check quyền Admin
        if (!isAdmin(session)) return "redirect:/login";

        try {
            serverService.deleteServer(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa server vĩnh viễn!");
            return "redirect:/admin/pending"; // Hoặc về /admin/approved tùy ý
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa: " + e.getMessage());
            return "redirect:/admin/server/" + id;
        }
    }
}