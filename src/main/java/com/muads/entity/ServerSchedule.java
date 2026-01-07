package com.muads.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "server_schedules") // Đảm bảo tên bảng đúng
public class ServerSchedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "schedule_id")
    private Integer id;

    @OneToOne
    @JoinColumn(name = "server_id", nullable = false)
    private Server server;

    // --- KIỂM TRA KỸ TÊN CỘT Ở ĐÂY ---
    @Column(name = "alpha_date")
    private LocalDate alphaDate;

    @Column(name = "alpha_time")
    private LocalTime alphaTime;

    @Column(name = "beta_date")
    private LocalDate betaDate;

    @Column(name = "beta_time")
    private LocalTime betaTime;

    // --- GETTER & SETTER THỦ CÔNG (BẮT BUỘC) ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Server getServer() { return server; }
    public void setServer(Server server) { this.server = server; }

    public LocalDate getAlphaDate() { return alphaDate; }
    public void setAlphaDate(LocalDate alphaDate) { this.alphaDate = alphaDate; }

    public LocalTime getAlphaTime() { return alphaTime; }
    public void setAlphaTime(LocalTime alphaTime) { this.alphaTime = alphaTime; }

    public LocalDate getBetaDate() { return betaDate; }
    public void setBetaDate(LocalDate betaDate) { this.betaDate = betaDate; }

    public LocalTime getBetaTime() { return betaTime; }
    public void setBetaTime(LocalTime betaTime) { this.betaTime = betaTime; }
}