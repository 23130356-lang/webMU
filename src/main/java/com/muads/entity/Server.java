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

    // --- CẬP NHẬT 1: Thêm thuộc tính isActive riêng biệt ---
    // Dùng để Soft Delete hoặc Tắt/Bật server nhanh mà không mất trạng thái duyệt
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    // --- CẬP NHẬT 2: Thêm ACTIVE vào Enum Status ---
    @Enumerated(EnumType.STRING)
    private Status status = Status.PENDING;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToOne(mappedBy = "server", cascade = CascadeType.ALL)
    private ServerSchedule schedule;

    @OneToOne(mappedBy = "server", cascade = CascadeType.ALL)
    private ServerStat serverStat;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (isActive == null) isActive = true;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Enum mở rộng thêm trạng thái ACTIVE và INACTIVE
    public enum Status {
        PENDING,   // Chờ duyệt
        APPROVED,  // Đã duyệt (Thay vì ACTIVE)
        REJECTED   // Từ chối
    }
    @Getter
    public enum BannerPackage {
        BASIC(1000, "Cơ bản (1.000 Xu)"),      // Cấp 1
        VIP(5000, "VIP (5.000 Xu)"),           // Cấp 2
        SUPER_VIP(10000, "Super VIP (10.000 Xu)"); // Cấp 3

        private final int price;
        private final String label;

        BannerPackage(int price, String label) {
            this.price = price;
            this.label = label;
        }
    }
    @Enumerated(EnumType.STRING)
    @Column(name = "banner_package")
    private BannerPackage bannerPackage = BannerPackage.BASIC; // Mặc định là cơ bản
}