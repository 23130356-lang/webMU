package com.muads.service;

import com.muads.entity.HomeBanner;
import com.muads.repository.HomeBannerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ServerAutoExpireService {

    @Autowired
    private HomeBannerRepository homeBannerRepository;

    // Chạy mỗi 60 giây (60000ms) để kiểm tra
    @Scheduled(fixedRate = 60000)
    @Transactional // Đảm bảo tính toàn vẹn dữ liệu khi update DB
    public void autoExpireBanners() {
        LocalDateTime now = LocalDateTime.now();

        // 1. Tìm các banner hết hạn (Active = true VÀ EndDate < Now)
        List<HomeBanner> expiredBanners = homeBannerRepository.findByActiveTrueAndEndDateBefore(now);

        if (!expiredBanners.isEmpty()) {
            // 2. Duyệt qua và tắt chúng đi
            for (HomeBanner banner : expiredBanners) {
                banner.setActive(false);
                System.out.println("Đã gỡ Banner ID: " + banner.getId() + " - Hết hạn lúc: " + banner.getEndDate());
            }

            // 3. Lưu lại vào DB
            homeBannerRepository.saveAll(expiredBanners);
        }
    }
}