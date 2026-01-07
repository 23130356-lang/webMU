package com.muads.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class ServerSchedule {

    private int scheduleId;
    private int serverId;
    private LocalTime alphaTime;
    private LocalDate alphaDate;
    private LocalTime betaTime;
    private LocalDate betaDate;

    public ServerSchedule() {
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getServerId() {
        return serverId;
    }

    public void setServerId(int serverId) {
        this.serverId = serverId;
    }

    public LocalTime getAlphaTime() {
        return alphaTime;
    }

    public void setAlphaTime(LocalTime alphaTime) {
        this.alphaTime = alphaTime;
    }

    public LocalDate getAlphaDate() {
        return alphaDate;
    }

    public void setAlphaDate(LocalDate alphaDate) {
        this.alphaDate = alphaDate;
    }

    public LocalTime getBetaTime() {
        return betaTime;
    }

    public void setBetaTime(LocalTime betaTime) {
        this.betaTime = betaTime;
    }

    public LocalDate getBetaDate() {
        return betaDate;
    }

    public void setBetaDate(LocalDate betaDate) {
        this.betaDate = betaDate;
    }
}
