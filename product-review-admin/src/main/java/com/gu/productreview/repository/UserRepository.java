package com.shizhuang.productreview.repository;

import com.shizhuang.productreview.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {

    Optional<User> findByUsernameAndDeletedFalse(String username);

    boolean existsByUsernameAndDeletedFalse(String username);
}