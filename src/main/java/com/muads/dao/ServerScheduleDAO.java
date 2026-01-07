package com.muads.dao;

import com.muads.model.ServerSchedule;

import java.sql.*;

public class ServerScheduleDAO {

    public void insert(ServerSchedule sc) throws Exception {
        String sql = """
            INSERT INTO server_schedules(server_id,alpha_time,alpha_date,beta_time,beta_date)
            VALUES(?,?,?,?,?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sc.getServerId());
            ps.setTime(2, Time.valueOf(sc.getAlphaTime()));
            ps.setDate(3, Date.valueOf(sc.getAlphaDate()));
            ps.setTime(4, Time.valueOf(sc.getBetaTime()));
            ps.setDate(5, Date.valueOf(sc.getBetaDate()));
            ps.executeUpdate();
        }
    }
}
