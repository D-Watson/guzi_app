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

-- ========== Banner ==========
INSERT IGNORE INTO banners (id, image_url, title, subtitle, sort_order) VALUES
('banner_1', '', '夏日动漫嘉年华 · 预热开启', '漫展专场低至8折', 0),
('banner_2', '', '原神 · 新角色C服预售', '纳塔系列开放预定', 1),
('banner_3', '', '拼团广场 · 热门团推荐', '排球少年吧唧拼团中', 2),
('banner_4', '', '个人闲置专场', '全新仅拆检，好价出谷', 3);

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

-- ========== 消息 ==========
INSERT IGNORE INTO messages (id, from_user_id, to_user_id, content, created_at, is_read) VALUES
('msg_1', 'u_1', 'u_current', '亲，这款吧唧是现货哦，下单后24小时内发货～', DATE_SUB(NOW(), INTERVAL 30 MINUTE), 0),
('msg_2', 'u_2', 'u_current', '最近单量大，工期可能会延长到35天左右，可以接受吗？', DATE_SUB(NOW(), INTERVAL 2 HOUR), 0),
('msg_3', 'u_6', 'u_current', '这件大衣我保养得不错，实物基本没有明显瑕疵。', DATE_SUB(NOW(), INTERVAL 1 DAY), 0);

SET FOREIGN_KEY_CHECKS = 1;