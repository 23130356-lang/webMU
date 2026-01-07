package com.muads.entity;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "point_types")
@Data
public class PointType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "point_id")
    private Integer id;

    @Column(name = "point_name", nullable = false)
    private String pointName;
}