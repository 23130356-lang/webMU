package com.muads.service;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.*;
import com.muads.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    @Transactional
    public void registerServer(ServerRegisterDTO dto, User owner) {

        // --- BƯỚC 1: TẠO SERVER VÀ CẤU HÌNH CƠ BẢN ---
        Server server = new Server();
        server.setServerName(dto.getServerName());
        server.setMuName(dto.getMuName());
        server.setSlogan(dto.getSlogan());
        server.setWebsiteUrl(dto.getWebsiteUrl());
        server.setFanpageUrl(dto.getFanpageUrl());
        server.setDescription(dto.getDescription());
        server.setStatus(Server.Status.PENDING); // Mặc định là chờ duyệt
        server.setUser(owner); // Gán chủ sở hữu

        // --- [MỚI] XỬ LÝ GÓI BANNER (QUAN TRỌNG) ---
        // Logic: Lấy chuỗi từ DTO (ví dụ "VIP") -> Chuyển thành Enum (BannerPackage.VIP)
        try {
            if (dto.getBannerPackage() != null && !dto.getBannerPackage().isEmpty()) {
                // Chuyển đổi String sang Enum
                server.setBannerPackage(Server.BannerPackage.valueOf(dto.getBannerPackage()));
            } else {
                // Nếu không chọn gì -> Mặc định là BASIC
                server.setBannerPackage(Server.BannerPackage.BASIC);
            }
        } catch (IllegalArgumentException e) {
            // Nếu dữ liệu gửi lên bị sai (hack/lỗi) -> Mặc định về BASIC để không lỗi server
            server.setBannerPackage(Server.BannerPackage.BASIC);
        }

        // Lưu lần 1: Để database sinh ra ID cho Server (VD: ID = 10)
        server = serverRepository.save(server);


        // --- BƯỚC 2: TẠO SCHEDULE VÀ GẮN ID SERVER VÀO ---
        ServerSchedule schedule = new ServerSchedule();

        // Gán dữ liệu ngày giờ
        schedule.setAlphaDate(dto.getAlphaDate());
        schedule.setAlphaTime(dto.getAlphaTime());
        schedule.setBetaDate(dto.getBetaDate());
        schedule.setBetaTime(dto.getBetaTime());

        // GÁN 2 CHIỀU ĐỂ KHÔNG BỊ MẤT LIÊN KẾT
        schedule.setServer(server); // Nói cho Schedule biết cha nó là ai
        server.setSchedule(schedule); // Nói cho Server biết nó có đứa con này

        // --- BƯỚC 3: LƯU SCHEDULE ---
        scheduleRepository.save(schedule);


        // --- BƯỚC 4: XỬ LÝ STAT (Tương tự) ---
        ServerStat stat = new ServerStat();
        stat.setExpRate(dto.getExpRate());
        stat.setDropRate(dto.getDropRate());
        stat.setAntiHack(dto.getAntiHack());

        // Map các ID dropdown (Xử lý null safe)
        if (dto.getVersionId() != null) stat.setMuVersion(versionRepo.findById(dto.getVersionId()).orElse(null));
        if (dto.getResetId() != null) stat.setResetType(resetRepo.findById(dto.getResetId()).orElse(null));
        if (dto.getPointId() != null) stat.setPointType(pointRepo.findById(dto.getPointId()).orElse(null));

        // Gán 2 chiều cho Stat
        stat.setServer(server);
        server.setServerStat(stat);

        // Lưu server lần cuối để chốt tất cả thay đổi (bao gồm cả Stat nhờ Cascade)
        serverRepository.save(server);
    }
    public List<Server> getApprovedServers() {
        // Gọi hàm vừa viết ở Repository
        return serverRepository.findByStatusOrderByCreatedAtDesc(Server.Status.APPROVED);
    }
    public Server getServerById(Long id) {
        return serverRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy Server ID: " + id));
    }
}