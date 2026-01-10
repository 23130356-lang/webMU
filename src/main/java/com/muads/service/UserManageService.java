package com.muads.service;

import com.muads.entity.*;
import com.muads.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserManageService {

    @Autowired private ServerRepository serverRepository;
    @Autowired private HomeBannerRepository homeBannerRepository;
    @Autowired private ServerEditRequestRepository editRequestRepository;

    // 1. Lấy danh sách Server của User
    public List<Server> getMyServers(Long userId) {
        return serverRepository.findByUserId(userId);
    }

    // 2. Lấy danh sách Banner của User
    public List<HomeBanner> getMyBanners(Long userId) {
        return homeBannerRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    // 3. Lấy chi tiết Server để hiện lên Form sửa (Có check quyền sở hữu)
    public Server getServerForEdit(Long serverId, Long userId) {
        Server server = serverRepository.findById(serverId)
                .orElseThrow(() -> new RuntimeException("Server không tồn tại"));

        if (!server.getUser().getId().equals(userId)) {
            throw new RuntimeException("Bạn không phải chủ sở hữu Server này!");
        }
        return server;
    }

    // 4. Gửi yêu cầu sửa Server
    @Transactional
    public void submitEditRequest(Long serverId, Long userId, ServerEditRequest requestData) {
        // Check quyền sở hữu lại lần nữa cho chắc
        Server server = getServerForEdit(serverId, userId);

        // Check xem có yêu cầu nào đang chờ không
        if (editRequestRepository.existsByServerIdAndStatus(serverId, ServerEditRequest.RequestStatus.PENDING)) {
            throw new RuntimeException("Server này đang có yêu cầu chờ duyệt. Vui lòng đợi Admin xử lý!");
        }

        // Lưu yêu cầu
        requestData.setServer(server);
        requestData.setStatus(ServerEditRequest.RequestStatus.PENDING);
        requestData.setCreatedAt(java.time.LocalDateTime.now());

        editRequestRepository.save(requestData);
    }
}