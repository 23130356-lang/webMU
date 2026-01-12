package com.muads.service;

import com.muads.dto.UserLoginDTO;
import com.muads.dto.UserProfileDTO;
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
        user.setCoin(0); // Mặc định 0 coin
        user.setRole(User.Role.USER);
        user.setPhone(dto.getPhone());

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
        if (user == null || !user.getPassword().equals(dto.getPassword())) {
            throw new RuntimeException("Sai tên đăng nhập hoặc mật khẩu!");
        }

        // 3. Trả về user nếu đúng
        return user;
    }

    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    // --- [MỚI BỔ SUNG] Hàm tìm User theo ID (Dùng cho Controller để refresh session) ---
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));
    }
    // -----------------------------------------------------------------------------------

    public UserProfileDTO getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng!"));

        // Map Entity sang DTO
        return new UserProfileDTO(
                user.getUsername(),
                user.getEmail(),
                user.getPhone(),
                user.getFullName(),
                user.getCoin()
        );
    }

    public void updateUserProfile(Long userId, UserProfileDTO dto) {
        // 1. Tìm user hiện tại trong DB
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại!"));

        // 2. Kiểm tra logic thay đổi Email
        // Nếu email mới KHÁC email cũ VÀ email mới đã có người dùng khác sử dụng -> Báo lỗi
        if (!user.getEmail().equals(dto.getEmail()) && userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email này đã được sử dụng bởi tài khoản khác!");
        }

        // 3. Cập nhật thông tin
//        user.setFullName(dto.getFullName());
        user.setEmail(dto.getEmail());
        // user.setPhone(dto.getPhone()); // Nếu muốn cho sửa cả SĐT thì mở dòng này ra

        // 4. Lưu xuống DB
        userRepository.save(user);
    }
}