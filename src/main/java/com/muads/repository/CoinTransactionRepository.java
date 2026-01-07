package com.muads.repository;

import com.muads.entity.CoinTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CoinTransactionRepository extends JpaRepository<CoinTransaction, Integer> {
    // Xem lịch sử giao dịch của 1 user
    List<CoinTransaction> findByUser_IdOrderByCreatedAtDesc(Integer userId);
}