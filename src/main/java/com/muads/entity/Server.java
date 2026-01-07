package com.muads.entity;

import jakarta.persistence.*;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "servers")
public class Server {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // --- Thông tin cơ bản ---
    @Column(name = "server_name", nullable = false)
    private String serverName;

    @Column(name = "mu_name")
    private String muName;

    private String slogan;

    @Column(name = "website_url")
    private String websiteUrl;

    @Column(name = "fanpage_url")
    private String fanpageUrl;

    // --- Lịch Open (Map với input type="date" và "time" ở JSP) ---
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate alphaDate;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime alphaTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate betaDate; // Open Beta

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime betaTime;

    // --- Cấu hình ---
    // Lưu ID của version/reset type (đơn giản hóa cho lúc đầu)
    private Integer versionId;
    private Integer resetId;
    private Integer pointId;

    private Integer expRate;
    private Integer dropRate;
    private String antiHack;

    @Column(columnDefinition = "TEXT")
    private String description;

    // --- Getter & Setter (Bắt buộc phải có) ---
    // Bạn có thể dùng Lombok @Data nếu biết, còn không hãy Generate Getter/Setter đầy đủ
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getServerName() { return serverName; }
    public void setServerName(String serverName) { this.serverName = serverName; }
    public String getMuName() { return muName; }
    public void setMuName(String muName) { this.muName = muName; }
    public String getSlogan() { return slogan; }
    public void setSlogan(String slogan) { this.slogan = slogan; }
    public String getWebsiteUrl() { return websiteUrl; }
    public void setWebsiteUrl(String websiteUrl) { this.websiteUrl = websiteUrl; }
    public String getFanpageUrl() { return fanpageUrl; }
    public void setFanpageUrl(String fanpageUrl) { this.fanpageUrl = fanpageUrl; }
    public LocalDate getAlphaDate() { return alphaDate; }
    public void setAlphaDate(LocalDate alphaDate) { this.alphaDate = alphaDate; }
    public LocalTime getAlphaTime() { return alphaTime; }
    public void setAlphaTime(LocalTime alphaTime) { this.alphaTime = alphaTime; }
    public LocalDate getBetaDate() { return betaDate; }
    public void setBetaDate(LocalDate betaDate) { this.betaDate = betaDate; }
    public LocalTime getBetaTime() { return betaTime; }
    public void setBetaTime(LocalTime betaTime) { this.betaTime = betaTime; }
    public Integer getVersionId() { return versionId; }
    public void setVersionId(Integer versionId) { this.versionId = versionId; }
    public Integer getResetId() { return resetId; }
    public void setResetId(Integer resetId) { this.resetId = resetId; }
    public Integer getPointId() { return pointId; }
    public void setPointId(Integer pointId) { this.pointId = pointId; }
    public Integer getExpRate() { return expRate; }
    public void setExpRate(Integer expRate) { this.expRate = expRate; }
    public Integer getDropRate() { return dropRate; }
    public void setDropRate(Integer dropRate) { this.dropRate = dropRate; }
    public String getAntiHack() { return antiHack; }
    public void setAntiHack(String antiHack) { this.antiHack = antiHack; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}