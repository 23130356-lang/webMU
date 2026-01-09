package com.muads.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "home_banners")
public class HomeBanner {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "image_url", nullable = false, length = 500)
    private String imageUrl; // Link ảnh

    @Column(name = "target_url", length = 500)
    private String targetUrl; // Link khi click vào

    // Các vị trí: LEFT_SIDEBAR, RIGHT_SIDEBAR, HERO (To giữa), TOP_STD, CENTER_SMALL...
    @Column(name = "position_code", nullable = false)
    private String positionCode;

    @Column(name = "display_order")
    private Integer displayOrder = 0; // Sắp xếp thứ tự ưu tiên

    @Column(name = "is_active")
    private boolean active = true; // Trạng thái ẩn/hiện

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    @ManyToOne
    @JoinColumn(name = "user_id") // Tên cột trong DB sẽ là user_id
    private User user;
    @Column(name = "start_date")
    private LocalDateTime startDate; // Ngày bắt đầu chạy

    @Column(name = "end_date")
    private LocalDateTime endDate;   // Ngày kết thúc (Start + 7 ngày)
    // Constructor, Getters, Setters
    public HomeBanner() {}
    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }
    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }
    // ... (Bạn tự generate Getter/Setter nhé để tiết kiệm dòng hiển thị) ...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getTargetUrl() { return targetUrl; }
    public void setTargetUrl(String targetUrl) { this.targetUrl = targetUrl; }
    public String getPositionCode() { return positionCode; }
    public void setPositionCode(String positionCode) { this.positionCode = positionCode; }
    public Integer getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(Integer displayOrder) { this.displayOrder = displayOrder; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    // ... các getter/setter cũ ...

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}