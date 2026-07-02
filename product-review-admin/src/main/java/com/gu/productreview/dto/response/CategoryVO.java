package com.shizhuang.productreview.dto.response;

import com.shizhuang.productreview.entity.Category;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class CategoryVO {

    private Long id;
    private String name;
    private Long parentId;
    private Integer sortOrder;
    private String icon;
    private Integer level;
    private String path;
    private List<CategoryVO> children = new ArrayList<>();

    public static CategoryVO from(Category category) {
        CategoryVO vo = new CategoryVO();
        vo.setId(category.getId());
        vo.setName(category.getName());
        vo.setParentId(category.getParentId());
        vo.setSortOrder(category.getSortOrder());
        vo.setIcon(category.getIcon());
        vo.setLevel(category.getLevel());
        vo.setPath(category.getPath());
        return vo;
    }
}