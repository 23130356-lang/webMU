package com.muads.repository;

import com.muads.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    // Dùng để login
    Optional<User> findByUsername(String username);

    // Kiểm tra trùng tên đăng ký
    boolean existsByUsername(String username);

    // Kiểm tra trùng email
    boolean existsByEmail(String email);
}