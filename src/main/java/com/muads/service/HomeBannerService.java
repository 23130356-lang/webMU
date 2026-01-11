package com.muads.service;

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
        BANNER_PRICES.put("STD", 100000);
        BANNER_PRICES.put("LEFT_SIDEBAR", 50000);
        BANNER_PRICES.put("RIGHT_SIDEBAR", 50000);
    }

    public Integer getPriceByPosition(String positionCode) {
        return BANNER_PRICES.getOrDefault(positionCode, 0);
    }

    // === 1. MUA VÀ TỰ ĐỘNG KÍCH HOẠT (Logic cho User) ===
    @Transactional(rollbackFor = Exception.class)
    public void purchaseAndActivateBanner(HomeBanner banner, Long userId) throws Exception {
        // A. Lấy giá
        Integer price = getPriceByPosition(banner.getPositionCode());

        // B. Lấy User
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new Exception("User không tồn tại"));

        // C. Check tiền
        Integer currentCoin = (user.getCoin() == null) ? 0 : user.getCoin();
        if (currentCoin < price) {
            throw new Exception("Số dư không đủ! Cần " + price + " coin.");
        }

        // D. Trừ tiền
        user.setCoin(currentCoin - price);
        userRepository.save(user);

        // E. Kích hoạt banner ngay lập tức (7 ngày)
        banner.setUser(user);
        banner.setActive(true);
        banner.setCreatedAt(LocalDateTime.now());
        banner.setStartDate(LocalDateTime.now());
        banner.setEndDate(LocalDateTime.now().plusDays(7));

        bannerRepository.save(banner);
    }

    // === 2. CÁC HÀM LẤY DỮ LIỆU (Logic cho Admin & Trang chủ) ===

    // Hàm bạn đang bị thiếu đây:
    public List<HomeBanner> getActiveBanners() {
        return bannerRepository.findByActive(true);
    }

    // Lấy toàn bộ banner (sắp xếp mới nhất lên đầu) - Dùng cho Admin xem lịch sử
    public List<HomeBanner> getAllBanners() {
        return bannerRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    // Lấy banner hiển thị ra trang chủ (phân loại theo vị trí)
    public Map<String, List<HomeBanner>> getBannersForHomePage() {
        Map<String, List<HomeBanner>> map = new HashMap<>();
        map.put("HERO", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("HERO"));
        map.put("STD", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("STD"));
        map.put("LEFT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("LEFT_SIDEBAR"));
        map.put("RIGHT_SIDEBAR", bannerRepository.findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc("RIGHT_SIDEBAR"));
        return map;
    }

    // Đếm số lượng banner đang chạy (để check full slot)
    public long countActiveBanners(String positionCode) {
        return bannerRepository.countByPositionCodeAndActiveTrue(positionCode);
    }

    // Xóa banner
    public void deleteBanner(Long id) {
        bannerRepository.deleteById(id);
    }

    // Tìm theo ID
    public HomeBanner findById(Long id) {
        return bannerRepository.findById(id).orElse(null);
    }
    // Trong HomeBannerService.java

    public String getNextAvailableDate(String positionCode, int limit) {
        long count = countActiveBanners(positionCode);

        if (count < limit) {
            return null;
        }

        List<HomeBanner> list = bannerRepository.findByPositionCodeAndActiveTrueOrderByEndDateAsc(positionCode);

        if (list.isEmpty()) return null;

        // Lấy ngày kết thúc
        java.time.LocalDateTime endDate = list.get(0).getEndDate();
        if (endDate == null) return null;

        // --- SỬA ĐOẠN NÀY ---
        // Trả về định dạng ISO-8601 (Ví dụ: 2026-01-15T10:30:00) để JS dễ xử lý
        return endDate.toString();
    }

}