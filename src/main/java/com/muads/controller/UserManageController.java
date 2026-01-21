package com.muads.controller;

import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.service.UserManageService;
import com.muads.service.UserService; // Cần import UserService để làm mới session
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/manage")
public class UserManageController {

    @Autowired
    private UserManageService userManageService;

    @Autowired
    private UserService userService; // Dùng để lấy lại thông tin User mới nhất (số dư coin)

    // === 1. QUẢN LÝ SERVER ===

    @GetMapping("/servers")
    public String listMyServers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        // CẬP NHẬT SESSION: Lấy user mới nhất từ DB để hiển thị đúng số dư Coin hiện tại
        // (Tránh trường hợp vừa trừ tiền xong nhưng session vẫn lưu số cũ)
        User freshUser = userService.findById(user.getId());
        if (freshUser != null) {
            session.setAttribute("currentUser", freshUser);
        }

        model.addAttribute("servers", userManageService.getMyServers(user.getId()));
        return "manage/my-servers"; // File JSP danh sách
    }

    @GetMapping("/servers/edit/{id}")
    public String showEditForm(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirect) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        try {
            Server server = userManageService.getServerForEdit(id, user.getId());
            model.addAttribute("server", server);
            return "manage/edit-server"; // File JSP form sửa
        } catch (Exception e) {
            redirect.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/manage/servers";
        }
    }



    // === [MỚI] CHỨC NĂNG GIA HẠN SERVER ===
    @GetMapping("/servers/renew/{id}")
    public String renewServer(@PathVariable("id") Long serverId,
                              HttpSession session,
                              RedirectAttributes redirect) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        try {
            // 1. Gọi Service xử lý logic gia hạn (Trừ tiền + Cộng ngày/Check slot)
            userManageService.renewServer(serverId, user.getId());

            // 2. Cập nhật lại Session ngay lập tức để hiển thị số Coin mới trên Header
            User freshUser = userService.findById(user.getId());
            session.setAttribute("currentUser", freshUser);

            redirect.addFlashAttribute("successMessage", "Gia hạn thành công! Server đã được cộng thêm ngày.");
        } catch (RuntimeException e) {
            // Lỗi nghiệp vụ (Không đủ tiền, hết slot, không phải chủ sở hữu...)
            redirect.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            // Lỗi hệ thống khác
            e.printStackTrace();
            redirect.addFlashAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        return "redirect:/manage/servers";
    }

    // === 2. QUẢN LÝ BANNER ===

    @GetMapping("/banners")
    public String listMyBanners(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        model.addAttribute("banners", userManageService.getMyBanners(user.getId()));
        return "manage/my-banners";
    }
}