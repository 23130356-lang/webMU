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

    @Autowired
    private HomeBannerService bannerService;

    @Autowired
    private ServerRepository serverRepository;

    @Autowired
    private MuVersionRepository versionRepo;

    @Autowired
    private ResetTypeRepository resetRepo;

    @Autowired
    private HomeBannerRepository bannerRepo;

    @GetMapping("/")
    public String home(Model model,
                       @RequestParam(name = "group", required = false) String groupVer,
                       @RequestParam(name = "reset", required = false) Integer resetId,
                       @RequestParam(name = "versionId", required = false) Integer versionId) {

        // --- 1. DỮ LIỆU CỐ ĐỊNH (HEADER/BANNER) ---
        // Load danh sách cho Menu Header và Select box
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());

        // Load Banner (Left, Right, Hero, Standard)
        Map<String, List<HomeBanner>> banners = bannerService.getBannersForHomePage();
        model.addAttribute("bannersLeft", banners.get("LEFT_SIDEBAR"));
        model.addAttribute("bannersRight", banners.get("RIGHT_SIDEBAR"));
        model.addAttribute("bannersHero", banners.get("HERO"));
        model.addAttribute("bannersStd", banners.get("STD"));


        // --- 2. XỬ LÝ LOGIC "AUTO-MAPPING" ---
        // Nếu người dùng chọn Version cụ thể từ Header, ta cần xác định nó thuộc nhóm nào
        // để hiển thị đúng trên thanh tìm kiếm (Select Box).
        if (versionId != null && versionId > 0) {
            Optional<MuVersion> verOpt = versionRepo.findById(versionId);
            if (verOpt.isPresent()) {
                String verName = verOpt.get().getVersionName().toLowerCase();
                // Logic tự động gán Group dựa trên tên version
                if (matchesSeason(verName, 1, 5)) {
                    groupVer = "1-5";
                } else if (verName.contains("season 6") || verName.contains("ss6") || verName.contains("ss 6")) {
                    groupVer = "6";
                } else if (matchesSeasonAbove(verName, 7)) {
                    groupVer = "7+";
                }
            }
        }

        // --- 3. LOGIC TÌM KIẾM / LỌC SERVER ---
        boolean isSearching = (groupVer != null && !groupVer.isEmpty())
                || (resetId != null && resetId > 0)
                || (versionId != null && versionId > 0);

        List<Server> searchResults = new ArrayList<>();

        if (isSearching) {
            // == TRƯỜNG HỢP CÓ TÌM KIẾM ==
            List<Integer> targetVersionIds = null;

            // Ưu tiên 1: Tìm chính xác theo ID (Click từ Header)
            if (versionId != null && versionId > 0) {
                targetVersionIds = new ArrayList<>();
                targetVersionIds.add(versionId);
            }
            // Ưu tiên 2: Tìm theo Nhóm (Chọn từ Search Bar)
            else if (groupVer != null && !groupVer.isEmpty()) {
                targetVersionIds = getVersionIdsByGroup(groupVer);
            }

            // Gọi Repository tìm kiếm
            searchResults = serverRepository.searchServers(resetId, targetVersionIds);

            // Đánh dấu là đang search để hiển thị tiêu đề phù hợp ở View
            model.addAttribute("isSearching", true);

        } else {
            // == TRƯỜNG HỢP MẶC ĐỊNH (TRANG CHỦ) ==
            // Nếu không search, lấy toàn bộ server (sau đó lọc theo gói banner ở dưới)
            // Hoặc dùng các hàm findSuperVip riêng lẻ nếu muốn tối ưu query
            searchResults = serverRepository.findAll();
            // Lưu ý: Nếu findAll() quá nặng, bạn có thể quay lại cách gọi 3 hàm riêng như code cũ.
            // Ở đây tôi dùng findAll() rồi filter stream cho code gọn gàng đồng bộ với logic search.
        }

        // --- 4. PHÂN LOẠI LIST (SUPER VIP / VIP / NORMAL) ---
        List<Server> superVipList = searchResults.stream()
                .filter(s -> s.getBannerPackage() == Server.BannerPackage.SUPER_VIP)
                .collect(Collectors.toList());

        List<Server> vipList = searchResults.stream()
                .filter(s -> s.getBannerPackage() == Server.BannerPackage.VIP)
                .collect(Collectors.toList());

        List<Server> normalList = searchResults.stream()
                .filter(s -> s.getBannerPackage() == Server.BannerPackage.BASIC)
                .collect(Collectors.toList());

        // --- 5. ĐẨY DỮ LIỆU RA VIEW ---

        // List chính dùng cho giao diện mới
        model.addAttribute("superVips", superVipList);
        model.addAttribute("vips", vipList);
        model.addAttribute("normals", normalList);

        // List phụ (Legacy) để tránh lỗi nếu JSP cũ còn sót code dùng biến này
        model.addAttribute("vipServers", vipList);
        model.addAttribute("listServers", normalList);

        // Trả về tham số form để giữ trạng thái (Selected)
        model.addAttribute("selectedGroup", groupVer);
        model.addAttribute("selectedReset", resetId);

        return "home";
    }

    /**
     * Lấy danh sách ID của các version thuộc nhóm (1-5, 6, 7+)
     */
    private List<Integer> getVersionIdsByGroup(String group) {
        List<MuVersion> allVersions = versionRepo.findAll();
        List<Integer> ids = new ArrayList<>();

        for (MuVersion v : allVersions) {
            String name = v.getVersionName().toLowerCase();

            if ("1-5".equals(group)) {
                if (matchesSeason(name, 1, 5)) ids.add(v.getId());
            } else if ("6".equals(group)) {
                // Nhóm Season 6 (6.0 -> 6.15...)
                if (name.contains("season 6") || name.contains("ss6") || name.contains("ss 6")) {
                    ids.add(v.getId());
                }
            } else if ("7+".equals(group)) {
                // Nhóm Season 7 trở lên
                if (matchesSeasonAbove(name, 7)) ids.add(v.getId());
            }
        }
        if (ids.isEmpty()) ids.add(-1);
        return ids;
    }

    private boolean matchesSeason(String name, int min, int max) {
        for (int i = min; i <= max; i++) {
            // Check các biến thể tên gọi phổ biến
            if (name.contains("season " + i) || name.contains("ss" + i) || name.contains("ss " + i)) {
                return true;
            }
        }
        return false;
    }

    private boolean matchesSeasonAbove(String name, int min) {
        for (int i = min; i <= 30; i++) {
            if (name.contains("season " + i) || name.contains("ss" + i) || name.contains("ss " + i)) {
                return true;
            }
        }
        return false;
    }

    @GetMapping("/huong-dan")
    public String guide(Model model) {
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        return "guide";
    }

    @GetMapping( "/register/login")
    public String login(Model model) {
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());
        return "login";
    }
}