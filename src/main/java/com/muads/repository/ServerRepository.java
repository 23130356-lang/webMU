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

    // --- CÁC HÀM CƠ BẢN ---
    List<Server> findByIsActiveTrue();
    List<Server> findByStatus(Status status);
    List<Server> findByStatusOrderByCreatedAtDesc(Status status);

    Page<Server> findByStatusAndIsActiveTrue(Status status, Pageable pageable);
    Page<Server> findByStatusInAndIsActiveTrue(List<Status> statuses, Pageable pageable);

    List<Server> findByServerNameContainingIgnoreCaseAndIsActiveTrue(String keyword);
    boolean existsByServerName(String serverName);
    List<Server> findByUserId(Long userId);

    long countByStatus(Status status);
    long countByBannerPackageAndStatusAndIsActiveTrue(BannerPackage bannerPackage, Status status);
    List<Server> findByIsActiveTrueAndExpiredAtBefore(LocalDateTime now);
    List<Server> findByStatusAndExpiredAtBefore(Status status, LocalDateTime now);

    // --- QUERY HIỂN THỊ TRANG CHỦ ---

    @Query("SELECT s FROM Server s WHERE s.isActive = true AND s.status = 'APPROVED' ORDER BY s.createdAt DESC")
    List<Server> findLatestActiveServers(Pageable pageable);

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true AND s.bannerPackage = 'SUPER_VIP' ORDER BY s.approvedAt DESC")
    List<Server> findSuperVipServers();

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true AND s.bannerPackage = 'VIP' ORDER BY s.approvedAt DESC")
    List<Server> findVipServers();

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true AND s.bannerPackage = 'BASIC' ORDER BY s.approvedAt DESC")
    List<Server> findNormalServers();

    // --- QUERY TÌM KIẾM CHÍNH (QUAN TRỌNG) ---
    // Lưu ý: versionIds ở đây là List<Integer> để hỗ trợ tìm kiếm nhiều phiên bản cùng lúc
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
}