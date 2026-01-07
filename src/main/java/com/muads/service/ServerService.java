package com.muads.service;

import com.muads.entity.Server;
import com.muads.repository.ServerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServerService {

    @Autowired
    private ServerRepository serverRepository;

    public Server registerNewServer(Server server) {
        // Có thể thêm logic kiểm tra dữ liệu ở đây
        // Ví dụ: set ngày tạo là ngày hiện tại
        return serverRepository.save(server);
    }

    public List<Server> getAllServers() {
        return serverRepository.findAll();
    }
}