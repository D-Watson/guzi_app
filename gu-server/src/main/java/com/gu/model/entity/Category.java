package com.gu.model.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "categories")
public class Category {
    @Id @Column(length = 32)
    private String id;
    @Column(nullable = false, length = 50)
    private String name;
    @Column(length = 10)
    private String icon = "";

    public Category() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
}