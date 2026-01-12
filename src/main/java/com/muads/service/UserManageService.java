package com.muads.service;

import com.muads.entity.*;
import com.muads.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserManageService {

    @Autowired private ServerRepository serverRepository;
    @Autowired private HomeBannerRepository homeBannerRepository;
    @Autowired private ServerEditRequestRepository editRequestRepository;
    @Autowired private UserRepository userRepository; // Cần thêm cái này để trừ tiền User

    // --- CẤU HÌNH GIỚI HẠN SLOT (Số lượng tối đa đang chạy cùng lúc) ---
    private static final int LIMIT_SUPER_VIP = 30;
    private static final int LIMIT_VIP = 8;
    // Basic có thể để thoải mái hoặc giới hạn tùy bạn

    // 1. Lấy danh sách Server của User
    public List<Server> getMyServers(Long userId) {
        return serverRepository.findByUserId(userId);
    }

    // 2. Lấy danh sách Banner của User
    public List<HomeBanner> getMyBanners(Long userId) {
        return homeBannerRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    // 3. Lấy server để edit
    public Server getServerForEdit(Long serverId, Long userId) {
        Server server = serverRepository.findById(serverId)
                .orElseThrow(() -> new RuntimeException("Server không tồn tại"));

        if (!server.getUser().getId().equals(userId)) {
            throw new RuntimeException("Bạn không phải chủ sở hữu Server này!");
        }
        return server;
    }

    // 4. Submit yêu cầu sửa
    @Transactional
    public void submitEditRequest(Long serverId, Long userId, ServerEditRequest requestData) {
        Server server = getServerForEdit(serverId, userId);
        if (editRequestRepository.existsByServerIdAndStatus(serverId, ServerEditRequest.RequestStatus.PENDING)) {
            throw new RuntimeException("Server này đang có yêu cầu chờ duyệt. Vui lòng đợi Admin xử lý!");
        }
        requestData.setServer(server);
        requestData.setStatus(ServerEditRequest.RequestStatus.PENDING);
        requestData.setCreatedAt(LocalDateTime.now());
        editRequestRepository.save(requestData);
    }

    // 5. CHỨC NĂNG GIA HẠN SERVER (MỚI)
    @Transactional
    public void renewServer(Long serverId, Long userId) {
        // A. Lấy thông tin Server và User
        Server server = serverRepository.findById(serverId)
                .orElseThrow(() -> new RuntimeException("Server không tồn tại!"));

        if (!server.getUser().getId().equals(userId)) {
            throw new RuntimeException("Bạn không có quyền gia hạn server này!");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User không tồn tại!"));

        Server.BannerPackage pack = server.getBannerPackage();
        int price = pack.getPrice();
        int daysToAdd = pack.getDurationDays(); // Mặc định 10 ngày theo Enum bạn đã tạo

        // B. Kiểm tra số dư
        if (user.getCoin() < price) {
            throw new RuntimeException("Số dư không đủ! Cần " + price + " xu để gia hạn.");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime currentExpire = server.getExpiredAt();

        // C. Xử lý logic gia hạn
        if (currentExpire != null && currentExpire.isAfter(now)) {
            // === TRƯỜNG HỢP 1: CHƯA HẾT HẠN ===
            // Chỉ cần cộng nối tiếp ngày
            server.setExpiredAt(currentExpire.plusDays(daysToAdd));
        } else {
            // === TRƯỜNG HỢP 2: ĐÃ HẾT HẠN (Hoặc chưa kích hoạt lần đầu) ===
            // Phải kiểm tra SLOT trống
            checkSlotAvailability(pack);

            // Reset lại thời gian như mới
            server.setStatus(Server.Status.APPROVED); // Đảm bảo server được bật lại
            server.setApprovedAt(now);
            server.setExpiredAt(now.plusDays(daysToAdd));
        }

        // D. Trừ tiền và Lưu dữ liệu
        user.setCoin(user.getCoin() - price);
        userRepository.save(user);   // Cập nhật số dư user
        serverRepository.save(server); // Cập nhật thời gian server

        // (Optional) Nên lưu lịch sử giao dịch CoinTransaction ở đây nếu có entity đó
    }

    // Helper: Kiểm tra slot trống
    private void checkSlotAvailability(Server.BannerPackage pack) {
        long currentRunning = serverRepository.countByBannerPackageAndStatusAndIsActiveTrue(pack, Server.Status.APPROVED);

        if (pack == Server.BannerPackage.SUPER_VIP && currentRunning >= LIMIT_SUPER_VIP) {
            throw new RuntimeException("Gói Super VIP đã hết Slot (" + LIMIT_SUPER_VIP + "/" + LIMIT_SUPER_VIP + "). Vui lòng chờ slot trống!");
        }
        if (pack == Server.BannerPackage.VIP && currentRunning >= LIMIT_VIP) {
            throw new RuntimeException("Gói VIP đã hết Slot (" + LIMIT_VIP + "/" + LIMIT_VIP + "). Vui lòng chờ slot trống!");
        }
        // Basic thường không giới hạn hoặc giới hạn cao, tùy bạn thêm logic
    }
}