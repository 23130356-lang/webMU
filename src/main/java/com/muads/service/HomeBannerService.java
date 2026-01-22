package com.muads.service;

import com.muads.dto.AdminBannerDto;
import com.muads.entity.HomeBanner;
import com.muads.entity.User;
import com.muads.repository.HomeBannerRepository;
import com.muads.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class HomeBannerService {

    @Autowired
    private HomeBannerRepository bannerRepository;

    @Autowired
    private UserRepository userRepository;

    // === 0. CẤU HÌNH BẢNG GIÁ ===
    private static final Map<String, Integer> BANNER_PRICES = new HashMap<>();
    static {
        BANNER_PRICES.put("HERO", 500000);
        BANNER_PRICES.put("STD", 100);
        BANNER_PRICES.put("LEFT_SIDEBAR", 50000);
        BANNER_PRICES.put("RIGHT_SIDEBAR", 50000);
    }

    public Integer getPriceByPosition(String positionCode) {
        return BANNER_PRICES.getOrDefault(positionCode, 0);
    }

    // === 1. MUA VÀ TỰ ĐỘNG KÍCH HOẠT (Logic cho User - Giữ nguyên) ===
    @Transactional(rollbackFor = Exception.class)
    public void purchaseAndActivateBanner(HomeBanner banner, Long userId) throws Exception {
        Integer price = getPriceByPosition(banner.getPositionCode());
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new Exception("User không tồn tại"));

        Integer currentCoin = (user.getCoin() == null) ? 0 : user.getCoin();
        if (currentCoin < price) {
            throw new Exception("Số dư không đủ! Cần " + price + " coin.");
        }

        user.setCoin(currentCoin - price);
        userRepository.save(user);

        banner.setUser(user);
        banner.setActive(true);
        banner.setCreatedAt(LocalDateTime.now());
        banner.setStartDate(LocalDateTime.now());
        banner.setEndDate(LocalDateTime.now().plusDays(7));

        bannerRepository.save(banner);
    }

    // === 2. CÁC HÀM LẤY DỮ LIỆU ===
    public List<HomeBanner> getActiveBanners() {
        return bannerRepository.findByActive(true);
    }

    public List<HomeBanner> getAllBanners() {
        return bannerRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    public Map<String, List<HomeBanner>> getBannersForHomePage() {
        Map<String, List<HomeBanner>> map = new HashMap<>();
        map.put("HERO", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("HERO"));
        map.put("STD", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("STD"));
        map.put("LEFT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("LEFT_SIDEBAR"));
        map.put("RIGHT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("RIGHT_SIDEBAR"));
        return map;
    }

    public long countActiveBanners(String positionCode) {
        return bannerRepository.countByPositionCodeAndActiveTrue(positionCode);
    }

    public void deleteBanner(Long id) {
        bannerRepository.deleteById(id);
    }

    public HomeBanner findById(Long id) {
        return bannerRepository.findById(id).orElse(null);
    }

    public String getNextAvailableDate(String positionCode, int limit) {
        long count = countActiveBanners(positionCode);
        if (count < limit) return null;

        List<HomeBanner> list = bannerRepository.findByPositionCodeAndActiveTrueOrderByEndDateAsc(positionCode);
        if (list.isEmpty()) return null;

        java.time.LocalDateTime endDate = list.get(0).getEndDate();
        return (endDate == null) ? null : endDate.toString();
    }

    // === 3. LOGIC MỚI: TẠO BANNER CHO ADMIN (THÊM VÀO ĐÂY) ===
    public void createAdminBanner(AdminBannerDto dto, String finalImageUrl) {
        HomeBanner banner = new HomeBanner();

        // Set thông tin từ Form
        banner.setImageUrl(finalImageUrl);
        banner.setTargetUrl(dto.getTargetUrl());
        banner.setPositionCode(dto.getPositionCode());
        banner.setDisplayOrder(dto.getDisplayOrder());

        // Kích hoạt ngay
        banner.setActive(true);
        banner.setCreatedAt(LocalDateTime.now());

        // Tính ngày hết hạn theo số ngày Admin nhập
        LocalDateTime now = LocalDateTime.now();
        banner.setStartDate(now);
        banner.setEndDate(now.plusDays(dto.getDurationDays()));

        // User là null (để đánh dấu là banner của hệ thống/admin)
        banner.setUser(null);

        bannerRepository.save(banner);
    }
}