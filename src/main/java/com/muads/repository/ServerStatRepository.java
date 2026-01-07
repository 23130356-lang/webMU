package com.muads.repository;

import com.muads.entity.ServerStat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServerStatRepository extends JpaRepository<ServerStat, Integer> {
    // Xóa stat theo server id (Khi xóa server thì xóa luôn stat)
    void deleteByServer_Id(Long serverId);
}