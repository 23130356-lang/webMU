package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.MuVersion;
import com.muads.entity.Server;
import com.muads.repository.HomeBannerRepository;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.repository.ServerRepository;
import com.muads.service.HomeBannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired private HomeBannerService bannerService;
    @Autowired private ServerRepository serverRepository;
    @Autowired private MuVersionRepository versionRepo;
    @Autowired private ResetTypeRepository resetRepo;

    @GetMapping("/")
    public String home(Model model,
                       @RequestParam(name = "group", required = false) String groupVer,
                       @RequestParam(name = "reset", required = false) Integer resetId,
                       @RequestParam(name = "versionId", required = false) Integer versionId) {

        // --- 1. DATA HEADER & BANNER ---
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());

        Map<String, List<HomeBanner>> banners = bannerService.getBannersForHomePage();
        model.addAttribute("bannersLeft", banners.get("LEFT_SIDEBAR"));
        model.addAttribute("bannersRight", banners.get("RIGHT_SIDEBAR"));
        model.addAttribute("bannersHero", banners.get("HERO"));
        model.addAttribute("bannersStd", banners.get("STD"));

        // --- 2. LOGIC GROUP VERSION ---
        // --- 2. LOGIC GROUP VERSION (3 GROUP) ---
        if (versionId != null && versionId > 0) {

            Optional<MuVersion> verOpt = versionRepo.findById(versionId);

            if (verOpt.isPresent()) {
                String verName = verOpt.get().getVersionName();

                switch (verName) {
                    case "SEASON 0-1":
                    case "SEASON 2":
                    case "SEASON 3-5":
                        groupVer = "1-5";
                        break;

                    case "SEASON 6":
                        groupVer = "6x";
                        break;

                    case "SEASON 7-15":
                    case "SEASON 16-20":
                    case "SEASON 21":
                        groupVer = "7+";
                        break;

                    default:
                        groupVer = null;
                }
            }
        }


        // --- 3. LẤY DỮ LIỆU THÔ (RAW DATA) ---
        boolean isSearching = (groupVer != null && !groupVer.isEmpty())
                || (resetId != null && resetId > 0)
                || (versionId != null && versionId > 0);

        List<Server> rawCandidates;

        if (isSearching) {
            // Trường hợp tìm kiếm
            List<Integer> targetVersionIds = null;
            if (versionId != null && versionId > 0) {
                targetVersionIds = List.of(versionId);
            } else if (groupVer != null && !groupVer.isEmpty()) {
                targetVersionIds = getVersionIdsByGroup(groupVer);
            }
            // Gọi search (có thể hàm này trong Repository quên lọc active = 1)
            rawCandidates = serverRepository.searchServers(resetId, targetVersionIds);
            model.addAttribute("isSearching", true);
        } else {
            // Trường hợp mặc định
            // Lấy TẤT CẢ server (kể cả chưa duyệt) để đưa xuống bộ lọc bên dưới xử lý
            rawCandidates = serverRepository.findAll();
        }

        // --- 4. BỘ LỌC "CHỐT CHẶN" (QUAN TRỌNG NHẤT) ---
        // Tại đây, ta lọc bỏ tất cả các server có trạng thái không phải APPROVED (is_active != 1).
        // Đây là lớp bảo vệ cuối cùng trước khi hiển thị.
        List<Server> approvedServers = rawCandidates.stream()
                .filter(s -> s.getStatus() == Server.Status.APPROVED)
                // LƯU Ý: Nếu entity của bạn có trường isActive riêng, hãy dùng:
                // .filter(s -> s.getIsActive() == 1)
                .collect(Collectors.toList());

        // --- 5. PHÂN LOẠI LIST (Chỉ dùng danh sách approvedServers đã lọc sạch) ---
        List<Server> superVipList = approvedServers.stream()
                .filter(s -> s.getBannerPackage() == Server.BannerPackage.SUPER_VIP)
                .collect(Collectors.toList());

        List<Server> vipList = approvedServers.stream()
                .filter(s -> s.getBannerPackage() == Server.BannerPackage.VIP)
                .collect(Collectors.toList());

        List<Server> normalList = approvedServers.stream()
                .filter(s -> s.getBannerPackage() == Server.BannerPackage.BASIC)
                .collect(Collectors.toList());

        // --- 6. TRẢ VỀ VIEW ---
        model.addAttribute("superVips", superVipList);
        model.addAttribute("vips", vipList);
        model.addAttribute("normals", normalList);

        // Các biến cũ (Legacy)
        model.addAttribute("vipServers", vipList);
        model.addAttribute("listServers", normalList);

        model.addAttribute("selectedGroup", groupVer);
        model.addAttribute("selectedReset", resetId);

        return "home";
    }

    // --- CÁC HÀM HỖ TRỢ (GIỮ NGUYÊN) ---
    private List<Integer> getVersionIdsByGroup(String group) {
        List<MuVersion> allVersions = versionRepo.findAll();
        List<Integer> ids = new ArrayList<>();
        for (MuVersion v : allVersions) {
            String name = v.getVersionName().toLowerCase();
            if ("1-5".equals(group) && matchesSeason(name, 1, 5)) ids.add(v.getId());
            else if ("6".equals(group) && (name.contains("season 6") || name.contains("ss6"))) ids.add(v.getId());
            else if ("7+".equals(group) && matchesSeasonAbove(name, 7)) ids.add(v.getId());
        }
        if (ids.isEmpty()) ids.add(-1);
        return ids;
    }

    private boolean matchesSeason(String name, int min, int max) {
        for (int i = min; i <= max; i++) {
            if (name.contains("season " + i) || name.contains("ss" + i)) return true;
        }
        return false;
    }

    private boolean matchesSeasonAbove(String name, int min) {
        for (int i = min; i <= 30; i++) {
            if (name.contains("season " + i) || name.contains("ss" + i)) return true;
        }
        return false;
    }

    @GetMapping("/huong-dan")
    public String guide(Model model) {
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        return "guide";
    }

    @GetMapping("/register/login")
    public String login(Model model) {
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        return "login";
    }
}