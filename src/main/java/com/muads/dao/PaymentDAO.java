package com.muads.dao;

import com.muads.model.Payment;

import java.sql.*;

public class PaymentDAO {

    public void insert(Payment p) throws Exception {
        String sql = """
            INSERT INTO payments(user_id,amount_money,coin_received,method,status)
            VALUES(?,?,?,?,?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, p.getUserId());
            ps.setInt(2, p.getAmountMoney());
            ps.setInt(3, p.getCoinReceived());
            ps.setString(4, p.getMethod());
            ps.setString(5, p.getStatus());
            ps.executeUpdate();
        }
    }
}
