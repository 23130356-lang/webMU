package com.muads.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ServerRegisterDTO {
    // --- 1. Thông tin cơ bản (Bảng Server) ---
    private String serverName;
    private String muName;
    private String slogan;
    private String websiteUrl;
    private String fanpageUrl;
    private String description;

    // --- 2. Lịch trình (Bảng ServerSchedule) ---
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate alphaDate;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime alphaTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate betaDate;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime betaTime;

    // --- 3. Cấu hình (Bảng ServerStat) ---
    private Integer versionId;  // Lấy ID từ dropdown
    private Integer resetId;    // Lấy ID từ dropdown
    private Integer pointId;    // Lấy ID từ dropdown
    private Integer expRate;
    private Integer dropRate;
    private String antiHack;
}