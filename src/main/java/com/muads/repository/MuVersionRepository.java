package com.muads.repository;

import com.muads.entity.MuVersion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MuVersionRepository extends JpaRepository<MuVersion, Integer> {
}