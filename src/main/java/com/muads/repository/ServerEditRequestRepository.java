package com.muads.repository;

import com.muads.entity.ServerEditRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServerEditRequestRepository extends JpaRepository<ServerEditRequest, Long> {
    // Kiểm tra xem server này có yêu cầu nào đang chờ duyệt không (để chặn spam)
    boolean existsByServerIdAndStatus(Long serverId, ServerEditRequest.RequestStatus status);
}