package com.muads.controller;

import com.muads.dao.UserDAO;
import com.muads.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        try {
            // Check username tồn tại
            if (userDAO.findByUsername(username) != null) {
                request.setAttribute("error", "Username đã tồn tại!");
                request.getRequestDispatcher("register.jsp")
                        .forward(request, response);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password); // sau này hash BCrypt
            user.setPhone(phone);
            user.setEmail(email);
            user.setCoin(0);
            user.setRole("USER");
            user.setStatus(1);

            userDAO.insert(user);

            // Đăng ký xong → chuyển sang login
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống!");
            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);
        }
    }
}
