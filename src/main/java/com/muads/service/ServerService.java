package com.muads.service;

import com.muads.dto.ServerRegisterDTO;
import com.muads.entity.*;
import com.muads.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServerService {

    @Autowired
    private ServerRepository serverRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private MuVersionRepository versionRepo;
    @Autowired
    private ResetTypeRepository resetRepo;
    @Autowired
    private PointTypeRepository pointRepo;

    // Dùng @Transactional để đảm bảo lưu cả 3 bảng thành công, nếu 1 bảng lỗi sẽ rollback hết
    @Transactional
    public void registerServer(ServerRegisterDTO dto, User owner) {

        // 1. Tạo đối tượng SERVER (Thông tin chung)
        Server server = new Server();
        server.setServerName(dto.getServerName());
        server.setMuName(dto.getMuName());
        server.setSlogan(dto.getSlogan());
        server.setWebsiteUrl(dto.getWebsiteUrl());
        server.setFanpageUrl(dto.getFanpageUrl());
        server.setDescription(dto.getDescription());
        server.setStatus(Server.Status.PENDING); // Mặc định chờ duyệt

        // --- QUAN TRỌNG: Gán User chủ server ---
        // Tạm thời lấy User ID = 1 (Giả sử admin hoặc user đầu tiên).
        // Sau này khi có chức năng Login, bạn sẽ lấy User đang đăng nhập từ Session.
        server.setUser(owner);

        // 2. Tạo đối tượng SCHEDULE (Lịch trình)
        ServerSchedule schedule = new ServerSchedule();
        schedule.setAlphaDate(dto.getAlphaDate());
        schedule.setAlphaTime(dto.getAlphaTime());
        schedule.setBetaDate(dto.getBetaDate());
        schedule.setBetaTime(dto.getBetaTime());

        // Liên kết 2 chiều: Schedule thuộc về Server này
        schedule.setServer(server);
        server.setSchedule(schedule); // Gán vào server để Cascade lưu luôn

        // 3. Tạo đối tượng STAT (Cấu hình)
        ServerStat stat = new ServerStat();
        stat.setExpRate(dto.getExpRate());
        stat.setDropRate(dto.getDropRate());
        stat.setAntiHack(dto.getAntiHack());

        // Tìm và gán các danh mục (Version, Reset, Point) dựa vào ID gửi lên
        if (dto.getVersionId() != null) {
            stat.setMuVersion(versionRepo.findById(dto.getVersionId()).orElse(null));
        }
        if (dto.getResetId() != null) {
            stat.setResetType(resetRepo.findById(dto.getResetId()).orElse(null));
        }
        if (dto.getPointId() != null) {
            stat.setPointType(pointRepo.findById(dto.getPointId()).orElse(null));
        }

        // Liên kết 2 chiều
        stat.setServer(server);
        server.setServerStat(stat);

        // 4. LƯU TẤT CẢ (Chỉ cần save thằng cha Server, nhờ CascadeType.ALL, con sẽ được lưu theo)
        serverRepository.save(server);
    }
}