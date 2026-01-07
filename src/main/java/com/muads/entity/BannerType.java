package com.muads.entity;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "banner_types")
@Data
public class BannerType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "banner_type_id")
    private Integer id;

    @Column(name = "banner_name")
    private String name;

    private String position; // TOP, MIDDLE, BOTTOM

    @Column(name = "coin_price")
    private Integer coinPrice;

    @Column(name = "duration_day")
    private Integer durationDay;
}