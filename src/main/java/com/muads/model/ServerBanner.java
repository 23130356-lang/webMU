package com.muads.model;

import java.time.LocalDate;

public class ServerBanner {

    private int id;
    private int serverId;
    private int bannerTypeId;
    private LocalDate startDate;
    private LocalDate endDate;

    public ServerBanner() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getServerId() {
        return serverId;
    }

    public void setServerId(int serverId) {
        this.serverId = serverId;
    }

    public int getBannerTypeId() {
        return bannerTypeId;
    }

    public void setBannerTypeId(int bannerTypeId) {
        this.bannerTypeId = bannerTypeId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
}
