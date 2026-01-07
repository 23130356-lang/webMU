package com.muads.dao;

import com.muads.model.BannerType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BannerTypeDAO {

    public List<BannerType> findAll() throws Exception {
        List<BannerType> list = new ArrayList<>();
        String sql = "SELECT * FROM banner_types";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BannerType b = new BannerType();
                b.setBannerTypeId(rs.getInt("banner_type_id"));
                b.setBannerName(rs.getString("banner_name"));
                b.setPosition(rs.getString("position"));
                b.setCoinPrice(rs.getInt("coin_price"));
                b.setDurationDay(rs.getInt("duration_day"));
                list.add(b);
            }
        }
        return list;
    }
}
