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

    List<Server> findByIsActiveTrue();

    Page<Server> findByStatusAndIsActiveTrue(Status status, Pageable pageable);

    Page<Server> findByStatusInAndIsActiveTrue(List<Status> statuses, Pageable pageable);

    List<Server> findByServerNameContainingIgnoreCaseAndIsActiveTrue(String keyword);

    List<Server> findByUserId(Long userId);

    long countByStatus(Status status);

    @Query("SELECT s FROM Server s WHERE s.isActive = true AND s.status = 'ACTIVE' ORDER BY s.createdAt DESC")
    List<Server> findLatestActiveServers(Pageable pageable);

    boolean existsByServerName(String serverName);

    List<Server> findByStatus(Status status);

    List<Server> findByStatusOrderByCreatedAtDesc(Status status);

    // --- [MỚI] TÌM SERVER HẾT HẠN ---
    List<Server> findByIsActiveTrueAndExpiredAtBefore(LocalDateTime now);

    // --- [MỚI] ĐẾM SLOT ĐANG CHẠY ---
    long countByBannerPackageAndStatusAndIsActiveTrue(BannerPackage bannerPackage, Status status);

    // --- QUERY HIỂN THỊ ---
    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true " +
            "AND s.bannerPackage = 'SUPER_VIP' " +
            "ORDER BY s.approvedAt DESC")
    List<Server> findSuperVipServers();

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true " +
            "AND s.bannerPackage = 'VIP' " +
            "ORDER BY s.approvedAt DESC")
    List<Server> findVipServers();

    @Query("SELECT s FROM Server s WHERE s.status = 'APPROVED' AND s.isActive = true " +
            "AND s.bannerPackage = 'BASIC' " +
            "ORDER BY s.approvedAt DESC")
    List<Server> findNormalServers();
}