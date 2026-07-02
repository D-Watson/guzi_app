// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.dto.CreateOrderRequest;
import com.gu.model.entity.Order;
import com.gu.service.OrderService;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    public ApiResponse<Map<String, Object>> getOrders() {
        List<Order> orders = orderService.getUserOrders();
        List<Map<String, Object>> content = orders.stream().map(o -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", o.getId());
            m.put("productId", o.getProductId() != null ? String.valueOf(o.getProductId()) : "");
            m.put("productTitle", o.getProductTitle());
            m.put("productPrice", o.getProductPrice());
            m.put("productImageUrl", o.getProductImageUrl() != null ? o.getProductImageUrl() : "");
            m.put("tradeTypeLabel", o.getTradeTypeLabel() != null ? o.getTradeTypeLabel() : "");
            m.put("depositAmount", o.getDepositAmount());
            m.put("totalAmount", o.getTotalAmount());
            m.put("quantity", o.getQuantity());
            m.put("status", o.getStatus());
            m.put("createdAt", o.getCreatedAt());
            return m;
        }).toList();
        return ApiResponse.success(Map.of("content", content, "totalElements", content.size()));
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> createOrder(@RequestBody CreateOrderRequest req) {
        Order order = orderService.createOrder(Long.parseLong(req.getProductId()), req.getQuantity(), req.getTradeType());
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", order.getId());
        m.put("productId", order.getProductId() != null ? String.valueOf(order.getProductId()) : "");
        m.put("productTitle", order.getProductTitle());
        m.put("productPrice", order.getProductPrice());
        m.put("productImageUrl", order.getProductImageUrl() != null ? order.getProductImageUrl() : "");
        m.put("tradeTypeLabel", order.getTradeTypeLabel());
        m.put("depositAmount", order.getDepositAmount());
        m.put("totalAmount", order.getTotalAmount());
        m.put("quantity", order.getQuantity());
        m.put("status", order.getStatus());
        m.put("createdAt", order.getCreatedAt());
        return ApiResponse.success(m);
    }
}