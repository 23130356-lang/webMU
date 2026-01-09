package com.muads.service;

import com.muads.entity.HomeBanner;
import com.muads.repository.HomeBannerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

// --- QUAN TRỌNG: Phải có các import này thì hàm mới hoạt động ---
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
// ---------------------------------------------------------------

@Service
public class HomeBannerService {

    @Autowired
    private HomeBannerRepository bannerRepository;

    public List<HomeBanner> getAllBanners() {
        return bannerRepository.findAll();
    }

    public void saveBanner(HomeBanner banner) {
        bannerRepository.save(banner);
    }

    public void deleteBanner(Long id) {
        bannerRepository.deleteById(id);
    }

    public HomeBanner getBannerById(Long id) {
        return bannerRepository.findById(id).orElse(null);
    }

    // --- ĐÂY LÀ HÀM BẠN ĐANG BỊ THIẾU HOẶC LỖI ---
    public Map<String, List<HomeBanner>> getBannersForHomePage() {
        // 1. Lấy tất cả banner đang active (true)
        List<HomeBanner> allActive = bannerRepository.findByActiveTrue();

        // 2. Nhóm chúng lại theo positionCode (Ví dụ: nhóm LEFT_SIDEBAR vào 1 list, HERO vào 1 list...)
        Map<String, List<HomeBanner>> groupedBanners = allActive.stream()
                .collect(Collectors.groupingBy(HomeBanner::getPositionCode));

        return groupedBanners;
    }
}