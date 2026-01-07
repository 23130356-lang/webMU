package com.muads.dao;

import com.muads.model.ServerBanner;

import java.sql.*;

public class ServerBannerDAO {

    public void insert(ServerBanner sb) throws Exception {
        String sql = """
            INSERT INTO server_banners(server_id,banner_type_id,start_date,end_date)
            VALUES(?,?,?,?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sb.getServerId());
            ps.setInt(2, sb.getBannerTypeId());
            ps.setDate(3, Date.valueOf(sb.getStartDate()));
            ps.setDate(4, Date.valueOf(sb.getEndDate()));
            ps.executeUpdate();
        }
    }
}
