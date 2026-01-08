package com.muads.entity;

import jakarta.persistence.*;
import lombok.Data; // Nếu không dùng Lombok thì tự tạo Getter/Setter
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

@Entity
@Table(name = "users") // Đặt tên bảng là 'users' (số nhiều) để tránh từ khóa SQL
@Data // Lombok: Tự sinh Getter, Setter, toString...
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id; // Nên dùng Long cho ID chính

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false, unique = true)
    private String phone;

    @Column(name = "full_name")
    private String fullName;

    @Column(name = "coin", columnDefinition = "INT DEFAULT 0")
    private Integer coin = 0;
    // --- CẤU HÌNH ENUM ROLE CHUẨN ---
    public enum Role {
        ADMIN,  // Dành cho admin
        USER    // <--- BẠN ĐANG THIẾU CÁI NÀY hoặc đang viết sai chính tả
    }

    @Enumerated(EnumType.STRING) // Lưu vào DB là chữ "ADMIN" thay vì số 0
    @Column(name = "role", nullable = false)
    private Role role = Role.USER; // Mặc định tạo user mới là Member

    // --- QUAN HỆ VỚI SERVER (1 User có nhiều Server) ---
    // mappedBy = "user": Tên biến 'user' bên class Server
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Server> servers;
}