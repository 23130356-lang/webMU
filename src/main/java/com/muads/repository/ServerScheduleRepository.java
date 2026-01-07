package com.muads.repository;

import com.muads.entity.ServerSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServerScheduleRepository extends JpaRepository<ServerSchedule, Integer> {
    void deleteByServer_Id(Long serverId);
}