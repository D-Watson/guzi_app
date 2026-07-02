package com.shizhuang.productreview.service;

import com.shizhuang.productreview.common.BusinessException;
import com.shizhuang.productreview.dto.query.ProductPageQuery;
import com.shizhuang.productreview.dto.response.ProductVO;
import com.shizhuang.productreview.common.PageResult;
import com.shizhuang.productreview.entity.Product;
import com.shizhuang.productreview.enums.ProductStatus;
import com.shizhuang.productreview.repository.ProductImageRepository;
import com.shizhuang.productreview.repository.ProductRepository;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ProductRepository productRepository;
    private final ProductImageRepository productImageRepository;

    public PageResult<ProductVO> getPendingList(ProductPageQuery query) {
        query.setStatus(ProductStatus.PENDING.name());
        return listAll(query);
    }

    public PageResult<ProductVO> listAll(ProductPageQuery query) {
        Specification<Product> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("deleted"), false));
            if (query.getStatus() != null) {
                predicates.add(cb.equal(root.get("status"), ProductStatus.valueOf(query.getStatus())));
            }
            if (query.getMerchantId() != null) {
                predicates.add(cb.equal(root.get("merchantId"), query.getMerchantId()));
            }
            if (query.getCategoryId() != null) {
                predicates.add(cb.equal(root.get("categoryId"), query.getCategoryId()));
            }
            if (query.getKeyword() != null && !query.getKeyword().isEmpty()) {
                predicates.add(cb.like(root.get("name"), "%" + query.getKeyword() + "%"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Product> page = productRepository.findAll(spec,
                PageRequest.of(query.getPage() - 1, query.getSize(), Sort.by(Sort.Direction.DESC, "createTime")));

        List<ProductVO> records = page.getContent().stream()
                .peek(p -> p.setImages(productImageRepository.findByProductIdOrderBySortOrderAsc(p.getId())))
                .map(ProductVO::from)
                .collect(Collectors.toList());

        return PageResult.of(page.getTotalElements(), query.getPage(), query.getSize(), records);
    }

    @Transactional
    public void approve(Long reviewId, Long reviewerId) {
        Product product = productRepository.findByIdAndDeletedFalse(reviewId)
                .orElseThrow(() -> new BusinessException("商品不存在"));

        if (product.getStatus() != ProductStatus.PENDING) {
            throw new BusinessException("该商品不在待审核状态");
        }

        product.setStatus(ProductStatus.APPROVED);
        product.setReviewerId(reviewerId);
        product.setReviewTime(new Date());
        product.setListedAt(new Date());
        productRepository.save(product);
    }

    @Transactional
    public void reject(Long reviewId, Long reviewerId, String reason) {
        Product product = productRepository.findByIdAndDeletedFalse(reviewId)
                .orElseThrow(() -> new BusinessException("商品不存在"));

        if (product.getStatus() != ProductStatus.PENDING) {
            throw new BusinessException("该商品不在待审核状态");
        }

        product.setStatus(ProductStatus.REJECTED);
        product.setRejectReason(reason);
        product.setReviewerId(reviewerId);
        product.setReviewTime(new Date());
        productRepository.save(product);
    }

    public ProductVO getDetail(Long productId) {
        Product product = productRepository.findByIdAndDeletedFalse(productId)
                .orElseThrow(() -> new BusinessException("商品不存在"));
        product.setImages(productImageRepository.findByProductIdOrderBySortOrderAsc(productId));
        return ProductVO.from(product);
    }
}