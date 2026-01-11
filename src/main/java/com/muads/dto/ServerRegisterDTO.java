package com.muads.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile; // Import quan trọng để nhận file

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ServerRegisterDTO {
    private String serverName;
    private String muName;
    private String slogan;
    private String websiteUrl;
    private String fanpageUrl;
    private String description;
    private String bannerPackage;

    // --- XỬ LÝ ẢNH (MỚI) ---
    private String bannerUrl;       // Link ảnh online
    private MultipartFile bannerFile; // File upload từ máy
    // -----------------------

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate alphaDate;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime alphaTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate betaDate;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime betaTime;

    private Integer versionId;
    private Integer resetId;
    private Integer pointId;
    private Integer expRate;
    private Integer dropRate;
    private String antiHack;
}