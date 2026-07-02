// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.admin.repository;

import com.gu.admin.entity.AdminProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AdminProductRepository extends JpaRepository<AdminProduct, Long> {

    List<AdminProduct> findByStatusAndDeletedFalseOrderByCreateTimeDesc(String status);

    List<AdminProduct> findByStatusAndDeletedFalseAndCategoryIdOrderByCreateTimeDesc(String status, Long categoryId);

    Optional<AdminProduct> findByIdAndDeletedFalse(Long id);
}