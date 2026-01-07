package com.muads.controller;

import com.muads.dao.UserDAO;
import com.muads.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.login(username, password);

        if (user == null) {
            request.setAttribute("error", "Sai username hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp")
                    .forward(request, response);
            return;
        }

        // Tạo session
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Điều hướng theo role
        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect("admin/dashboard.jsp");
        } else {
            response.sendRedirect("user/dashboard.jsp");
        }
    }
}
