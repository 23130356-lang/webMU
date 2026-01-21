package com.muads.entity;
import com.muads.util.SlugUtils;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "reset_types")
@Data
public class ResetType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "reset_id")
    private Integer id;

    @Column(name = "reset_name", nullable = false)
    private String resetName;
    public String getSlug() {
        return SlugUtils.toSlug(this.resetName);
    }
}