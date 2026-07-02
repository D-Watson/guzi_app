package com.guzi.productreview.repository;

import com.guzi.productreview.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {

    Optional<Product> findByIdAndMerchantIdAndDeletedFalse(Long id, Long merchantId);

    Optional<Product> findByIdAndDeletedFalse(Long id);
}