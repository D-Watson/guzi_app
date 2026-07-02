package com.gu.controller;

import com.gu.model.dto.ApiResponse;
import com.gu.model.entity.GroupBuy;
import com.gu.model.entity.UserGroupBuyProgress;
import com.gu.service.GroupBuyService;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/group-buys")
public class GroupBuyController {
    private final GroupBuyService groupBuyService;

    public GroupBuyController(GroupBuyService groupBuyService) {
        this.groupBuyService = groupBuyService;
    }

    @GetMapping
    public ApiResponse<Map<String, Object>> getAll() {
        List<GroupBuy> list = groupBuyService.getAllGroupBuys();
        List<Map<String, Object>> content = list.stream().map(this::toGroupBuyMap).toList();
        return ApiResponse.success(Map.of(
            "content", content, "totalElements", content.size(),
            "totalPages", 1, "number", 0, "size", 20
        ));
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> getById(@PathVariable String id) {
        GroupBuy gb = groupBuyService.getGroupBuyById(id);
        if (gb == null) return ApiResponse.error(404, "Group buy not found");
        return ApiResponse.success(toGroupBuyMap(gb));
    }

    @GetMapping("/my-progress")
    public ApiResponse<List<Map<String, Object>>> getMyProgress() {
        List<UserGroupBuyProgress> list = groupBuyService.getUserProgress("u_current");
        List<Map<String, Object>> result = list.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("groupBuyId", p.getGroupBuyId());
            m.put("hasPaidDeposit", p.isHasPaidDeposit());
            m.put("waitingForSupplement", p.isWaitingForSupplement());
            m.put("shipped", p.isShipped());
            m.put("received", p.isReceived());
            // Look up title from group buy
            GroupBuy gb = groupBuyService.getGroupBuyById(p.getGroupBuyId());
            m.put("title", gb != null ? gb.getTitle() : "");
            m.put("status", gb != null ? gb.getStatus() : "");
            return m;
        }).toList();
        return ApiResponse.success(result);
    }

    private Map<String, Object> toGroupBuyMap(GroupBuy gb) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", gb.getId());
        m.put("title", gb.getTitle());
        m.put("ip", Map.of(
            "id", gb.getIp().getId(), "name", gb.getIp().getName(),
            "iconUrl", gb.getIp().getIconUrl() != null ? gb.getIp().getIconUrl() : "",
            "characters", splitToList(gb.getIp().getCharacters())
        ));
        m.put("characterName", gb.getCharacterName() != null ? gb.getCharacterName() : "");
        m.put("imageUrl", gb.getImageUrl() != null ? gb.getImageUrl() : "");
        m.put("leaderId", gb.getLeaderId());
        m.put("leaderNickname", gb.getLeaderNickname());
        m.put("currentCount", gb.getCurrentCount());
        m.put("totalCount", gb.getTotalCount());
        m.put("depositPrice", gb.getDepositPrice());
        m.put("finalPrice", gb.getFinalPrice());
        m.put("deadline", gb.getDeadline());
        m.put("expectedShipDate", gb.getExpectedShipDate());
        m.put("shippingFeeRule", gb.getShippingFeeRule() != null ? gb.getShippingFeeRule() : "");
        m.put("rules", gb.getRules() != null ? gb.getRules() : "");
        m.put("memberIds", splitToList(gb.getMemberIds()));
        m.put("status", gb.getStatus());
        return m;
    }

    private List<String> splitToList(String str) {
        if (str == null || str.trim().isEmpty()) return List.of();
        return Arrays.stream(str.split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }
}