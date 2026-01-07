package com.muads.dao;

import com.muads.model.ServerStat;

import java.sql.*;

public class ServerStatDAO {

    public void insert(ServerStat st) throws Exception {
        String sql = """
            INSERT INTO server_stats(server_id,version_id,reset_id,point_id,exp_rate,drop_rate,anti_hack)
            VALUES(?,?,?,?,?,?,?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, st.getServerId());
            ps.setObject(2, st.getVersionId());
            ps.setObject(3, st.getResetId());
            ps.setObject(4, st.getPointId());
            ps.setInt(5, st.getExpRate());
            ps.setInt(6, st.getDropRate());
            ps.setString(7, st.getAntiHack());
            ps.executeUpdate();
        }
    }
}
