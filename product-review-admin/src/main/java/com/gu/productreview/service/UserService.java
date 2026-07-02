package com.shizhuang.productreview.service;

import com.shizhuang.productreview.common.BusinessException;
import com.shizhuang.productreview.dto.query.UserPageQuery;
import com.shizhuang.productreview.dto.response.UserVO;
import com.shizhuang.productreview.common.PageResult;
import com.shizhuang.productreview.entity.User;
import com.shizhuang.productreview.enums.UserRole;
import com.shizhuang.productreview.enums.UserStatus;
import com.shizhuang.productreview.repository.UserRepository;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final StringRedisTemplate stringRedisTemplate;

    private static final String TOKEN_KEY_PREFIX = "token:";

    public PageResult<UserVO> listMerchants(UserPageQuery query) {
        Specification<User> spec = (root, cb, cq) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("role"), UserRole.MERCHANT));
            predicates.add(cb.equal(root.get("deleted"), false));

            if (query.getStatus() != null) {
                predicates.add(cb.equal(root.get("status"), UserStatus.valueOf(query.getStatus())));
            }
            if (query.getKeyword() != null && !query.getKeyword().isEmpty()) {
                predicates.add(cb.like(root.get("companyName"), "%" + query.getKeyword() + "%"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<User> page = userRepository.findAll(spec,
                PageRequest.of(query.getPage() - 1, query.getSize(), Sort.by(Sort.Direction.DESC, "createTime")));

        List<UserVO> records = page.getContent().stream()
                .map(UserVO::from)
                .collect(Collectors.toList());

        return PageResult.of(page.getTotalElements(), query.getPage(), query.getSize(), records);
    }

    public void updateStatus(Long userId, String status) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));

        user.setStatus(UserStatus.valueOf(status));
        userRepository.save(user);

        if (status.equals(UserStatus.DISABLED.name())) {
            stringRedisTemplate.delete(TOKEN_KEY_PREFIX + userId);
        }
    }
}