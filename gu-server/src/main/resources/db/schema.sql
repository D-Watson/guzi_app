SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========== 用户 ==========
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(32) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    avatar_url VARCHAR(500) DEFAULT '',
    credit_score DOUBLE DEFAULT 100,
    completed_orders INT DEFAULT 0,
    good_rate DOUBLE DEFAULT 1.0,
    is_verified TINYINT(1) DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== IP（动漫/游戏IP） ==========
CREATE TABLE IF NOT EXISTS ips (
    id VARCHAR(32) NOT NULL,
    name VARCHAR(50) NOT NULL,
    icon_url VARCHAR(500) DEFAULT '',
    characters TEXT,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== Banner ==========
CREATE TABLE IF NOT EXISTS banners (
    id VARCHAR(32) NOT NULL,
    image_url VARCHAR(500) DEFAULT '',
    title VARCHAR(200),
    subtitle VARCHAR(200) DEFAULT '',
    sort_order INT DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== 拼团 ==========
CREATE TABLE IF NOT EXISTS group_buys (
    id VARCHAR(32) NOT NULL,
    title VARCHAR(200) NOT NULL,
    ip_id VARCHAR(32) NOT NULL,
    character_name VARCHAR(50) DEFAULT '',
    image_url VARCHAR(500) DEFAULT '',
    leader_id VARCHAR(32),
    leader_nickname VARCHAR(50) NOT NULL,
    current_count INT DEFAULT 0,
    total_count INT NOT NULL,
    deposit_price DECIMAL(10,2) NOT NULL,
    final_price DECIMAL(10,2),
    deadline DATETIME NOT NULL,
    expected_ship_date DATETIME,
    shipping_fee_rule VARCHAR(500) DEFAULT 'AA制',
    rules TEXT,
    member_ids TEXT,
    status VARCHAR(20) DEFAULT 'recruiting',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_gb_ip_id (ip_id),
    CONSTRAINT fk_groupbuy_ip FOREIGN KEY (ip_id) REFERENCES ips(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== 帖子 ==========
CREATE TABLE IF NOT EXISTS posts (
    id VARCHAR(32) NOT NULL,
    author_id VARCHAR(32) NOT NULL,
    content TEXT NOT NULL,
    image_urls TEXT,
    type VARCHAR(20) DEFAULT 'showOff',
    created_at DATETIME NOT NULL,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_author_id (author_id),
    CONSTRAINT fk_post_author FOREIGN KEY (author_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== 收藏 ==========
CREATE TABLE IF NOT EXISTS favorites (
    id BIGINT AUTO_INCREMENT NOT NULL,
    user_id VARCHAR(32),
    product_id BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== 订单 ==========
CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(32) NOT NULL,
    user_id VARCHAR(32),
    product_id BIGINT,
    product_title VARCHAR(200) NOT NULL,
    product_price DECIMAL(10,2) NOT NULL,
    product_image_url VARCHAR(500) DEFAULT '',
    trade_type_label VARCHAR(50) DEFAULT '一口价',
    deposit_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 1,
    status VARCHAR(20) DEFAULT 'pendingPayment',
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== 消息 ==========
CREATE TABLE IF NOT EXISTS messages (
    id VARCHAR(32) NOT NULL,
    from_user_id VARCHAR(32),
    to_user_id VARCHAR(32),
    content TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========== 用户拼团进度 ==========
CREATE TABLE IF NOT EXISTS user_group_buy_progress (
    id BIGINT AUTO_INCREMENT NOT NULL,
    user_id VARCHAR(32),
    group_buy_id VARCHAR(32),
    has_paid_deposit TINYINT(1) DEFAULT 0,
    waiting_for_supplement TINYINT(1) DEFAULT 0,
    shipped TINYINT(1) DEFAULT 0,
    received TINYINT(1) DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_groupbuy (user_id, group_buy_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;