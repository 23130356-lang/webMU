package com.muads.controller;

import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.repository.ServerRepository;
import com.muads.repository.UserRepository; // 1. Import UserRepository
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // 2. Import RedirectAttributes

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ServerRepository serverRepository;

    @Autowired
    private UserRepository userRepository; // 3. Autowire UserRepository để lưu User

    // --- HÀM KIỂM TRA QUYỀN ADMIN ---
    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    // --- 1. DANH SÁCH CHỜ DUYỆT ---
    @GetMapping("/pending")
    public String listPending(Model model, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        // Lấy danh sách server có trạng thái PENDING
        List<Server> pendingServers = serverRepository.findByStatus(Server.Status.PENDING);
        model.addAttribute("servers", pendingServers);

        // Check xem có thông báo từ bên detail gửi sang không (nếu cần)
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

    // --- 3. Hành động: DUYỆT BÀI (Approve) & TRỪ TIỀN ---
    @PostMapping("/approve/{id}")
    public String approveServer(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) { // Thêm RedirectAttributes để gửi thông báo

        // Check quyền admin
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);

        if (server != null) {
            User owner = server.getUser();

            // Lấy giá tiền gói banner (xử lý null safe: nếu null thì giá = 0)
            int cost = (server.getBannerPackage() != null) ? server.getBannerPackage().getPrice() : 0;

            // --- BƯỚC 1: KIỂM TRA SỐ DƯ ---
            if (owner.getCoin() < cost) {
                // Tiền không đủ -> Báo lỗi và quay lại trang chi tiết
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Lỗi: Chủ tài khoản không đủ Coin! Cần " + cost + " xu nhưng chỉ có " + owner.getCoin() + " xu.");
                return "redirect:/admin/server/" + id;
            }

            // --- BƯỚC 2: TRỪ TIỀN & LƯU USER (QUAN TRỌNG NHẤT) ---
            owner.setCoin(owner.getCoin() - cost);
            userRepository.save(owner); // <--- Lệnh này giúp số coin mới được lưu vào DB

            // --- BƯỚC 3: CẬP NHẬT TRẠNG THÁI SERVER ---
            // (Lưu ý: Bạn dùng APPROVED hoặc ACTIVE tùy theo Enum của bạn, ở đây tôi giữ APPROVED theo code bạn gửi)
            server.setStatus(Server.Status.APPROVED);
            serverRepository.save(server);

            // Gửi thông báo thành công
            redirectAttributes.addFlashAttribute("successMessage",
                    "Duyệt thành công! Đã trừ " + cost + " xu của tài khoản " + owner.getUsername());
        }
        return "redirect:/admin/pending";
    }

    // --- 4. Hành động: TỪ CHỐI (Reject) ---
    @PostMapping("/reject/{id}")
    public String rejectServer(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) return "redirect:/login";

        Server server = serverRepository.findById(id).orElse(null);
        if (server != null) {
            // Cập nhật trạng thái REJECTED
            server.setStatus(Server.Status.REJECTED);
            serverRepository.save(server);

            redirectAttributes.addFlashAttribute("successMessage", "Đã từ chối server: " + server.getServerName());
        }
        return "redirect:/admin/pending";
    }
}