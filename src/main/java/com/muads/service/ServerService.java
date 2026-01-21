package com.muads.service;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.*;
import com.muads.repository.*;
import jakarta.transaction.Transactional; // Dùng Jakarta cho Spring Boot 3
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ServerService {

    @Autowired private ServerScheduleRepository scheduleRepository;
    @Autowired private ServerRepository serverRepository;
    @Autowired private MuVersionRepository versionRepo;
    @Autowired private ResetTypeRepository resetRepo;
    @Autowired private PointTypeRepository pointRepo;

    // --- 1. ĐĂNG KÝ SERVER (Logic của bạn) ---
    @Transactional
    public void registerServer(ServerRegisterDTO dto, User owner) {

        // Xử lý gói & Check Slot (30 SuperVIP / 8 VIP)
        Server.BannerPackage selectedPackage;
        try {
            if (dto.getBannerPackage() != null && !dto.getBannerPackage().isEmpty()) {
                selectedPackage = Server.BannerPackage.valueOf(dto.getBannerPackage());
            } else {
                selectedPackage = Server.BannerPackage.BASIC;
            }
        } catch (IllegalArgumentException e) {
            selectedPackage = Server.BannerPackage.BASIC;
        }

        // Logic check slot: Chỉ đếm các server APPROVED
        if (selectedPackage == Server.BannerPackage.SUPER_VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.SUPER_VIP, Server.Status.APPROVED);
            if (count >= 30) selectedPackage = Server.BannerPackage.BASIC;
        } else if (selectedPackage == Server.BannerPackage.VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.VIP, Server.Status.APPROVED);
            if (count >= 8) selectedPackage = Server.BannerPackage.BASIC;
        }

        Server server = new Server();
        server.setBannerPackage(selectedPackage);
        server.setServerName(dto.getServerName());
        server.setMuName(dto.getMuName());
        server.setSlogan(dto.getSlogan());
        server.setWebsiteUrl(dto.getWebsiteUrl());
        server.setFanpageUrl(dto.getFanpageUrl());
        server.setDescription(dto.getDescription());
        server.setStatus(Server.Status.PENDING);
        server.setIsActive(false);
        server.setUser(owner);

        // Ảnh Banner
        if (dto.getBannerUrl() != null && !dto.getBannerUrl().trim().isEmpty()) {
            server.setBannerImage(dto.getBannerUrl().trim());
        } else {
            server.setBannerImage(null);
        }

        server = serverRepository.save(server);

        // Lưu Schedule
        ServerSchedule schedule = new ServerSchedule();
        schedule.setAlphaDate(dto.getAlphaDate());
        schedule.setAlphaTime(dto.getAlphaTime());
        schedule.setBetaDate(dto.getBetaDate());
        schedule.setBetaTime(dto.getBetaTime());
        schedule.setServer(server);
        scheduleRepository.save(schedule);

        // Lưu Stat
        ServerStat stat = new ServerStat();
        stat.setExpRate(dto.getExpRate());
        stat.setDropRate(dto.getDropRate());
        stat.setAntiHack(dto.getAntiHack());

        if (dto.getVersionId() != null) stat.setMuVersion(versionRepo.findById(dto.getVersionId()).orElse(null));
        if (dto.getResetId() != null) stat.setResetType(resetRepo.findById(dto.getResetId()).orElse(null));
        if (dto.getPointId() != null) stat.setPointType(pointRepo.findById(dto.getPointId()).orElse(null));

        stat.setServer(server);
        server.setServerStat(stat);

        serverRepository.save(server);
    }

    // --- 2. DUYỆT SERVER (Kèm logic tính ngày hết hạn) ---
    @Transactional
    public void approveServer(Long serverId) {
        Server server = getServerById(serverId);

        // Cập nhật trạng thái
        server.setStatus(Server.Status.APPROVED);
        server.setIsActive(true);

        LocalDateTime now = LocalDateTime.now();
        server.setApprovedAt(now);

        // Tự động tính ngày hết hạn dựa vào Enum BannerPackage
        // SuperVIP = 14 ngày, còn lại = 10 ngày
        int days = server.getBannerPackage().getDurationDays();
        server.setExpiredAt(now.plusDays(days));

        serverRepository.save(server);
    }

    // --- 3. TỪ CHỐI SERVER ---
    @Transactional
    public void rejectServer(Long serverId) {
        Server server = getServerById(serverId);
        server.setStatus(Server.Status.REJECTED);
        server.setIsActive(false);
        serverRepository.save(server);
    }

    // --- 4. [MỚI] TỰ ĐỘNG QUÉT SERVER HẾT HẠN ---
    // Chạy mỗi 30 phút (1800000 ms)
    @Scheduled(fixedRate = 1800000)
    @Transactional
    public void autoExpireServers() {
        LocalDateTime now = LocalDateTime.now();

        // Tìm các server đang APPROVED mà expiredAt < hiện tại
        List<Server> expiredServers = serverRepository.findByStatusAndExpiredAtBefore(Server.Status.APPROVED, now);

        if (!expiredServers.isEmpty()) {
            for (Server s : expiredServers) {
                s.setStatus(Server.Status.EXPIRED); // Chuyển sang EXPIRED
                s.setIsActive(false);               // Tắt hiển thị

                // (Tuỳ chọn) Có thể reset về gói BASIC để lần sau họ gia hạn
                // s.setBannerPackage(Server.BannerPackage.BASIC);
            }
            serverRepository.saveAll(expiredServers);
            System.out.println("CronJob: Đã chuyển " + expiredServers.size() + " server sang trạng thái EXPIRED.");
        }
    }

    // Helpers
    public List<Server> getApprovedServers() {
        return serverRepository.findByStatusOrderByCreatedAtDesc(Server.Status.APPROVED);
    }

    public List<Server> getPendingServers() {
        return serverRepository.findByStatusOrderByCreatedAtDesc(Server.Status.PENDING);
    }

    public Server getServerById(Long id) {
        return serverRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Server ID: " + id));
    }
}