package com.guzi.productreview.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "category")
public class Category extends BaseEntity {

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(length = 255)
    private String icon;

    @Column(nullable = false)
    private Integer level = 0;

    @Column(length = 500)
    private String path;

    @Transient
    private List<Category> children;
}