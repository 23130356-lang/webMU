package com.muads.dto;

import org.springframework.web.multipart.MultipartFile;

public class AdminBannerDto {
    private String positionCode;   // Vị trí (HERO, STD...)
    private int durationDays;      // Thời hạn (ngày)
    private int displayOrder;      // Thứ tự ưu tiên
    private String uploadType;     // "file" hoặc "url"

    private MultipartFile imageFile; // File ảnh upload từ máy
    private String imageUrl;         // Link ảnh (nếu chọn URL)
    private String targetUrl;        // Link đích khi click vào banner

    // === Getters & Setters ===
    public String getPositionCode() { return positionCode; }
    public void setPositionCode(String positionCode) { this.positionCode = positionCode; }

    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public String getUploadType() { return uploadType; }
    public void setUploadType(String uploadType) { this.uploadType = uploadType; }

    public MultipartFile getImageFile() { return imageFile; }
    public void setImageFile(MultipartFile imageFile) { this.imageFile = imageFile; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getTargetUrl() { return targetUrl; }
    public void setTargetUrl(String targetUrl) { this.targetUrl = targetUrl; }
}