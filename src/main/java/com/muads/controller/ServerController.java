package com.muads.controller;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.Server;
import com.muads.entity.User;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.PointTypeRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.service.ServerService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/server")
public class ServerController {

    @Autowired
    private ServerService serverService;

    @Autowired
    private MuVersionRepository versionRepo;
    @Autowired
    private ResetTypeRepository resetRepo;
    @Autowired
    private PointTypeRepository pointRepo;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("versions", versionRepo.findAll());
        model.addAttribute("resetTypes", resetRepo.findAll());
        model.addAttribute("pointTypes", pointRepo.findAll());
        model.addAttribute("serverDTO", new ServerRegisterDTO());
        return "server-register";
    }

    @PostMapping("/create")
    public String createServer(@ModelAttribute("serverDTO") ServerRegisterDTO serverDTO,
                               HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        try {
            serverService.registerServer(serverDTO, currentUser);
            return "redirect:/server/register?success=true";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/server/register?error=true";
        }
    }

    @GetMapping("/detail/{id}")
    public String showServerDetail(@PathVariable("id") Long id, Model model) {
        Server server = serverService.getServerById(id);
        if(server == null) {
            return "redirect:/";
        }
        model.addAttribute("server", server);
        return "server-detail";
    }
}