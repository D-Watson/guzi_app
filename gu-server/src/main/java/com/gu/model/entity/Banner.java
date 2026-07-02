package com.gu.model.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "banners")
public class Banner {
    @Id @Column(length = 32)
    private String id;
    @Column(length = 500)
    private String imageUrl = "";
    @Column(length = 200)
    private String title;
    @Column(length = 200)
    private String subtitle = "";
    private int sortOrder = 0;

    public Banner() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
}