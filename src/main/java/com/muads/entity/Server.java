package com.muads.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;

import java.time.LocalDateTime;

@Entity
@Table(name = "servers")
@Data
public class Server {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "server_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "server_name", nullable = false)
    private String serverName;

    @Column(name = "mu_name")
    private String muName;

    @Column(name = "website_url")
    private String websiteUrl;

    @Column(name = "fanpage_url")
    private String fanpageUrl;

    private String slogan;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "banner_image")
    private String bannerImage;

    // --- TRẠNG THÁI ---
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = false;

    @Enumerated(EnumType.STRING)
    private Status status = Status.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "banner_package")
    private BannerPackage bannerPackage = BannerPackage.BASIC;

    // --- THỜI GIAN HỆ THỐNG ---
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // --- QUẢN LÝ THỜI GIAN HIỂN THỊ ---
    @Column(name = "approved_at")
    private LocalDateTime approvedAt; // Thời điểm Admin bấm nút duyệt

    @Column(name = "expired_at")
    private LocalDateTime expiredAt; // Thời điểm server sẽ tự động bị tắt (EXPIRED)
    // -------------------------

    @OneToOne(mappedBy = "server", cascade = CascadeType.ALL)
    private ServerSchedule schedule;

    @OneToOne(mappedBy = "server", cascade = CascadeType.ALL)
    private ServerStat serverStat;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (isActive == null) isActive = false;
        if (status == null) status = Status.PENDING;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // --- 1. ENUM STATUS (Đã thêm EXPIRED) ---
    public enum Status {
        PENDING,  // Chờ duyệt
        APPROVED, // Đang hoạt động
        REJECTED, // Từ chối
        EXPIRED   // Hết hạn
    }

    // --- 2. ENUM BANNER PACKAGE (Đã cập nhật ngày) ---
    @Getter
    public enum BannerPackage {
        BASIC(0, "Cơ bản (Miễn phí)", 7),       // 10 Ngày
        VIP(100, "VIP (100 Xu)", 10),           // 10 Ngày
        SUPER_VIP(200, "Super VIP (2000 Xu)", 14); // 14 Ngày

        private final int price;
        private final String label;
        private final int durationDays;

        BannerPackage(int price, String label, int durationDays) {
            this.price = price;
            this.label = label;
            this.durationDays = durationDays;
        }
    }
}