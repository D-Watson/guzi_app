package com.gu.service;

import com.gu.model.entity.User;
import com.gu.repository.UserRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;
    private static final String CURRENT_USER = "u_current";

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User getCurrentUser() {
        return userRepository.findById(CURRENT_USER).orElse(null);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}