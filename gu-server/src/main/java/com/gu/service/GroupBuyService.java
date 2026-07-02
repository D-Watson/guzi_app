package com.gu.service;

import com.gu.model.entity.GroupBuy;
import com.gu.model.entity.UserGroupBuyProgress;
import com.gu.repository.GroupBuyRepository;
import com.gu.repository.UserGroupBuyProgressRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class GroupBuyService {
    private final GroupBuyRepository groupBuyRepository;
    private final UserGroupBuyProgressRepository progressRepository;

    public GroupBuyService(GroupBuyRepository groupBuyRepository,
                           UserGroupBuyProgressRepository progressRepository) {
        this.groupBuyRepository = groupBuyRepository;
        this.progressRepository = progressRepository;
    }

    public List<GroupBuy> getAllGroupBuys() {
        return groupBuyRepository.findAll();
    }

    public GroupBuy getGroupBuyById(String id) {
        return groupBuyRepository.findById(id).orElse(null);
    }

    public List<UserGroupBuyProgress> getUserProgress(String userId) {
        return progressRepository.findByUserId(userId);
    }
}