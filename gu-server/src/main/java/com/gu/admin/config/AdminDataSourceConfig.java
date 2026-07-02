// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
package com.gu.admin.config;

import jakarta.persistence.EntityManagerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

@Configuration
@EnableJpaRepositories(
        basePackages = "com.gu.admin.repository",
        entityManagerFactoryRef = "adminEntityManagerFactory",
        transactionManagerRef = "adminTransactionManager"
)
public class AdminDataSourceConfig {

    @Bean
    @ConfigurationProperties("admin.datasource")
    public DataSourceProperties adminDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean
    public DataSource adminDataSource() {
        return adminDataSourceProperties()
                .initializeDataSourceBuilder()
                .build();
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean adminEntityManagerFactory(
            EntityManagerFactoryBuilder builder) {
        return builder
                .dataSource(adminDataSource())
                .packages("com.gu.admin.entity")
                .persistenceUnit("admin")
                .build();
    }

    @Bean
    public PlatformTransactionManager adminTransactionManager(
            @Qualifier("adminEntityManagerFactory") EntityManagerFactory entityManagerFactory) {
        return new JpaTransactionManager(entityManagerFactory);
    }
}