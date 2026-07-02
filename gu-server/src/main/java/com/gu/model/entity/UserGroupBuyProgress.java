package com.gu.model.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_group_buy_progress",
       uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "group_buy_id"}))
public class UserGroupBuyProgress {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(length = 32)
    private String userId;
    @Column(length = 32)
    private String groupBuyId;
    private boolean hasPaidDeposit = false;
    private boolean waitingForSupplement = false;
    private boolean shipped = false;
    private boolean received = false;

    public UserGroupBuyProgress() {}
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getGroupBuyId() { return groupBuyId; }
    public void setGroupBuyId(String groupBuyId) { this.groupBuyId = groupBuyId; }
    public boolean isHasPaidDeposit() { return hasPaidDeposit; }
    public void setHasPaidDeposit(boolean hasPaidDeposit) { this.hasPaidDeposit = hasPaidDeposit; }
    public boolean isWaitingForSupplement() { return waitingForSupplement; }
    public void setWaitingForSupplement(boolean waitingForSupplement) { this.waitingForSupplement = waitingForSupplement; }
    public boolean isShipped() { return shipped; }
    public void setShipped(boolean shipped) { this.shipped = shipped; }
    public boolean isReceived() { return received; }
    public void setReceived(boolean received) { this.received = received; }
}