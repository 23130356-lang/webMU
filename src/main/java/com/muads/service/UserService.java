package com.muads.service;

import com.muads.dto.UserLoginDTO;
import com.muads.dto.UserRegisterDTO;
import com.muads.entity.User;
import com.muads.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    /**
     * Xử lý Đăng ký tài khoản mới
     */
    @Transactional
    public User registerUser(UserRegisterDTO dto) {
        // 1. Kiểm tra trùng lặp
        if (userRepository.existsByUsername(dto.getUsername())) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại!");
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email đã được sử dụng!");
        }

        // 2. Map từ DTO sang Entity
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword()); // Lưu ý: Nên mã hóa password ở đây nếu có Spring Security
        user.setEmail(dto.getEmail());
        user.setBalance(0.0); // Số dư mặc định bằng 0

        // QUAN TRỌNG: Gán Role mặc định là MEMBER
        // (Dùng Enum chuẩn User.Role.MEMBER thay vì string)
        user.setRole(User.Role.USER);

        // 3. Lưu xuống DB
        return userRepository.save(user);
    }

    /**
     * Xử lý Đăng nhập
     */
    public User login(UserLoginDTO dto) {
        // 1. Tìm user theo username
        User user = userRepository.findByUsername(dto.getUsername());

        // 2. Kiểm tra password
        // (Nếu sau này dùng BCryptPasswordEncoder thì dùng passwordEncoder.matches())
        if (user == null || !user.getPassword().equals(dto.getPassword())) {
            throw new RuntimeException("Sai tên đăng nhập hoặc mật khẩu!");
        }

        // 3. Trả về user nếu đúng
        return user;
    }
}