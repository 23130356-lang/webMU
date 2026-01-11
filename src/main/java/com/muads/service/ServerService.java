package com.muads.service;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.*;
import com.muads.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

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

    // Đường dẫn thư mục uploads (nằm ở root dự án)
    private final Path UPLOAD_DIR = Paths.get("uploads");

    @Transactional
    public void registerServer(ServerRegisterDTO dto, User owner) throws IOException {

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
                // Hết chỗ SuperVIP -> chuyển về thường
                selectedPackage = Server.BannerPackage.BASIC;
            }
        } else if (selectedPackage == Server.BannerPackage.VIP) {
            long count = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(Server.BannerPackage.VIP, Server.Status.APPROVED);
            if (count >= 8) {
                // Hết chỗ VIP -> chuyển về thường
                selectedPackage = Server.BannerPackage.BASIC;
            }
        }

        Server server = new Server();
        server.setBannerPackage(selectedPackage); // Set gói sau khi đã check slot
        server.setServerName(dto.getServerName());
        server.setMuName(dto.getMuName());
        server.setSlogan(dto.getSlogan());
        server.setWebsiteUrl(dto.getWebsiteUrl());
        server.setFanpageUrl(dto.getFanpageUrl());
        server.setDescription(dto.getDescription());
        server.setStatus(Server.Status.PENDING);
        server.setUser(owner);

        // --- 2. XỬ LÝ ẢNH BANNER ---
        String finalBannerImage = null;

        // Ưu tiên Upload File
        if (dto.getBannerFile() != null && !dto.getBannerFile().isEmpty()) {
            finalBannerImage = saveUploadFile(dto.getBannerFile());
        }
        // Nếu không upload thì lấy Link (nếu có)
        else if (dto.getBannerUrl() != null && !dto.getBannerUrl().trim().isEmpty()) {
            finalBannerImage = dto.getBannerUrl().trim();
        }

        server.setBannerImage(finalBannerImage);

        // Lưu sơ bộ để có ID
        server = serverRepository.save(server);


        // --- 3. LƯU SCHEDULE ---
        ServerSchedule schedule = new ServerSchedule();
        schedule.setAlphaDate(dto.getAlphaDate());
        schedule.setAlphaTime(dto.getAlphaTime());
        schedule.setBetaDate(dto.getBetaDate());
        schedule.setBetaTime(dto.getBetaTime());
        schedule.setServer(server);
        server.setSchedule(schedule);
        scheduleRepository.save(schedule);

        // --- 4. LƯU STAT ---
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

    // Hàm lưu file vào thư mục uploads
    private String saveUploadFile(MultipartFile file) throws IOException {
        if (!Files.exists(UPLOAD_DIR)) {
            Files.createDirectories(UPLOAD_DIR);
        }
        // Tạo tên file ngẫu nhiên: UUID + tên gốc
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path destination = UPLOAD_DIR.resolve(fileName);

        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, destination, StandardCopyOption.REPLACE_EXISTING);
        }
        return fileName;
    }

    // --- HÀM DUYỆT SERVER (Dùng khi Admin bấm duyệt) ---
    @Transactional
    public void approveServer(Long serverId) {
        Server server = getServerById(serverId);
        server.setStatus(Server.Status.APPROVED);
        server.setIsActive(true);

        LocalDateTime now = LocalDateTime.now();
        server.setApprovedAt(now);

        // Set ngày hết hạn = Ngày hiện tại + 10 ngày
        server.setExpiredAt(now.plusDays(10));

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