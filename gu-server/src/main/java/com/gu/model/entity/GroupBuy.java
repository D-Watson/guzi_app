package com.gu.model.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "group_buys")
public class GroupBuy {
    @Id @Column(length = 32)
    private String id;
    @Column(nullable = false, length = 200)
    private String title;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ip_id", nullable = false)
    private Ip ip;
    @Column(length = 50)
    private String characterName = "";
    @Column(length = 500)
    private String imageUrl = "";
    @Column(length = 32)
    private String leaderId;
    @Column(nullable = false, length = 50)
    private String leaderNickname;
    private int currentCount = 0;
    @Column(nullable = false)
    private int totalCount;
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal depositPrice;
    @Column(precision = 10, scale = 2)
    private BigDecimal finalPrice;
    @Column(nullable = false)
    private LocalDateTime deadline;
    private LocalDateTime expectedShipDate;
    @Column(length = 500)
    private String shippingFeeRule = "AA制";
    @Column(columnDefinition = "TEXT")
    private String rules = "";
    @Column(columnDefinition = "TEXT")
    private String memberIds;
    @Column(length = 20)
    private String status = "recruiting";
    private LocalDateTime createdAt = LocalDateTime.now();

    public GroupBuy() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public Ip getIp() { return ip; }
    public void setIp(Ip ip) { this.ip = ip; }
    public String getCharacterName() { return characterName; }
    public void setCharacterName(String characterName) { this.characterName = characterName; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getLeaderId() { return leaderId; }
    public void setLeaderId(String leaderId) { this.leaderId = leaderId; }
    public String getLeaderNickname() { return leaderNickname; }
    public void setLeaderNickname(String leaderNickname) { this.leaderNickname = leaderNickname; }
    public int getCurrentCount() { return currentCount; }
    public void setCurrentCount(int currentCount) { this.currentCount = currentCount; }
    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    public BigDecimal getDepositPrice() { return depositPrice; }
    public void setDepositPrice(BigDecimal depositPrice) { this.depositPrice = depositPrice; }
    public BigDecimal getFinalPrice() { return finalPrice; }
    public void setFinalPrice(BigDecimal finalPrice) { this.finalPrice = finalPrice; }
    public LocalDateTime getDeadline() { return deadline; }
    public void setDeadline(LocalDateTime deadline) { this.deadline = deadline; }
    public LocalDateTime getExpectedShipDate() { return expectedShipDate; }
    public void setExpectedShipDate(LocalDateTime expectedShipDate) { this.expectedShipDate = expectedShipDate; }
    public String getShippingFeeRule() { return shippingFeeRule; }
    public void setShippingFeeRule(String shippingFeeRule) { this.shippingFeeRule = shippingFeeRule; }
    public String getRules() { return rules; }
    public void setRules(String rules) { this.rules = rules; }
    public String getMemberIds() { return memberIds; }
    public void setMemberIds(String memberIds) { this.memberIds = memberIds; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}