package com.gu.repository;

import com.gu.model.entity.UserGroupBuyProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UserGroupBuyProgressRepository extends JpaRepository<UserGroupBuyProgress, Long> {
    List<UserGroupBuyProgress> findByUserId(String userId);
}