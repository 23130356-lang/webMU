package com.muads.repository;

import com.muads.entity.Server;
import com.muads.entity.Server.Status;
import com.muads.entity.Server.BannerPackage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ServerRepository extends JpaRepository<Server, Long> {

    // 1. Các hàm tìm kiếm cơ bản
    List<Server> findByIsActiveTrue();

    // [QUAN TRỌNG] Hàm bạn đang bị thiếu báo lỗi đây:
    List<Server> findByStatus(Status status);

    // [QUAN TRỌNG] Hàm sắp xếp theo thời gian (dùng cho Service):
    List<Server> findByStatusOrderByCreatedAtDesc(Status status);

    // 2. Các hàm phân trang (Paging)
    Page<Server> findByStatusAndIsActiveTrue(Status status, Pageable pageable);

    Page<Server> findByStatusInAndIsActiveTrue(List<Status> statuses, Pageable pageable);

    // 3. Tìm kiếm theo tên
    List<Server> findByServerNameContainingIgnoreCaseAndIsActiveTrue(String keyword);
    boolean existsByServerName(String serverName);

    // 4. Tìm theo User
    List<Server> findByUserId(Long userId);

    // 5. Đếm số lượng
    long countByStatus(Status status);

    // 6. Logic đếm Slot cho chức năng Đăng ký/Gia hạn
    long countByBannerPackageAndStatusAndIsActiveTrue(BannerPackage bannerPackage, Status status);

    // 7. Tìm server hết hạn (để CronJob quét tắt server)
    List<Server> findByIsActiveTrueAndExpiredAtBefore(LocalDateTime now);

    // 8. Các Query Custom hiển thị ra trang chủ (Home)
    @Query("SELECT s FROM Server s WHERE s.isActive = true AND s.status = 'APPROVED' ORDER BY s.createdAt DESC")
    List<Server> findLatestActiveServers(Pageable pageable);

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true AND s.bannerPackage = 'SUPER_VIP' ORDER BY s.approvedAt DESC")
    List<Server> findSuperVipServers();

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true AND s.bannerPackage = 'VIP' ORDER BY s.approvedAt DESC")
    List<Server> findVipServers();

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true AND s.bannerPackage = 'BASIC' ORDER BY s.approvedAt DESC")
    List<Server> findNormalServers();
}