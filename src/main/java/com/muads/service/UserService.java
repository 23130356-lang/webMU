package com.muads.service;

import com.muads.dto.UserLoginDTO;
import com.muads.dto.UserRegisterDTO;
import com.muads.entity.User;
import com.muads.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public void registerUser(UserRegisterDTO dto) {
        // 1. Kiểm tra username đã tồn tại chưa
        if (userRepository.existsByUsername(dto.getUsername())) {
            throw new RuntimeException("Tên tài khoản đã tồn tại!");
        }

        // 2. Kiểm tra email đã tồn tại chưa
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email này đã được sử dụng!");
        }

        // 3. Kiểm tra mật khẩu nhập lại có khớp không
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new RuntimeException("Mật khẩu nhập lại không khớp!");
        }

        // 4. Tạo User Entity để lưu
        User user = new User();
        user.setUsername(dto.getUsername());

        // Lưu ý: Trong thực tế bạn nên mã hóa mật khẩu ở đây (VD: BCrypt)
        // Hiện tại ta lưu text thường để test trước.
        user.setPassword(dto.getPassword());

        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        user.setCoin(0); // Mặc định 0 xu
        user.setRole(User.Role.USER); // Mặc định là member thường
        user.setStatus(1); // Mặc định hoạt động

        userRepository.save(user);
    }

    public User login(UserLoginDTO dto) {
        // 1. Tìm user theo username
        User user = userRepository.findByUsername(dto.getUsername())
                .orElseThrow(() -> new RuntimeException("Tài khoản không tồn tại!"));

        // 2. So sánh mật khẩu (Đang dùng text thường, sau này nâng cấp BCrypt sau)
        if (!user.getPassword().equals(dto.getPassword())) {
            throw new RuntimeException("Mật khẩu không chính xác!");
        }

        // 3. Kiểm tra xem tài khoản có bị khóa không
        if (user.getStatus() != 1) {
            throw new RuntimeException("Tài khoản này đã bị khóa!");
        }

        return user; // Trả về user nếu mọi thứ OK
    }
}