package com.muads.service;

import com.muads.entity.HomeBanner;
import com.muads.entity.Server;
import com.muads.repository.HomeBannerRepository;
import com.muads.repository.ServerRepository;
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

    @Autowired
    private ServerRepository serverRepository;

    // Chạy mỗi 60 giây để kiểm tra
    @Scheduled(fixedRate = 60000)
    @Transactional
    public void autoExpireEverything() {
        LocalDateTime now = LocalDateTime.now();

        // 1. Quét Banner Trang Chủ hết hạn
        List<HomeBanner> expiredBanners = homeBannerRepository.findByActiveTrueAndEndDateBefore(now);
        if (!expiredBanners.isEmpty()) {
            for (HomeBanner banner : expiredBanners) {
                banner.setActive(false);
            }
            homeBannerRepository.saveAll(expiredBanners);
        }

        // 2. Quét Server Quảng Cáo hết hạn (Quá 10 ngày)
        List<Server> expiredServers = serverRepository.findByIsActiveTrueAndExpiredAtBefore(now);
        if (!expiredServers.isEmpty()) {
            for (Server sv : expiredServers) {
                sv.setIsActive(false); // Tắt server
                System.out.println("Auto Expire: Tắt Server ID " + sv.getId() + " - " + sv.getServerName());
            }
            serverRepository.saveAll(expiredServers);
        }
    }
}