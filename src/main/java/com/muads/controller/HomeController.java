package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.Server;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.repository.ServerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.muads.service.HomeBannerService;
import java.util.List;
import java.util.Map;


@Controller
public class HomeController {
    @Autowired
    private HomeBannerService bannerService;

    @Autowired
    private ServerRepository serverRepository;

    @Autowired
    private MuVersionRepository versionRepo;

    @Autowired
    private ResetTypeRepository resetRepo;

    @GetMapping("/")
    public String home(Model model) {
        // --- PHẦN 1: DỮ LIỆU CHO HEADER ---
        // Header của bạn dùng biến 'menuVersions' và 'menuTypes', phải có dòng này mới hiển thị dropdown
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        List<Server> superVipList = serverRepository.findSuperVipServers();
        List<Server> vipList = serverRepository.findVipServers();
        List<Server> normalList = serverRepository.findNormalServers();

        // Đẩy sang giao diện
        model.addAttribute("superVips", superVipList);
        model.addAttribute("vips", vipList);
        model.addAttribute("normals", normalList);
        // --- PHẦN 2: DỮ LIỆU DANH SÁCH SERVER ---
        // 1. Lấy Server VIP (Hiển thị to đẹp ở trên)
        List<Server> vipServers = serverRepository.findVipServers();

        // 2. Lấy Server Thường (Hiển thị dạng danh sách ở dưới)
        List<Server> normalServers = serverRepository.findNormalServers();

        model.addAttribute("vipServers", vipServers);
        model.addAttribute("listServers", normalServers); // Đặt tên là listServers cho khớp logic chung
// 2. Logic lấy Banner mới thêm vào
        Map<String, List<HomeBanner>> banners = bannerService.getBannersForHomePage();

        model.addAttribute("bannersLeft", banners.get("LEFT_SIDEBAR"));
        model.addAttribute("bannersRight", banners.get("RIGHT_SIDEBAR"));
        model.addAttribute("bannersHero", banners.get("HERO"));
        model.addAttribute("bannersStd", banners.get("STD")); // Standard bar
        return "home"; // Trả về file home.jsp
    }
    @GetMapping("/huong-dan")
    public String guide(Model model) {
        // 1. NẠP MENU HEADER (Bắt buộc)
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());

        // 2. Trả về view
        return "guide";
    }
    @GetMapping( "/register/login")
    public String login(Model model) {
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        return "login";
    }

}