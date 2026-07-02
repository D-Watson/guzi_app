package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.Message;
import com.gu.repository.MessageRepository;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/messages")
public class MessageController {
    private final MessageRepository messageRepository;

    public MessageController(MessageRepository messageRepository) {
        this.messageRepository = messageRepository;
    }

    @GetMapping
    public ApiResponse<Map<String, Object>> getMessages() {
        List<Message> messages = messageRepository.findByToUserIdOrderByCreatedAtDesc("u_current");
        List<Map<String, Object>> content = messages.stream().map(msg -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", msg.getId());
            m.put("fromUserId", msg.getFromUserId());
            m.put("content", msg.getContent());
            m.put("createdAt", msg.getCreatedAt());
            m.put("isRead", msg.isRead());
            return m;
        }).toList();
        return ApiResponse.success(Map.of("content", content, "totalElements", content.size()));
    }
}