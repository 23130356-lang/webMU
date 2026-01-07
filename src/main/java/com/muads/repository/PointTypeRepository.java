package com.muads.repository;

import com.muads.entity.PointType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PointTypeRepository extends JpaRepository<PointType, Integer> {
}