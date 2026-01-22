package com.muads.service;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.*;
import com.muads.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ServerService {

    @Autowired private ServerScheduleRepository scheduleRepository;
    @Autowired private ServerRepository serverRepository;
    @Autowired private MuVersionRepository versionRepo;
    @Autowired private ResetTypeRepository resetRepo;
    @Autowired private PointTypeRepository pointRepo;

    // =========================================================================
    // 1. ĐĂNG KÝ SERVER (Đã sửa: Dùng LocalDate trực tiếp)
    // =========================================================================
    @Transactional
    public void registerServer(ServerRegisterDTO dto, User owner) {
        // --- A. Xử lý gói Banner & Check Slot ---
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

        // Check giới hạn slot
        if (selectedPackage == Server.BannerPackage.SUPER_VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.SUPER_VIP, Server.Status.APPROVED);
            if (count >= 30) selectedPackage = Server.BannerPackage.BASIC;
        } else if (selectedPackage == Server.BannerPackage.VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.VIP, Server.Status.APPROVED);
            if (count >= 8) selectedPackage = Server.BannerPackage.BASIC;
        }

        // --- B. Tạo Entity Server ---
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

        // Xử lý ảnh Banner
        if (dto.getBannerUrl() != null && !dto.getBannerUrl().trim().isEmpty()) {
            server.setBannerImage(dto.getBannerUrl().trim());
        } else {
            server.setBannerImage(null);
        }

        server = serverRepository.save(server);

        // --- C. Lưu Lịch (FIX LỖI: Gán trực tiếp LocalDate) ---
        ServerSchedule schedule = new ServerSchedule();

        // Không cần format String nữa, gán thẳng LocalDate từ DTO sang Entity
        schedule.setAlphaDate(dto.getAlphaDate());
        schedule.setAlphaTime(dto.getAlphaTime());

        schedule.setBetaDate(dto.getBetaDate());
        schedule.setBetaTime(dto.getBetaTime());

        schedule.setServer(server);
        scheduleRepository.save(schedule);

        // --- D. Lưu Thông Số ---
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

    // =========================================================================
    // 2. DUYỆT SERVER
    // =========================================================================
    @Transactional
    public void approveServer(Long serverId) {
        Server server = getServerById(serverId);
        server.setStatus(Server.Status.APPROVED);
        server.setIsActive(true);

        LocalDateTime now = LocalDateTime.now();
        server.setApprovedAt(now);

        int days = server.getBannerPackage().getDurationDays();
        server.setExpiredAt(now.plusDays(days));

        serverRepository.save(server);
    }

    // =========================================================================
    // 3. TỪ CHỐI & XÓA SERVER
    // =========================================================================
    @Transactional
    public void rejectServer(Long serverId) {
        Server server = getServerById(serverId);
        server.setStatus(Server.Status.REJECTED);
        server.setIsActive(false);
        serverRepository.save(server);
    }

    @Transactional
    public void deleteServer(Long serverId) {
        Server server = getServerById(serverId);
        if (server.getBannerImage() != null && !server.getBannerImage().isEmpty()) {
            try {
                Path imagePath = Paths.get("src/main/webapp/uploads").resolve(server.getBannerImage());
                Files.deleteIfExists(imagePath);
            } catch (IOException e) {
                System.err.println("Lỗi xóa ảnh: " + e.getMessage());
            }
        }
        serverRepository.delete(server);
    }

    // =========================================================================
    // 4. CRON JOB
    // =========================================================================
    @Scheduled(fixedRate = 1800000)
    @Transactional
    public void autoExpireServers() {
        LocalDateTime now = LocalDateTime.now();
        List<Server> expiredServers = serverRepository.findByStatusAndExpiredAtBefore(Server.Status.APPROVED, now);

        if (!expiredServers.isEmpty()) {
            for (Server s : expiredServers) {
                s.setStatus(Server.Status.EXPIRED);
                s.setIsActive(false);
            }
            serverRepository.saveAll(expiredServers);
            System.out.println("CronJob: Đã chuyển " + expiredServers.size() + " server sang trạng thái EXPIRED.");
        }
    }

    // =========================================================================
    // 5. LỌC SERVER THEO NGÀY (Đã sửa: So sánh LocalDate)
    // =========================================================================
    public List<Server> filterServersByTime(String filterType, String filterDay) {
        // 1. Lấy tất cả server ACTIVE
        List<Server> activeServers = serverRepository.findByStatusOrderByCreatedAtDesc(Server.Status.APPROVED).stream()
                .filter(s -> Boolean.TRUE.equals(s.getIsActive()))
                .collect(Collectors.toList());

        // 2. Lấy danh sách các NGÀY (LocalDate) cần tìm
        List<LocalDate> targetDates = getTargetDates(filterDay);

        // 3. Lọc trong Java (So sánh LocalDate)
        return activeServers.stream()
                .filter(s -> {
                    if (s.getSchedule() == null) return false;

                    LocalDate serverDate;
                    if ("test".equalsIgnoreCase(filterType)) {
                        serverDate = s.getSchedule().getAlphaDate();
                    } else {
                        serverDate = s.getSchedule().getBetaDate(); // Mặc định Open
                    }

                    if (serverDate == null) return false;

                    // So sánh: Ngày server có nằm trong danh sách cần tìm không?
                    return targetDates.contains(serverDate);
                })
                .collect(Collectors.toList());
    }

    /**
     * Helper: Tạo danh sách LocalDate dựa trên filterDay
     */
    private List<LocalDate> getTargetDates(String filterDay) {
        List<LocalDate> dates = new ArrayList<>();
        LocalDate today = LocalDate.now();

        if (filterDay == null) filterDay = "today";

        switch (filterDay.toLowerCase()) {
            case "yesterday":
                dates.add(today.minusDays(1));
                break;

            case "tomorrow":
                dates.add(today.plusDays(1));
                break;

            case "3days":
                dates.add(today.minusDays(1)); // Qua
                dates.add(today);              // Nay
                dates.add(today.plusDays(1));  // Mai
                break;

            case "today":
            default:
                dates.add(today);
                break;
        }
        return dates;
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