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

        // --- BƯỚC 1: TẠO SERVER VÀ LƯU ĐỂ LẤY ID ---
        Server server = new Server();
        server.setServerName(dto.getServerName());
        server.setMuName(dto.getMuName());
        server.setSlogan(dto.getSlogan());
        server.setWebsiteUrl(dto.getWebsiteUrl());
        server.setFanpageUrl(dto.getFanpageUrl());
        server.setDescription(dto.getDescription());
        server.setStatus(Server.Status.PENDING);
        server.setUser(owner);

        // Lưu lần 1: Để database sinh ra ID cho Server (VD: ID = 10)
        server = serverRepository.save(server);

        // --- BƯỚC 2: TẠO SCHEDULE VÀ GẮN ID SERVER VÀO ---
        ServerSchedule schedule = new ServerSchedule();

        // Gán dữ liệu ngày giờ
        schedule.setAlphaDate(dto.getAlphaDate());
        schedule.setAlphaTime(dto.getAlphaTime());
        schedule.setBetaDate(dto.getBetaDate());
        schedule.setBetaTime(dto.getBetaTime());

        // QUAN TRỌNG NHẤT: GÁN 2 CHIỀU ĐỂ KHÔNG BỊ MẤT LIÊN KẾT

        // 1. Nói cho Schedule biết cha nó là ai (Để điền vào cột server_id trong DB)
        schedule.setServer(server);

        // 2. Nói cho Server biết nó có đứa con này (Để Java cập nhật bộ nhớ)
        server.setSchedule(schedule);

        // --- BƯỚC 3: LƯU SCHEDULE ---
        // Lúc này schedule đã cầm ID của server, nên khi lưu nó sẽ điền đúng server_id
        scheduleRepository.save(schedule);

        // --- BƯỚC 4: XỬ LÝ STAT (Tương tự) ---
        ServerStat stat = new ServerStat();
        stat.setExpRate(dto.getExpRate());
        stat.setDropRate(dto.getDropRate());
        stat.setAntiHack(dto.getAntiHack());

        // Map các ID dropdown...
        if (dto.getVersionId() != null) stat.setMuVersion(versionRepo.findById(dto.getVersionId()).orElse(null));
        if (dto.getResetId() != null) stat.setResetType(resetRepo.findById(dto.getResetId()).orElse(null));
        if (dto.getPointId() != null) stat.setPointType(pointRepo.findById(dto.getPointId()).orElse(null));

        // Gán 2 chiều cho Stat luôn cho chắc
        stat.setServer(server);
        server.setServerStat(stat);

        // Bạn có thể lưu stat thủ công hoặc lưu server lần cuối để chốt
        serverRepository.save(server);

    }

}