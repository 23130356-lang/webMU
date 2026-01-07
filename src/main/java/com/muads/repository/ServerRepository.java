package com.muads.repository;

import com.muads.entity.Server;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServerRepository extends JpaRepository<Server, Long> {
    // Spring Boot tự động làm hết, không cần viết code trong này
}