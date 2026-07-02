package com.shizhuang.productreview.service;

import com.shizhuang.productreview.common.BusinessException;
import com.shizhuang.productreview.config.JwtTokenProvider;
import com.shizhuang.productreview.dto.request.LoginRequest;
import com.shizhuang.productreview.dto.request.RegisterRequest;
import com.shizhuang.productreview.dto.response.LoginVO;
import com.shizhuang.productreview.entity.User;
import com.shizhuang.productreview.enums.UserRole;
import com.shizhuang.productreview.enums.UserStatus;
import com.shizhuang.productreview.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;
    private final StringRedisTemplate stringRedisTemplate;

    private static final String TOKEN_KEY_PREFIX = "token:";

    public LoginVO register(RegisterRequest request) {
        if (userRepository.existsByUsernameAndDeletedFalse(request.getUsername())) {
            throw new BusinessException("用户名已存在");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickname(request.getNickname());
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setRole(UserRole.MERCHANT);
        user.setStatus(UserStatus.ENABLED);
        user.setCompanyName(request.getCompanyName());
        user.setContactPerson(request.getContactPerson());
        userRepository.save(user);

        String token = tokenProvider.generateToken(user.getId(), user.getRole().name());
        cacheToken(user.getId(), token);
        return LoginVO.of(token, tokenProvider.getExpirationMs(), user);
    }

    public LoginVO login(LoginRequest request) {
        User user = userRepository.findByUsernameAndDeletedFalse(request.getUsername())
                .orElseThrow(() -> new BusinessException("用户名或密码错误"));

        if (user.getStatus() == UserStatus.DISABLED) {
            throw new BusinessException("账户已被禁用");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }

        String token = tokenProvider.generateToken(user.getId(), user.getRole().name());
        cacheToken(user.getId(), token);
        return LoginVO.of(token, tokenProvider.getExpirationMs(), user);
    }

    public void logout(Long userId) {
        stringRedisTemplate.delete(TOKEN_KEY_PREFIX + userId);
    }

    private void cacheToken(Long userId, String token) {
        stringRedisTemplate.opsForValue().set(
                TOKEN_KEY_PREFIX + userId,
                token,
                tokenProvider.getExpirationMs(),
                TimeUnit.MILLISECONDS
        );
    }
}