package com.muads.model;

public class ServerStat {

    private int statsId;
    private int serverId;
    private Integer versionId;
    private Integer resetId;
    private Integer pointId;
    private int expRate;
    private int dropRate;
    private String antiHack;

    public ServerStat() {
    }

    public int getStatsId() {
        return statsId;
    }

    public void setStatsId(int statsId) {
        this.statsId = statsId;
    }

    public int getServerId() {
        return serverId;
    }

    public void setServerId(int serverId) {
        this.serverId = serverId;
    }

    public Integer getVersionId() {
        return versionId;
    }

    public void setVersionId(Integer versionId) {
        this.versionId = versionId;
    }

    public Integer getResetId() {
        return resetId;
    }

    public void setResetId(Integer resetId) {
        this.resetId = resetId;
    }

    public Integer getPointId() {
        return pointId;
    }

    public void setPointId(Integer pointId) {
        this.pointId = pointId;
    }

    public int getExpRate() {
        return expRate;
    }

    public void setExpRate(int expRate) {
        this.expRate = expRate;
    }

    public int getDropRate() {
        return dropRate;
    }

    public void setDropRate(int dropRate) {
        this.dropRate = dropRate;
    }

    public String getAntiHack() {
        return antiHack;
    }

    public void setAntiHack(String antiHack) {
        this.antiHack = antiHack;
    }
}
