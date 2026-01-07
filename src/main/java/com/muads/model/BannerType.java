package com.muads.model;

public class BannerType {

    private int bannerTypeId;
    private String bannerName;
    private String position;
    private int coinPrice;
    private int durationDay;

    public BannerType() {
    }

    public int getBannerTypeId() {
        return bannerTypeId;
    }

    public void setBannerTypeId(int bannerTypeId) {
        this.bannerTypeId = bannerTypeId;
    }

    public String getBannerName() {
        return bannerName;
    }

    public void setBannerName(String bannerName) {
        this.bannerName = bannerName;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public int getCoinPrice() {
        return coinPrice;
    }

    public void setCoinPrice(int coinPrice) {
        this.coinPrice = coinPrice;
    }

    public int getDurationDay() {
        return durationDay;
    }

    public void setDurationDay(int durationDay) {
        this.durationDay = durationDay;
    }
}
