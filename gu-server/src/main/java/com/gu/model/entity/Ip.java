package com.gu.model.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ips")
public class Ip {
    @Id @Column(length = 32)
    private String id;
    @Column(nullable = false, length = 50)
    private String name;
    @Column(length = 500)
    private String iconUrl = "";
    @Column(columnDefinition = "TEXT")
    private String characters = "";

    public Ip() {}
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }
    public String getCharacters() { return characters; }
    public void setCharacters(String characters) { this.characters = characters; }
}