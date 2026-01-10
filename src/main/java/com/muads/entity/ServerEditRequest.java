package com.muads.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "server_edit_requests")
@Data
public class ServerEditRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Link tới Server gốc
    @ManyToOne
    @JoinColumn(name = "server_id", nullable = false)
    private Server server;

    // Các trường user muốn sửa (Phải khớp với Server.java)
    @Column(name = "new_server_name")
    private String newServerName;

    @Column(name = "new_description", columnDefinition = "TEXT")
    private String newDescription;

    @Column(name = "new_website_url")
    private String newWebsiteUrl;

    @Column(name = "new_fanpage_url")
    private String newFanpageUrl;

    @Column(name = "new_banner_image")
    private String newBannerImage;

    // Trạng thái yêu cầu
    @Enumerated(EnumType.STRING)
    private RequestStatus status = RequestStatus.PENDING;

    private LocalDateTime createdAt = LocalDateTime.now();

    public enum RequestStatus {
        PENDING,  // Đang chờ Admin xem
        APPROVED, // Admin đã duyệt (Data đã update vào Server gốc)
        REJECTED  // Admin từ chối (Kèm lý do nếu cần)
    }
}