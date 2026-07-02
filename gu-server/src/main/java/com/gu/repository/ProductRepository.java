package com.gu.repository;

import com.gu.model.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, String> {
    List<Product> findByIpId(String ipId);
    List<Product> findByCategoryId(String categoryId);
    List<Product> findByIpIdAndIdNot(String ipId, String id);
}