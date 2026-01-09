package com.muads.repository;

import com.muads.entity.HomeBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HomeBannerRepository extends JpaRepository<HomeBanner, Long> {

    // Lấy banner theo vị trí và đang Active, sắp xếp theo thứ tự
    List<HomeBanner> findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc(String positionCode);

    // Lấy tất cả banner đang active (Dùng để cache hoặc load 1 lần)
    List<HomeBanner> findByActiveTrue();
}