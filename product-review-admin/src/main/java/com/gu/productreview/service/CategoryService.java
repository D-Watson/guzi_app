package com.shizhuang.productreview.service;

import com.shizhuang.productreview.common.BusinessException;
import com.shizhuang.productreview.dto.request.CategoryRequest;
import com.shizhuang.productreview.dto.response.CategoryVO;
import com.shizhuang.productreview.entity.Category;
import com.shizhuang.productreview.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final StringRedisTemplate stringRedisTemplate;

    private static final String CACHE_KEY = "category:tree";

    public void create(CategoryRequest request) {
        Category category = new Category();
        category.setName(request.getName());
        category.setSortOrder(request.getSortOrder() != null ? request.getSortOrder() : 0);
        category.setIcon(request.getIcon());

        if (request.getParentId() != null) {
            Category parent = categoryRepository.findById(request.getParentId())
                    .orElseThrow(() -> new BusinessException("父分类不存在"));
            category.setParentId(parent.getId());
            category.setLevel(parent.getLevel() + 1);
            category.setPath(parent.getPath() + parent.getId() + ",");
        } else {
            category.setLevel(0);
            category.setPath(",");
        }

        categoryRepository.save(category);
        clearCache();
    }

    public void update(Long id, CategoryRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new BusinessException("分类不存在"));

        category.setName(request.getName());
        category.setSortOrder(request.getSortOrder());
        category.setIcon(request.getIcon());
        categoryRepository.save(category);
        clearCache();
    }

    public void delete(Long id) {
        if (categoryRepository.existsByParentIdAndDeletedFalse(id)) {
            throw new BusinessException("该分类下有子分类，无法删除");
        }
        categoryRepository.deleteById(id);
        clearCache();
    }

    public List<CategoryVO> getTree() {
        String cached = stringRedisTemplate.opsForValue().get(CACHE_KEY);
        if (cached != null) {
            // Return from cache - in production use JSON deserialization
            // For now, rebuild from DB to keep things simple
        }

        List<Category> all = categoryRepository.findAllByOrderBySortOrderAsc();
        List<CategoryVO> tree = buildTree(all, null);
        return tree;
    }

    public void clearCache() {
        stringRedisTemplate.delete(CACHE_KEY);
    }

    private List<CategoryVO> buildTree(List<Category> all, Long parentId) {
        return all.stream()
                .filter(c -> Objects.equals(c.getParentId(), parentId))
                .map(c -> {
                    CategoryVO vo = CategoryVO.from(c);
                    vo.setChildren(buildTree(all, c.getId()));
                    return vo;
                })
                .collect(Collectors.toList());
    }
}