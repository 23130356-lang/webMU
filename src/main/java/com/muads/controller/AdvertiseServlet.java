package com.muads.controller;

import com.muads.dao.*;
import com.muads.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/advertise")
public class AdvertiseServlet extends HttpServlet {

    private final ServerDAO serverDAO = new ServerDAO();
    private final ServerScheduleDAO scheduleDAO = new ServerScheduleDAO();
    private final ServerStatDAO statDAO = new ServerStatDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));

            // 1. Insert server
            Server server = new Server();
            server.setUserId(userId);
            server.setServerName(request.getParameter("serverName"));
            server.setMuName(request.getParameter("muName"));
            server.setWebsiteUrl(request.getParameter("websiteUrl"));
            server.setFanpageUrl(request.getParameter("fanpageUrl"));
            server.setSlogan(request.getParameter("slogan"));
            server.setDescription(request.getParameter("description"));
            server.setStatus("PENDING");

            int serverId = serverDAO.insert(server);

            // 2. Insert schedule
            ServerSchedule sc = new ServerSchedule();
            sc.setServerId(serverId);
            sc.setAlphaDate(LocalDate.parse(request.getParameter("alphaDate")));
            sc.setAlphaTime(LocalTime.parse(request.getParameter("alphaTime")));
            sc.setBetaDate(LocalDate.parse(request.getParameter("betaDate")));
            sc.setBetaTime(LocalTime.parse(request.getParameter("betaTime")));
            scheduleDAO.insert(sc);

            // 3. Insert stats
            ServerStat stat = new ServerStat();
            stat.setServerId(serverId);
            stat.setExpRate(Integer.parseInt(request.getParameter("expRate")));
            stat.setDropRate(Integer.parseInt(request.getParameter("dropRate")));
            stat.setAntiHack(request.getParameter("antiHack"));
            statDAO.insert(stat);

            response.sendRedirect("user/dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/advertise.jsp");
        }
    }
}
