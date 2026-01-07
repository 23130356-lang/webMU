package com.muads.repository;

import com.muads.entity.Server;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ServerRepository extends JpaRepository<Server, Long> {
    // Tìm tất cả server theo trạng thái (VD: Chỉ lấy server đã duyệt hiển thị lên trang chủ)
    List<Server> findByStatus(Server.Status status);

    // Tìm server của một user cụ thể (Để user quản lý server của họ)
    List<Server> findByUser_Id(Integer userId);

    // Tìm kiếm server theo tên (Cho chức năng search)
    @Query("SELECT s FROM Server s WHERE s.serverName LIKE %?1%")
    List<Server> searchByName(String keyword);
}