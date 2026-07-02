// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.admin.repository;

import com.gu.admin.entity.AdminProductImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdminProductImageRepository extends JpaRepository<AdminProductImage, Long> {

    List<AdminProductImage> findByProductIdOrderBySortOrderAsc(Long productId);
}