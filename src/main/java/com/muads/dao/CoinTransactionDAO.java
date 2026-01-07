package com.muads.dao;

import com.muads.model.CoinTransaction;

import java.sql.*;

public class CoinTransactionDAO {

    public void insert(CoinTransaction ct) throws Exception {
        String sql = """
            INSERT INTO coin_transactions(user_id,amount,type,reason)
            VALUES(?,?,?,?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, ct.getUserId());
            ps.setInt(2, ct.getAmount());
            ps.setString(3, ct.getType());
            ps.setString(4, ct.getReason());
            ps.executeUpdate();
        }
    }
}
