package com.muads.entity;
import jakarta.persistence.*;
import lombok.Data; // Nếu bạn dùng Lombok, không thì generate getter/setter

@Entity
@Table(name = "mu_versions")
@Data
public class MuVersion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "version_id")
    private Integer id;

    @Column(name = "version_name", nullable = false)
    private String versionName;
}