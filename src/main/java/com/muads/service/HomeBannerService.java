package com.muads.service;

import com.muads.entity.HomeBanner;
import com.muads.repository.HomeBannerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class HomeBannerService {

    @Autowired
    private HomeBannerRepository bannerRepository;

    // === 1. PHỤC VỤ TRANG CHỦ (Hiển thị banner) ===
    public Map<String, List<HomeBanner>> getBannersForHomePage() {
        Map<String, List<HomeBanner>> map = new HashMap<>();
        map.put("HERO", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("HERO"));
        map.put("STD", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("STD"));
        map.put("LEFT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("LEFT_SIDEBAR"));
        map.put("RIGHT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("RIGHT_SIDEBAR"));
        return map;
    }

    // === 2. PHỤC VỤ TRANG ĐĂNG KÝ (Đếm slot) ===
    public long countActiveBanners(String positionCode) {
        return bannerRepository.countByPositionCodeAndActiveTrue(positionCode);
    }

    // === 3. PHỤC VỤ ADMIN (Quản lý) ===

    // Lấy danh sách CHỜ DUYỆT (active = false)
    public List<HomeBanner> getPendingBanners() {
        return bannerRepository.findByActive(false);
    }

    // Lấy danh sách ĐANG CHẠY (active = true)
    public List<HomeBanner> getActiveBanners() {
        return bannerRepository.findByActive(true);
    }

    // Tìm theo ID (Dùng khi bấm nút Duyệt hoặc Xem chi tiết)
    public HomeBanner findById(Long id) {
        return bannerRepository.findById(id).orElse(null);
    }

    // Lưu hoặc Cập nhật (Dùng cho cả Đăng ký mới và Admin duyệt)
    public void saveBanner(HomeBanner banner) {
        bannerRepository.save(banner);
    }

    // Xóa banner
    public void deleteBanner(Long id) {
        bannerRepository.deleteById(id);
    }
}