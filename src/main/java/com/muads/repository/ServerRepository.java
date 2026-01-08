package com.muads.repository;

import com.muads.entity.Server;
import com.muads.entity.Server.Status;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ServerRepository extends JpaRepository<Server, Long> {

    // 1. CƠ BẢN: Tìm tất cả server đang bật (isActive = true)
    // Dùng cho: Các danh sách chung, dropdown menu
    List<Server> findByIsActiveTrue();

    // 2. TRANG CHỦ: Lấy danh sách server Active + Đã duyệt (APPROVED hoặc ACTIVE)
    // Có hỗ trợ phân trang (Pageable) để load nhanh hơn
    Page<Server> findByStatusAndIsActiveTrue(Status status, Pageable pageable);

    // Hoặc nếu bạn muốn lấy nhiều trạng thái (VD: lấy cả APPROVED và ACTIVE)
    Page<Server> findByStatusInAndIsActiveTrue(List<Status> statuses, Pageable pageable);

    // 3. TÌM KIẾM: Tìm theo tên server (không phân biệt hoa thường) VÀ đang bật
    // Dùng cho: Thanh tìm kiếm trên trang chủ
    List<Server> findByServerNameContainingIgnoreCaseAndIsActiveTrue(String keyword);

    // 4. NGƯỜI DÙNG: Lấy danh sách server của một User cụ thể (Trang quản lý cá nhân)
    // Ở đây không cần check isActive vì chủ server cần thấy cả server đang tắt
    List<Server> findByUserId(Long userId);

    // 5. ADMIN: Đếm số lượng server đang chờ duyệt (PENDING)
    long countByStatus(Status status);

    // 6. CUSTOM QUERY (Nâng cao):
    // Ví dụ: Tìm server mới nhất đang hoạt động để ghim lên đầu trang
    @Query("SELECT s FROM Server s WHERE s.isActive = true AND s.status = 'ACTIVE' ORDER BY s.createdAt DESC")
    List<Server> findLatestActiveServers(Pageable pageable);

    // 7. KIỂM TRA: Check xem tên server đã tồn tại chưa (tránh trùng lặp khi tạo mới)
    boolean existsByServerName(String serverName);
    List<Server> findByStatus(Status status);
    List<Server> findByStatusOrderByCreatedAtDesc(Status status);
    List<Server> findByIsActiveTrueAndExpiredAtBefore(LocalDateTime now);
    // 1. Lấy danh sách Server VIP (Gói VIP hoặc SUPER_VIP), Đã duyệt, Đang active
// 1. Lấy SUPER VIP (Cao cấp nhất)
    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true " +
            "AND s.bannerPackage = 'SUPER_VIP' " +
            "ORDER BY s.approvedAt DESC")
    List<Server> findSuperVipServers();

    // 2. Lấy VIP (Cấp trung)
    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true " +
            "AND s.bannerPackage = 'VIP' " +
            "ORDER BY s.approvedAt DESC")
    List<Server> findVipServers();

    // 3. Lấy THƯỜNG (Cơ bản)
    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true " +
            "AND s.bannerPackage = 'BASIC' " +
            "ORDER BY s.approvedAt DESC")
    List<Server> findNormalServers();
}