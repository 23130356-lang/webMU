package com.muads.entity;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "server_schedules")
@Data
public class ServerSchedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "schedule_id")
    private Integer id;

    @OneToOne
    @JoinColumn(name = "server_id", nullable = false)
    private Server server;

    @Column(name = "alpha_time")
    private LocalTime alphaTime;

    @Column(name = "alpha_date")
    private LocalDate alphaDate;

    @Column(name = "beta_time")
    private LocalTime betaTime;

    @Column(name = "beta_date")
    private LocalDate betaDate;
}