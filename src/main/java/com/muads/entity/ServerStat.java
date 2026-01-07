package com.muads.entity;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "server_stats")
@Data
public class ServerStat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stats_id")
    private Integer id;

    @OneToOne
    @JoinColumn(name = "server_id", nullable = false)
    private Server server;

    @ManyToOne
    @JoinColumn(name = "version_id")
    private MuVersion muVersion;

    @ManyToOne
    @JoinColumn(name = "reset_id")
    private ResetType resetType;

    @ManyToOne
    @JoinColumn(name = "point_id")
    private PointType pointType;

    @Column(name = "exp_rate")
    private Integer expRate;

    @Column(name = "drop_rate")
    private Integer dropRate;

    @Column(name = "anti_hack")
    private String antiHack;
}