package com.muads.controller;

import com.muads.entity.HomeBanner;
import com.muads.entity.MuVersion;
import com.muads.entity.ResetType;
import com.muads.entity.Server;
import com.muads.repository.MuVersionRepository;
import com.muads.repository.ResetTypeRepository;
import com.muads.repository.ServerRepository;
import com.muads.service.HomeBannerService;
import com.muads.util.SlugUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    // ========================================================================
    // 1. TRANG CHỦ & ĐIỀU HƯỚNG
    // ========================================================================
    @GetMapping("/")
    public String home(Model model,
                       @RequestParam(name = "group", required = false) String groupVer,
                       @RequestParam(name = "reset", required = false) Integer resetId,
                       @RequestParam(name = "versionId", required = false) Integer versionId) {

        // Auto-Redirect: Chuyển link tham số (?versionId=1) sang link đẹp (/mu/season-1)
        if (versionId != null && versionId > 0) {
            Optional<MuVersion> v = versionRepo.findById(versionId);
            if (v.isPresent()) {
                return "redirect:/mu/" + SlugUtils.toSlug(v.get().getVersionName()) + "#result-list";
            }
        }
        if (resetId != null && resetId > 0) {
            Optional<ResetType> r = resetRepo.findById(resetId);
            if (r.isPresent()) {
                return "redirect:/mu/" + SlugUtils.toSlug(r.get().getResetName()) + "#result-list";
            }
        }

        return loadHomeData(model, null, null, null, "Mu Mới Ra - Cổng Game Munoria", "https://munoria.mobile/");
    }

    // ========================================================================
    // 2. TRANG LỌC SEO
    // ========================================================================
    @GetMapping("/mu/{slug}")
    public String seoFilter(@PathVariable("slug") String slug, Model model) {

        Integer foundVersionId = null;
        Integer foundResetId = null;
        String foundGroup = null;
        String niceName = "";

        // 1. Tìm trong Version
        List<MuVersion> versions = versionRepo.findAll();
        for (MuVersion v : versions) {
            if (SlugUtils.toSlug(v.getVersionName()).equals(slug)) {
                foundVersionId = v.getId();
                niceName = v.getVersionName();
                break;
            }
        }

        // 2. Tìm trong ResetType
        if (foundVersionId == null) {
            List<ResetType> resets = resetRepo.findAll();
            for (ResetType r : resets) {
                if (SlugUtils.toSlug(r.getResetName()).equals(slug)) {
                    foundResetId = r.getId();
                    niceName = r.getResetName();
                    break;
                }
            }
        }

        // 3. Fallback: Hỗ trợ các keyword group cũ
        if (foundVersionId == null && foundResetId == null) {
            if (slug.equals("season-xua")) foundGroup = "1-5";
            else if (slug.equals("season-cao")) foundGroup = "7+";
            else if (slug.equals("season-6")) foundGroup = "6x";
        }

        // 4. Không tìm thấy -> Về trang chủ
        if (foundVersionId == null && foundResetId == null && foundGroup == null) {
            return "redirect:/";
        }

        String pageTitle = "Top Mu Online " + (niceName.isEmpty() ? slug : niceName) + " Mới Nhất";
        String canonical = "https://munoria.mobile/mu/" + slug;

        return loadHomeData(model, foundGroup, foundResetId, foundVersionId, pageTitle, canonical);
    }

    // ========================================================================
    // 3. CORE LOGIC: XỬ LÝ GỘP NHÓM SEASON
    // ========================================================================
    private String loadHomeData(Model model, String groupVer, Integer resetId, Integer versionId, String pageTitle, String canonicalUrl) {

        // --- A. MENU & BANNER ---
        model.addAttribute("menuVersions", versionRepo.findAll());
        model.addAttribute("menuTypes", resetRepo.findAll());

        Map<String, List<HomeBanner>> banners = bannerService.getBannersForHomePage();
        model.addAttribute("bannersLeft", banners.get("LEFT_SIDEBAR"));
        model.addAttribute("bannersRight", banners.get("RIGHT_SIDEBAR"));
        model.addAttribute("bannersHero", banners.get("HERO"));
        model.addAttribute("bannersStd", banners.get("STD"));

        // --- B. XỬ LÝ LOGIC LỌC (CẬP NHẬT MỚI TẠI ĐÂY) ---
        List<Integer> targetVersionIds = null;
        String filterDisplayName = "";

        if (versionId != null && versionId > 0) {

            // --- NHÓM 1: CLASSIC (SS 0-1, SS 2, SS 3-5) ---
            // ID tương ứng: 1, 2, 3
            if (versionId == 1 || versionId == 2 || versionId == 3) {
                targetVersionIds = List.of(1, 2, 3);
                filterDisplayName = "Season 1 - 5 (Classic)";
                pageTitle = "Danh sách Mu Online Season 1, 2, 3, 4, 5 Mới Nhất";
            }

            // --- NHÓM 2: MODERN (SS 7+, SS 16+, SS 21) ---
            // ID tương ứng: 5, 6, 7
            else if (versionId == 5 || versionId == 6 || versionId == 7) {
                targetVersionIds = List.of(5, 6, 7);
                filterDisplayName = "Season 7 - Mới Nhất";
                pageTitle = "Danh sách Mu Online Season cao (SS7 đến SS21) Mới Nhất";
            }

            // --- NHÓM 3: RIÊNG LẺ (Ví dụ: SS6 - ID 4) ---
            else {
                targetVersionIds = List.of(versionId);
                Optional<MuVersion> v = versionRepo.findById(versionId);
                if (v.isPresent()) {
                    filterDisplayName = v.get().getVersionName();
                }
            }
        }
        else if (groupVer != null && !groupVer.isEmpty()) {
            targetVersionIds = getVersionIdsByGroup(groupVer);
        }

        // Xử lý tên hiển thị khi lọc theo Reset
        if (resetId != null && resetId > 0) {
            Optional<ResetType> r = resetRepo.findById(resetId);
            if (r.isPresent()) {
                filterDisplayName = filterDisplayName.isEmpty()
                        ? r.get().getResetName()
                        : filterDisplayName + " - " + r.get().getResetName();
            }
        }

        // --- C. TRUY VẤN DATABASE ---
        boolean isSearching = (targetVersionIds != null) || (resetId != null && resetId > 0);
        List<Server> rawCandidates;

        if (isSearching) {
            rawCandidates = serverRepository.searchServers(resetId, targetVersionIds);
            model.addAttribute("isSearching", true);
            model.addAttribute("filterDisplay", filterDisplayName);
        } else {
            rawCandidates = serverRepository.findAll();
        }

        // --- D. LỌC KẾT QUẢ & PHÂN LOẠI VIP ---
        List<Server> approvedServers = rawCandidates.stream()
                .filter(s -> s.getStatus() == Server.Status.APPROVED)
                .collect(Collectors.toList());

        model.addAttribute("superVips", approvedServers.stream().filter(s -> s.getBannerPackage() == Server.BannerPackage.SUPER_VIP).collect(Collectors.toList()));
        model.addAttribute("vips", approvedServers.stream().filter(s -> s.getBannerPackage() == Server.BannerPackage.VIP).collect(Collectors.toList()));
        model.addAttribute("normals", approvedServers.stream().filter(s -> s.getBannerPackage() == Server.BannerPackage.BASIC).collect(Collectors.toList()));

        // --- E. META DATA ---
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("metaDescription", "Danh sách Mu Online " + (filterDisplayName.isEmpty() ? "Mới Ra" : filterDisplayName) + ".");
        model.addAttribute("canonicalUrl", canonicalUrl);
        model.addAttribute("selectedVersion", versionId); // Để select box giữ đúng phiên bản đang chọn
        model.addAttribute("selectedReset", resetId);
        return "home";
    }

    // ========================================================================
    // 4. HELPER METHODS
    // ========================================================================
    private List<Integer> getVersionIdsByGroup(String group) {
        List<Integer> ids = new ArrayList<>();
        List<MuVersion> allVersions = versionRepo.findAll();

        for (MuVersion v : allVersions) {
            String name = v.getVersionName().toLowerCase();
            if ("1-5".equals(group)) {
                if (matchesSeason(name, 1, 5)) ids.add(v.getId());
            } else if ("6x".equals(group)) {
                if (name.contains("season 6") || name.contains("ss6")) ids.add(v.getId());
            } else if ("7+".equals(group)) {
                if (matchesSeasonAbove(name, 7)) ids.add(v.getId());
            }
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

    // --- STATIC PAGES ---
    @GetMapping("/huong-dan")
    public String guide(Model model) {
        model.addAttribute("pageTitle", "Hướng Dẫn | Munoria");
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