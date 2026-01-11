package com.muads.service;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.*;
import com.muads.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ServerService {

    @Autowired
    private ServerScheduleRepository scheduleRepository;
    @Autowired
    private ServerRepository serverRepository;
    @Autowired
    private MuVersionRepository versionRepo;
    @Autowired
    private ResetTypeRepository resetRepo;
    @Autowired
    private PointTypeRepository pointRepo;

    // [THAY ĐỔI]: Không cần đường dẫn UPLOAD_DIR ở đây nữa vì Controller đã xử lý

    @Transactional
    public void registerServer(ServerRegisterDTO dto, User owner) { // Bỏ throws IOException

        // --- 1. XỬ LÝ GÓI & CHECK SLOT (30 SuperVIP / 8 VIP) ---
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

        // Logic check slot (Chỉ đếm các server ĐÃ DUYỆT và ĐANG CHẠY)
        if (selectedPackage == Server.BannerPackage.SUPER_VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.SUPER_VIP, Server.Status.APPROVED);
            if (count >= 30) {
                selectedPackage = Server.BannerPackage.BASIC; // Hết chỗ -> về thường
            }
        } else if (selectedPackage == Server.BannerPackage.VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.VIP, Server.Status.APPROVED);
            if (count >= 8) {
                selectedPackage = Server.BannerPackage.BASIC; // Hết chỗ -> về thường
            }
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
        server.setUser(owner);

        // --- 2. XỬ LÝ ẢNH BANNER (ĐÃ THAY ĐỔI) ---
        // Controller đã xử lý file upload và gán đường dẫn vào dto.getBannerUrl()
        // Service chỉ việc lấy ra và lưu
        if (dto.getBannerUrl() != null && !dto.getBannerUrl().trim().isEmpty()) {
            server.setBannerImage(dto.getBannerUrl().trim());
        } else {
            // Có thể set null hoặc ảnh mặc định nếu muốn
            server.setBannerImage(null);
        }

        // Lưu sơ bộ để có ID cho các bảng con
        server = serverRepository.save(server);

        // --- 3. LƯU SCHEDULE ---
        ServerSchedule schedule = new ServerSchedule();
        schedule.setAlphaDate(dto.getAlphaDate()); // Đảm bảo DTO của bạn trả về LocalDate
        schedule.setAlphaTime(dto.getAlphaTime()); // String time
        schedule.setBetaDate(dto.getBetaDate());   // LocalDate
        schedule.setBetaTime(dto.getBetaTime());   // String time
        schedule.setServer(server);
        scheduleRepository.save(schedule);

        // --- 4. LƯU STAT ---
        ServerStat stat = new ServerStat();
        stat.setExpRate(dto.getExpRate());
        stat.setDropRate(dto.getDropRate());
        stat.setAntiHack(dto.getAntiHack());

        // Kiểm tra null trước khi find
        if (dto.getVersionId() != null) stat.setMuVersion(versionRepo.findById(dto.getVersionId()).orElse(null));
        if (dto.getResetId() != null) stat.setResetType(resetRepo.findById(dto.getResetId()).orElse(null));
        if (dto.getPointId() != null) stat.setPointType(pointRepo.findById(dto.getPointId()).orElse(null));

        stat.setServer(server);
        server.setServerStat(stat);

        // Lưu lại server lần cuối để update các quan hệ (nếu CascadeType.ALL hoạt động tốt thì bước save ở trên đã đủ, nhưng save lại cho chắc chắn)
        serverRepository.save(server);
    }

    // --- HÀM DUYỆT SERVER ---
    @Transactional
    public void approveServer(Long serverId) {
        Server server = getServerById(serverId);
        server.setStatus(Server.Status.APPROVED);
        server.setIsActive(true);

        LocalDateTime now = LocalDateTime.now();
        server.setApprovedAt(now);

        // Logic ngày hết hạn: Dựa vào gói
        int days = server.getBannerPackage().getDurationDays(); // Lấy số ngày từ Enum (ví dụ 10)
        server.setExpiredAt(now.plusDays(days));

        serverRepository.save(server);
    }

    // --- HÀM TỪ CHỐI SERVER ---
    @Transactional
    public void rejectServer(Long serverId) {
        Server server = getServerById(serverId);
        server.setStatus(Server.Status.REJECTED);
        server.setIsActive(false);
        serverRepository.save(server);
    }

    public List<Server> getApprovedServers() {
        return serverRepository.findByStatusOrderByCreatedAtDesc(Server.Status.APPROVED);
    }

    public Server getServerById(Long id) {
        return serverRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Server ID: " + id));
    }
}