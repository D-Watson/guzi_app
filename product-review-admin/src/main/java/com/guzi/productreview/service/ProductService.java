package com.guzi.productreview.service;

import com.guzi.productreview.common.BusinessException;
import com.guzi.productreview.dto.query.ProductPageQuery;
import com.guzi.productreview.dto.request.ProductSubmitRequest;
import com.guzi.productreview.dto.response.ProductVO;
import com.guzi.productreview.common.PageResult;
import com.guzi.productreview.entity.Product;
import com.guzi.productreview.entity.ProductImage;
import com.guzi.productreview.enums.ProductStatus;
import com.guzi.productreview.repository.ProductImageRepository;
import com.guzi.productreview.repository.ProductRepository;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;
    private final ProductImageRepository productImageRepository;

    @Transactional
    public ProductVO create(Long merchantId, ProductSubmitRequest request) {
        Product product = new Product();
        product.setMerchantId(merchantId);
        applyRequest(product, request);
        product.setStatus(ProductStatus.DRAFT);
        productRepository.save(product);

        saveImages(product.getId(), request.getImages());
        product.setImages(productImageRepository.findByProductIdOrderBySortOrderAsc(product.getId()));
        return ProductVO.from(product);
    }

    @Transactional
    public ProductVO update(Long merchantId, Long productId, ProductSubmitRequest request) {
        Product product = productRepository.findByIdAndMerchantIdAndDeletedFalse(productId, merchantId)
                .orElseThrow(() -> new BusinessException("商品不存在"));

        if (product.getStatus() == ProductStatus.APPROVED) {
            throw new BusinessException("已上架商品无法修改");
        }

        applyRequest(product, request);
        product.setStatus(ProductStatus.DRAFT);
        product.setRejectReason(null);
        productRepository.save(product);

        productImageRepository.deleteByProductId(productId);
        saveImages(productId, request.getImages());
        product.setImages(productImageRepository.findByProductIdOrderBySortOrderAsc(productId));
        return ProductVO.from(product);
    }

    @Transactional
    public void submit(Long merchantId, Long productId) {
        Product product = productRepository.findByIdAndMerchantIdAndDeletedFalse(productId, merchantId)
                .orElseThrow(() -> new BusinessException("商品不存在"));

        if (product.getStatus() != ProductStatus.DRAFT && product.getStatus() != ProductStatus.REJECTED) {
            throw new BusinessException("当前状态无法提交审核");
        }

        product.setStatus(ProductStatus.PENDING);
        productRepository.save(product);
    }

    public PageResult<ProductVO> listMerchantProducts(Long merchantId, ProductPageQuery query) {
        Specification<Product> spec = (root, criteriaQuery, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("merchantId"), merchantId));
            predicates.add(cb.equal(root.get("deleted"), false));
            if (query.getStatus() != null && !query.getStatus().isEmpty()) {
                predicates.add(cb.equal(root.get("status"), ProductStatus.valueOf(query.getStatus())));
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

    public ProductVO getDetail(Long merchantId, Long productId) {
        Product product = productRepository.findByIdAndMerchantIdAndDeletedFalse(productId, merchantId)
                .orElseThrow(() -> new BusinessException("商品不存在"));
        product.setImages(productImageRepository.findByProductIdOrderBySortOrderAsc(productId));
        return ProductVO.from(product);
    }

    @Transactional
    public void delete(Long merchantId, Long productId) {
        Product product = productRepository.findByIdAndMerchantIdAndDeletedFalse(productId, merchantId)
                .orElseThrow(() -> new BusinessException("商品不存在"));
        product.setDeleted(true);
        productRepository.save(product);
    }

    private void applyRequest(Product product, ProductSubmitRequest request) {
        product.setName(request.getName());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());
        product.setStock(request.getStock() != null ? request.getStock() : 0);
        product.setCategoryId(request.getCategoryId());
        product.setCoverImage(request.getCoverImage());
    }

    private void saveImages(Long productId, List<String> imageUrls) {
        if (imageUrls != null) {
            for (int i = 0; i < imageUrls.size(); i++) {
                ProductImage pi = new ProductImage();
                pi.setProductId(productId);
                pi.setUrl(imageUrls.get(i));
                pi.setSortOrder(i);
                productImageRepository.save(pi);
            }
        }
    }
}