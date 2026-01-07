package com.muads.entity;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "servers")
@Data
public class Server {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "server_id")
    private Long id; // Dùng Long cho ID server để mở rộng sau này

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Chủ server

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

    @Enumerated(EnumType.STRING)
    private Status status = Status.PENDING;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    // Liên kết 1-1 với Schedule và Stats để dễ truy xuất
    @OneToOne(mappedBy = "server", cascade = CascadeType.ALL)
    private ServerSchedule schedule;

    @OneToOne(mappedBy = "server", cascade = CascadeType.ALL)
    private ServerStat serverStat;

    public enum Status { PENDING, APPROVED, REJECTED }
}