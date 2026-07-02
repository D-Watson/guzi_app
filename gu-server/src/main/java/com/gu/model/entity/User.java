package com.gu.model.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id @Column(length = 32)
    private String id;
    @Column(nullable = false, length = 50)
    private String nickname;
    @Column(length = 500)
    private String avatarUrl = "";
    private double creditScore = 100;
    private int completedOrders = 0;
    private double goodRate = 1.0;
    private boolean isVerified = false;

    public User() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public double getCreditScore() { return creditScore; }
    public void setCreditScore(double creditScore) { this.creditScore = creditScore; }
    public int getCompletedOrders() { return completedOrders; }
    public void setCompletedOrders(int completedOrders) { this.completedOrders = completedOrders; }
    public double getGoodRate() { return goodRate; }
    public void setGoodRate(double goodRate) { this.goodRate = goodRate; }
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }
}