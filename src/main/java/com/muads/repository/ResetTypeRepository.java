package com.muads.repository;

import com.muads.entity.ResetType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ResetTypeRepository extends JpaRepository<ResetType, Integer> {
}