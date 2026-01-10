package com.muads.controller;

import com.muads.entity.Server;
import com.muads.entity.ServerEditRequest;
import com.muads.entity.User;
import com.muads.service.UserManageService;
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

    // === 1. QUẢN LÝ SERVER ===

    @GetMapping("/servers")
    public String listMyServers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        model.addAttribute("servers", userManageService.getMyServers(user.getId()));
        return "manage/my-servers"; // File JSP bên dưới
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

    @PostMapping("/servers/edit")
    public String processEdit(@RequestParam Long serverId,
                              @ModelAttribute ServerEditRequest requestData,
                              HttpSession session,
                              RedirectAttributes redirect) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        try {
            userManageService.submitEditRequest(serverId, user.getId(), requestData);
            redirect.addFlashAttribute("successMessage", "Đã gửi yêu cầu thành công! Vui lòng chờ Admin duyệt.");
        } catch (Exception e) {
            redirect.addFlashAttribute("errorMessage", e.getMessage());
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