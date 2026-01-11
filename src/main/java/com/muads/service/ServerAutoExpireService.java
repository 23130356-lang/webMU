package com.muads.service;

import com.muads.entity.Server;
import com.muads.repository.ServerRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ServerAutoExpireService {

    @Autowired
    private ServerRepository serverRepository;

    // Chạy mỗi 1 tiếng (3600000 ms) hoặc 10 phút tùy bạn cấu hình
    // initialDelay: Chờ 5 giây sau khi bật server mới bắt đầu quét lần đầu
    @Scheduled(fixedRate = 3600000, initialDelay = 5000)
    @Transactional
    public void autoDisableExpiredServers() {
        LocalDateTime now = LocalDateTime.now();

        // Tìm các server đang BẬT nhưng đã quá hạn
        List<Server> expiredServers = serverRepository.findByIsActiveTrueAndExpiredAtBefore(now);

        if (!expiredServers.isEmpty()) {

            for (Server s : expiredServers) {
                s.setIsActive(false); // Tắt server
                // s.setStatus(Server.Status.EXPIRED); // (Tuỳ chọn) Nếu muốn đổi trạng thái
            }
            serverRepository.saveAll(expiredServers); // Lưu tất cả một lần
        }
    }
}