package com.muads.repository;

import com.muads.entity.Server;
import com.muads.entity.Server.Status;
import com.muads.entity.Server.BannerPackage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ServerRepository extends JpaRepository<Server, Long> {

    // ==========================================
    // PHẦN 1: CÁC HÀM CŨ (GIỮ NGUYÊN)
    // ==========================================

    // 1. Các hàm tìm kiếm cơ bản
    List<Server> findByIsActiveTrue();

    // Tìm theo Status
    List<Server> findByStatus(Status status);

    // Sắp xếp theo thời gian (dùng cho Service admin/dashboard)
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

    // 7. Tìm server hết hạn (Hàm cũ của bạn - có thể giữ lại hoặc dùng hàm mới bên dưới)
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

    @Query("SELECT s FROM Server s " +
            "JOIN s.serverStat ss " +
            "WHERE s.isActive = true " +
            "AND s.status = 'APPROVED' " +
            "AND (:resetId IS NULL OR ss.resetType.id = :resetId) " +
            "AND (:versionIds IS NULL OR ss.muVersion.id IN :versionIds) " +
            "ORDER BY " +
            "CASE WHEN s.bannerPackage = 'SUPER_VIP' THEN 1 " +
            "WHEN s.bannerPackage = 'VIP' THEN 2 " +
            "ELSE 3 END ASC, " +
            "s.approvedAt DESC")
    List<Server> searchServers(@Param("resetId") Integer resetId,
                               @Param("versionIds") List<Integer> versionIds);



    List<Server> findByStatusAndExpiredAtBefore(Status status, LocalDateTime now);
}