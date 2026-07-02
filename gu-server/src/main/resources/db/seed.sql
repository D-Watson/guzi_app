SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========== 用户 ==========
INSERT IGNORE INTO users (id, nickname, avatar_url, credit_score, completed_orders, good_rate, is_verified) VALUES
('u_current', '谷子收藏家', '', 98, 42, 0.99, 1),
('u_1', '二次元小铺', '', 95, 128, 0.98, 1),
('u_2', 'C服工坊', '', 92, 67, 0.97, 1),
('u_3', '吃谷人A', '', 88, 23, 0.95, 0),
('u_4', '漫展达人', '', 96, 203, 0.99, 1),
('u_5', '同好会会长', '', 90, 55, 0.96, 1),
('u_6', '出谷中', '', 85, 12, 0.92, 0),
('u_7', 'coser小羽', '', 93, 89, 0.98, 1),
('u_8', '周边收藏家', '', 91, 156, 0.97, 1);

-- ========== IP ==========
INSERT IGNORE INTO ips (id, name, icon_url, characters) VALUES
('ip_1', '原神', 'https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Genshin_Impact_logo.svg/250px-Genshin_Impact_logo.svg.png', '钟离,雷电将军,纳西妲,芙宁娜,那维莱特'),
('ip_2', '排球少年', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Haiky%C5%AB_Volume_1.jpg/250px-Haiky%C5%AB_Volume_1.jpg', '日向翔阳,影山飞雄,及川彻,孤爪研磨'),
('ip_3', '咒术回战', 'https://upload.wikimedia.org/wikipedia/en/thumb/4/46/Jujutsu_kaisen.jpg/250px-Jujutsu_kaisen.jpg', '五条悟,虎杖悠仁,伏黑惠,钉崎野蔷薇'),
('ip_4', '蓝色监狱', 'https://upload.wikimedia.org/wikipedia/en/thumb/c/c6/Blue_Lock_manga_volume_1.png/250px-Blue_Lock_manga_volume_1.png', '洁世一,蜂乐回,凪诚士郎,糸师凛'),
('ip_5', '鬼灭之刃', 'https://upload.wikimedia.org/wikipedia/en/thumb/0/09/Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg/250px-Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg', '灶门炭治郎,我妻善逸,嘴平伊之助,甘露寺蜜璃'),
('ip_6', '文豪野犬', '', '太宰治,中岛敦,芥川龙之介'),
('ip_7', '时光代理人', '', '程小时,陆光,乔苓'),
('ip_8', '名侦探柯南', '', '工藤新一,怪盗基德,降谷零'),
('ip_9', '进击的巨人', '', '艾伦,利威尔,三笠,埃尔文'),
('ip_10', '未定事件簿', '', '左然,莫弈,夏彦,陆景和');

-- ========== 品类 ==========
INSERT IGNORE INTO categories (id, name, icon) VALUES
('cat_1', 'C服', '👗'),
('cat_2', '徽章', '🏅'),
('cat_3', '立牌', '🖼️'),
('cat_4', '假发', '💇'),
('cat_5', '吧唧', '🔘'),
('cat_6', '挂件', '🔑'),
('cat_7', '色纸', '📄'),
('cat_8', '手办', '🧸'),
('cat_9', '明信片', '💌'),
('cat_10', '其他', '📦');

-- ========== Banner ==========
INSERT IGNORE INTO banners (id, image_url, title, subtitle, sort_order) VALUES
('banner_1', '', '夏日动漫嘉年华 · 预热开启', '漫展专场低至8折', 0),
('banner_2', '', '原神 · 新角色C服预售', '纳塔系列开放预定', 1),
('banner_3', '', '拼团广场 · 热门团推荐', '排球少年吧唧拼团中', 2),
('banner_4', '', '个人闲置专场', '全新仅拆检，好价出谷', 3);

-- ========== 商品 ==========
INSERT IGNORE INTO products (id, title, image_urls, price, deposit_price, final_price, ip_id, character_name, category_id, trade_type, status, `condition`, seller_id, rating, sales_count, favorite_count, tags, group_buy_id, final_payment_deadline, is_spot, is_new, size_info, production_time, included_parts, material_info, defects_description, seller_completed_orders, seller_good_rate) VALUES
('p_1', '原神·钟离「天星」C服全套', 'https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Genshin_Impact_logo.svg/250px-Genshin_Impact_logo.svg.png', 399.00, 120.00, 279.00, 'ip_1', '钟离', 'cat_1', 'depositFinal', 'active', 'brandNew', 'u_2', 4.9, 36, 128, 'C服,定金,定制,全新', NULL, NULL, 0, 1, 'S/M/L/XL | 胸围: 88-112cm 腰围: 66-88cm 衣长: 72-82cm', '定制工期约30天', '外套,内衬,长裤,腰带,肩甲(道具),手套', '涤纶+仿丝绸，内衬纯棉', NULL, 67, 0.97),
('p_2', '排球少年·日向翔阳吧唧套装', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Haiky%C5%AB_Volume_1.jpg/250px-Haiky%C5%AB_Volume_1.jpg', 68.00, NULL, NULL, 'ip_2', '日向翔阳', 'cat_5', 'fixedPrice', 'active', 'brandNew', 'u_1', 4.8, 152, 312, '现货,吧唧,全新,套装', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, 128, 0.98),
('p_3', '咒术回战·五条悟立牌', 'https://upload.wikimedia.org/wikipedia/en/thumb/4/46/Jujutsu_kaisen.jpg/250px-Jujutsu_kaisen.jpg', 45.00, NULL, NULL, 'ip_3', '五条悟', 'cat_3', 'fixedPrice', 'active', 'likeNew', 'u_3', 4.7, 23, 67, '现货,立牌,二手,好价', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, 23, 0.95),
('p_4', '蓝色监狱·糸师凛C服订制', 'https://upload.wikimedia.org/wikipedia/en/thumb/c/c6/Blue_Lock_manga_volume_1.png/250px-Blue_Lock_manga_volume_1.png', 520.00, 150.00, 370.00, 'ip_4', '糸师凛', 'cat_1', 'depositFinal', 'active', 'brandNew', 'u_5', 4.9, 18, 94, 'C服,定金,拼团中,定制', 'gb_1', NULL, 0, 1, 'M/L/XL | 胸围: 92-110cm 腰围: 70-86cm 衣长: 70-80cm', '定制工期约45天', '外套,长裤,腰带,护腕', '高品质涤纶+网眼面料', '无瑕疵', 55, 0.96),
('p_5', '鬼灭之刃·甘露寺蜜璃假发', 'https://upload.wikimedia.org/wikipedia/en/thumb/0/09/Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg/250px-Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg', 158.00, NULL, NULL, 'ip_5', '甘露寺蜜璃', 'cat_4', 'fixedPrice', 'active', 'brandNew', 'u_8', 4.6, 44, 87, '现货,假发,全新,高还原', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, 156, 0.97),
('p_6', '文豪野犬·太宰治大衣 C服', 'https://upload.wikimedia.org/wikipedia/en/f/f8/Bung%C5%8D_Stray_Dogs_volume_1.jpg', 350.00, NULL, NULL, 'ip_6', '太宰治', 'cat_1', 'fixedPrice', 'active', 'good', 'u_6', 4.5, 8, 23, 'C服,现货,二手,高性价比', NULL, NULL, 1, 0, 'L码 | 胸围: 106cm 衣长: 85cm', NULL, NULL, '毛呢面料，内衬绸缎', '袖口轻微磨损，已标注', 12, 0.92),
('p_7', '时光代理人·程小时徽章套装', '', 35.00, NULL, NULL, 'ip_7', '程小时', 'cat_2', 'fixedPrice', 'active', 'brandNew', 'u_4', 4.8, 298, 456, '现货,徽章,全新,限时', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, 203, 0.99),
('p_8', '原神·芙宁娜C服+假发套装', 'https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Genshin_Impact_logo.svg/250px-Genshin_Impact_logo.svg.png', 680.00, 200.00, 480.00, 'ip_1', '芙宁娜', 'cat_1', 'depositFinal', 'active', 'brandNew', 'u_2', 4.9, 12, 234, 'C服,定金,套装,全新,高定', 'gb_2', NULL, 0, 1, 'XS/S/M | 胸围: 80-100cm 腰围: 60-78cm', '定制工期约60天（含假发）', '连衣裙,外套,手套,头饰,假发,道具权杖', '进口缎面+蕾丝，假发为高温丝', NULL, 67, 0.97),
('p_9', '进击的巨人·利威尔兵长徽章', 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Shingeki_no_Kyojin_manga_volume_1.jpg/250px-Shingeki_no_Kyojin_manga_volume_1.jpg', 28.00, NULL, NULL, 'ip_9', '利威尔', 'cat_2', 'fixedPrice', 'active', 'brandNew', 'u_1', 4.7, 201, 378, '现货,徽章,全新,促销', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, 128, 0.98),
('p_10', '未定事件簿·左然色纸收藏', '', 42.00, NULL, NULL, 'ip_10', '左然', 'cat_7', 'fixedPrice', 'active', 'brandNew', 'u_4', 4.9, 178, 289, '现货,色纸,全新,限定', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, 203, 0.99),
('p_11', '名侦探柯南·怪盗基德手办', 'https://upload.wikimedia.org/wikipedia/en/thumb/3/3f/Case_Closed_Volume_36.png/250px-Case_Closed_Volume_36.png', 268.00, NULL, NULL, 'ip_8', '怪盗基德', 'cat_8', 'fixedPrice', 'active', 'likeNew', 'u_7', 4.8, 56, 167, '现货,手办,几乎全新,特典', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, 89, 0.98),
('p_12', '排球少年·影山飞雄C服', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Haiky%C5%AB_Volume_1.jpg/250px-Haiky%C5%AB_Volume_1.jpg', 420.00, 130.00, 290.00, 'ip_2', '影山飞雄', 'cat_1', 'depositFinal', 'active', 'brandNew', 'u_8', 4.7, 24, 76, 'C服,定金,定制,拼团中', 'gb_3', NULL, 0, 1, 'M/L/XL | 胸围: 90-108cm 腰围: 68-84cm', '定制工期约35天', '运动外套,T恤,短裤,护膝,袜子', '吸湿排汗面料+弹力棉', NULL, 156, 0.97);

-- ========== 拼团 ==========
INSERT IGNORE INTO group_buys (id, title, ip_id, character_name, image_url, leader_id, leader_nickname, current_count, total_count, deposit_price, final_price, deadline, expected_ship_date, shipping_fee_rule, rules, member_ids, status) VALUES
('gb_1', '蓝锁糸师凛C服拼团', 'ip_4', '糸师凛', 'https://upload.wikimedia.org/wikipedia/en/thumb/c/c6/Blue_Lock_manga_volume_1.png/250px-Blue_Lock_manga_volume_1.png', 'u_5', '同好会会长', 8, 10, 150.00, 370.00, DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 45 DAY), '满10人包邮，不满分摊', '1. 定金不退，跑单扣50%定金\n2. 到货后7天内补尾款\n3. 发货前可转让名额', 'u_5,u_1,u_2,u_3,u_4,u_6,u_7,u_8', 'recruiting'),
('gb_2', '原神芙宁娜全套C服拼团', 'ip_1', '芙宁娜', 'https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Genshin_Impact_logo.svg/250px-Genshin_Impact_logo.svg.png', 'u_1', '二次元小铺', 5, 10, 200.00, 480.00, DATE_ADD(NOW(), INTERVAL 12 DAY), DATE_ADD(NOW(), INTERVAL 60 DAY), '国内包邮', '1. 定金可退，截团前可自由退出\n2. 截团后不退定金\n3. 尾款到货后统一通知', 'u_1,u_3,u_5,u_7', 'recruiting'),
('gb_3', '排球少年影山飞雄C服拼团', 'ip_2', '影山飞雄', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Haiky%C5%AB_Volume_1.jpg/250px-Haiky%C5%AB_Volume_1.jpg', 'u_7', 'coser小羽', 6, 6, 130.00, 290.00, DATE_ADD(NOW(), INTERVAL 12 HOUR), DATE_ADD(NOW(), INTERVAL 35 DAY), '已满员，团长统一寄出，邮费AA', '1. 已满员，不再加人\n2. 已付定金退出扣30%\n3. 到货后5天内补尾款', 'u_7,u_2,u_4,u_5,u_8', 'full'),
('gb_4', '咒术回战吧唧20个拼团', 'ip_3', '五条悟', 'https://upload.wikimedia.org/wikipedia/en/thumb/4/46/Jujutsu_kaisen.jpg/250px-Jujutsu_kaisen.jpg', 'u_3', '吃谷人A', 12, 20, 20.00, NULL, DATE_ADD(NOW(), INTERVAL 8 DAY), DATE_ADD(NOW(), INTERVAL 20 DAY), '满15人包邮', '1. 随机出角色\n2. 定金不退\n3. 收到后24小时内确认', 'u_3,u_4,u_6,u_8', 'recruiting');

-- ========== 用户拼团进度 ==========
INSERT IGNORE INTO user_group_buy_progress (user_id, group_buy_id, has_paid_deposit, waiting_for_supplement, shipped, received) VALUES
('u_current', 'gb_1', 1, 0, 0, 0),
('u_current', 'gb_3', 1, 0, 0, 0);

-- ========== 帖子 ==========
INSERT IGNORE INTO posts (id, author_id, content, image_urls, type, created_at, like_count, comment_count) VALUES
('post_1', 'u_6', '终于收到了！钟离C服还原度超高，做工很精细，满意！😍\n#晒单 #原神 #钟离', '', 'showOff', DATE_SUB(NOW(), INTERVAL 3 HOUR), 45, 12),
('post_2', 'u_3', '避雷⚠️ 这家店发的吧唧有明显划痕还不承认，大家注意避开。\n#避雷 #吧唧', '', 'avoidPit', DATE_SUB(NOW(), INTERVAL 1 DAY), 32, 18),
('post_3', 'u_7', '求一个五条悟的C服，M码，预算500以内，有出的联系我🙏\n#换谷 #咒术回战', '', 'tradeRequest', DATE_SUB(NOW(), INTERVAL 8 HOUR), 8, 3),
('post_4', 'u_4', '漫展战利品展示！今天收了好多好谷，开心到飞起✨\n#晒单 #漫展 #收获', '', 'showOff', DATE_SUB(NOW(), INTERVAL 2 DAY), 67, 21);

-- ========== 收藏 ==========
INSERT IGNORE INTO favorites (user_id, product_id) VALUES
('u_current', 'p_1'),
('u_current', 'p_7');

-- ========== 消息 ==========
INSERT IGNORE INTO messages (id, from_user_id, to_user_id, content, created_at, is_read) VALUES
('msg_1', 'u_1', 'u_current', '亲，这款吧唧是现货哦，下单后24小时内发货～', DATE_SUB(NOW(), INTERVAL 30 MINUTE), 0),
('msg_2', 'u_2', 'u_current', '最近单量大，工期可能会延长到35天左右，可以接受吗？', DATE_SUB(NOW(), INTERVAL 2 HOUR), 0),
('msg_3', 'u_6', 'u_current', '这件大衣我保养得不错，实物基本没有明显瑕疵。', DATE_SUB(NOW(), INTERVAL 1 DAY), 0);

SET FOREIGN_KEY_CHECKS = 1;