package com.muads.dao;

import com.muads.model.Server;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServerDAO {

    public int insert(Server s) throws Exception {
        String sql = """
            INSERT INTO servers(user_id,server_name,mu_name,website_url,fanpage_url,
                                slogan,description,banner_image,status)
            VALUES(?,?,?,?,?,?,?,?,?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, s.getUserId());
            ps.setString(2, s.getServerName());
            ps.setString(3, s.getMuName());
            ps.setString(4, s.getWebsiteUrl());
            ps.setString(5, s.getFanpageUrl());
            ps.setString(6, s.getSlogan());
            ps.setString(7, s.getDescription());
            ps.setString(8, s.getBannerImage());
            ps.setString(9, s.getStatus());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public List<Server> findApproved() throws Exception {
        List<Server> list = new ArrayList<>();
        String sql = "SELECT * FROM servers WHERE status='APPROVED'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public void updateStatus(int serverId, String status) throws Exception {
        String sql = "UPDATE servers SET status=? WHERE server_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, serverId);
            ps.executeUpdate();
        }
    }

    private Server map(ResultSet rs) throws Exception {
        Server s = new Server();
        s.setServerId(rs.getInt("server_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setServerName(rs.getString("server_name"));
        s.setMuName(rs.getString("mu_name"));
        s.setWebsiteUrl(rs.getString("website_url"));
        s.setFanpageUrl(rs.getString("fanpage_url"));
        s.setSlogan(rs.getString("slogan"));
        s.setDescription(rs.getString("description"));
        s.setBannerImage(rs.getString("banner_image"));
        s.setStatus(rs.getString("status"));
        s.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return s;
    }
}
