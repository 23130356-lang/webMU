package com.muads; // Đảm bảo dòng này đúng tên package thư mục đang chứa nó

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication // Chỉ cần dòng này, KHÔNG thêm @ComponentScan

public class WebmuApplication {
    public static void main(String[] args) {
        SpringApplication.run(WebmuApplication.class, args);
    }
}