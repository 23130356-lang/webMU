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

    // Chạy mỗi 60 giây (60000ms) để kiểm tra.
    // Nếu muốn test nhanh có thể sửa thành 10000 (10 giây)
    @Scheduled(fixedRate = 10000)
    @Transactional
    public void autoExpireEverything() {
        LocalDateTime now = LocalDateTime.now();
        // System.out.println("CronJob: Đang quét dữ liệu hết hạn tại " + now);

        // --- 1. XỬ LÝ BANNER (Giữ nguyên code của bạn) ---
        // (Lưu ý: Đảm bảo HomeBannerRepository đã có hàm findByActiveTrueAndEndDateBefore)
        try {
            List<HomeBanner> expiredBanners = homeBannerRepository.findByActiveTrueAndEndDateBefore(now);
            if (!expiredBanners.isEmpty()) {
                for (HomeBanner banner : expiredBanners) {
                    banner.setActive(false);
                }
                homeBannerRepository.saveAll(expiredBanners);
                System.out.println("Auto Expire: Đã tắt " + expiredBanners.size() + " Banner hết hạn.");
            }
        } catch (Exception e) {
            // Bỏ qua lỗi nếu chưa setup xong phần Banner
        }

        // --- 2. XỬ LÝ SERVER (CẬP NHẬT MỚI) ---
        // Tìm các server đang APPROVED mà expiredAt < hiện tại
        // Sử dụng hàm mới đã khai báo trong ServerRepository
        List<Server> expiredServers = serverRepository.findByStatusAndExpiredAtBefore(Server.Status.APPROVED, now);

        if (!expiredServers.isEmpty()) {
            for (Server sv : expiredServers) {
                // 1. Chuyển trạng thái sang EXPIRED (Để lưu vào DB)
                sv.setStatus(Server.Status.EXPIRED);

                // 2. Tắt Active (Để ẩn khỏi web)
                sv.setIsActive(false);

                System.out.println("Auto Expire: Server ID " + sv.getId() + " (" + sv.getServerName() + ") -> Đã chuyển EXPIRED.");
            }
            // Lưu tất cả thay đổi
            serverRepository.saveAll(expiredServers);
        }
    }
}