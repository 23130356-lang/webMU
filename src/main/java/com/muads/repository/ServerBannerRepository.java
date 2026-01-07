package com.muads.repository;

import com.muads.entity.ServerBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ServerBannerRepository extends JpaRepository<ServerBanner, Integer> {
    // Lấy banner đang còn hạn sử dụng để hiển thị
    // "Lấy các banner có ngày kết thúc lớn hơn hoặc bằng hôm nay"
    List<ServerBanner> findByEndDateGreaterThanEqual(LocalDate today);
}