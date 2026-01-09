package com.muads.service;

import com.muads.entity.HomeBanner;
import com.muads.repository.HomeBannerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class HomeBannerService {

    @Autowired
    private HomeBannerRepository bannerRepository;

    // ==========================================================
    // PHẦN 1: LOGIC CHO TRANG CHỦ (FRONTEND)
    // ==========================================================

    /**
     * Lấy banner cho trang chủ, phân loại theo từng vị trí (HERO, STD, SIDEBAR...)
     * Đã được sắp xếp theo displayOrder (ưu tiên số nhỏ đứng trước)
     */
    public Map<String, List<HomeBanner>> getBannersForHomePage() {
        Map<String, List<HomeBanner>> map = new HashMap<>();

        // Sử dụng hàm findBy... đã khai báo trong Repository để đảm bảo tính sắp xếp
        // Lưu ý: Chuỗi "HERO", "STD"... phải khớp với cột position_code trong Database
        map.put("HERO", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("HERO"));
        map.put("STD", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("STD"));
        map.put("LEFT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("LEFT_SIDEBAR"));
        map.put("RIGHT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("RIGHT_SIDEBAR"));

        return map;
    }

    // ==========================================================
    // PHẦN 2: LOGIC CHO ADMIN (QUẢN LÝ)
    // ==========================================================

    /**
     * Lấy tất cả banner (cả ẩn và hiện) để Admin quản lý
     * Sắp xếp theo ID giảm dần (Mới nhất lên đầu)
     */
    public List<HomeBanner> getAllBanners() {
        return bannerRepository.findAll(Sort.by(Sort.Direction.DESC, "id"));
    }

    /**
     * Lấy chi tiết 1 banner theo ID (Dùng cho trang Edit)
     */
    public HomeBanner getBannerById(Long id) {
        return bannerRepository.findById(id).orElse(null);
    }

    /**
     * Lưu banner (Dùng cho cả Thêm mới và Cập nhật)
     */
    public void saveBanner(HomeBanner banner) {
        bannerRepository.save(banner);
    }

    /**
     * Xóa banner hoàn toàn khỏi Database
     */
    public void deleteBanner(Long id) {
        bannerRepository.deleteById(id);
    }

    /**
     * Đổi trạng thái Duyệt/Ẩn nhanh (Dùng cho nút toggle ngoài danh sách)
     */
    public void toggleStatus(Long id) {
        Optional<HomeBanner> optionalBanner = bannerRepository.findById(id);
        if (optionalBanner.isPresent()) {
            HomeBanner banner = optionalBanner.get();
            banner.setActive(!banner.isActive()); // Đảo ngược trạng thái (True -> False và ngược lại)
            bannerRepository.save(banner);
        }
    }
}