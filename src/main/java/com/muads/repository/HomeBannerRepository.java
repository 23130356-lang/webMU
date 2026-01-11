package com.muads.repository;

import com.muads.entity.HomeBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface HomeBannerRepository extends JpaRepository<HomeBanner, Long> {

    // 1. Lấy banner theo vị trí và đang Active (để hiển thị ngoài trang chủ)
    List<HomeBanner> findByPositionCodeAndActiveTrueOrderByDisplayOrderAsc(String positionCode);

    // 2. Lấy tất cả banner đang active (Dùng cho cache nếu cần)
    List<HomeBanner> findByActiveTrue();

    // 3. Đếm số lượng banner đang chạy theo vị trí (để check Full slot)
    long countByPositionCodeAndActiveTrue(String positionCode);

    // --- MỚI THÊM: Lấy danh sách theo trạng thái (Dùng cho Admin) ---
    // active = false -> Danh sách chờ
    // active = true  -> Danh sách đang chạy
    List<HomeBanner> findByActive(boolean active);
    List<HomeBanner> findByUserIdOrderByCreatedAtDesc(Long userId);
    // Đếm số lượng
    // Hiển thị ra trang chủ (theo thứ tự hiển thị)
    // [MỚI] Tìm các banner đang chạy, sắp xếp theo ngày kết thúc TĂNG DẦN (thằng nào hết hạn trước lên đầu)
    List<HomeBanner> findByPositionCodeAndActiveTrueOrderByEndDateAsc(String positionCode);
    List<HomeBanner> findByActiveTrueAndEndDateBefore(LocalDateTime now);
}