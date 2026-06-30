/// 用户模型
class UserModel {
  final String id;
  final String nickname;
  final String avatarUrl;
  final double creditScore; // 信用分
  final int completedOrders; // 历史成交数
  final double goodRate; // 好评率
  final bool isVerified; // 是否实名认证

  UserModel({
    required this.id,
    required this.nickname,
    this.avatarUrl = '',
    this.creditScore = 100,
    this.completedOrders = 0,
    this.goodRate = 1.0,
    this.isVerified = false,
  });
}

/// IP 作品
class IPModel {
  final String id;
  final String name;
  final String iconUrl;
  final List<String> characters;

  IPModel({
    required this.id,
    required this.name,
    this.iconUrl = '',
    this.characters = const [],
  });
}

/// 品类
class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({required this.id, required this.name, this.icon = ''});
}

/// 交易方式
enum TradeType { fixedPrice, depositFinal, groupBuy }

/// 商品状态
enum ProductStatus { active, sold, paused }

/// 商品新旧程度
enum Condition { brandNew, likeNew, good, acceptable }

/// 商品模型
class ProductModel {
  final String id;
  final String title;
  final List<String> imageUrls;
  final double price; // 现货价
  final double? depositPrice; // 定金价（定金尾款模式）
  final double? finalPrice; // 尾款价
  final IPModel ip;
  final String characterName;
  final CategoryModel category;
  final TradeType tradeType;
  final ProductStatus status;
  final Condition condition;
  final UserModel seller;
  final double rating;
  final int salesCount;
  final int favoriteCount;
  final List<String> tags; // 标签：现货、定金、拼团中、C服、全新等
  final String? groupBuyId; // 关联拼团ID
  final DateTime? finalPaymentDeadline; // 尾款截止时间
  final bool isSpot; // 是否现货
  final bool isNew; // 是否全新

  // C服专属属性
  final String? sizeInfo; // 尺码表
  final String? productionTime; // 工期说明
  final List<String>? includedParts; // 包含配件清单
  final String? materialInfo; // 材质说明
  final String? defectsDescription; // 瑕疵说明

  // 卖家信用
  final int sellerCompletedOrders;
  final double sellerGoodRate;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.price,
    this.depositPrice,
    this.finalPrice,
    required this.ip,
    this.characterName = '',
    required this.category,
    this.tradeType = TradeType.fixedPrice,
    this.status = ProductStatus.active,
    this.condition = Condition.brandNew,
    required this.seller,
    this.rating = 5.0,
    this.salesCount = 0,
    this.favoriteCount = 0,
    this.tags = const [],
    this.groupBuyId,
    this.finalPaymentDeadline,
    this.isSpot = false,
    this.isNew = true,
    this.sizeInfo,
    this.productionTime,
    this.includedParts,
    this.materialInfo,
    this.defectsDescription,
    this.sellerCompletedOrders = 0,
    this.sellerGoodRate = 1.0,
  });
}

/// 拼团模型
class GroupBuyModel {
  final String id;
  final String title;
  final IPModel ip;
  final String characterName;
  final String leaderId;
  final String leaderNickname;
  final int currentCount; // 已上车人数
  final int totalCount; // 目标人数
  final double depositPrice; // 定金
  final double? finalPrice; // 尾款（如有）
  final DateTime deadline; // 截团时间
  final DateTime? expectedShipDate; // 预计发货时间
  final String shippingFeeRule; // 邮费说明
  final String rules; // 团规
  final List<String>? memberIds; // 团员ID列表
  final GroupBuyStatus status;

  GroupBuyModel({
    required this.id,
    required this.title,
    required this.ip,
    this.characterName = '',
    required this.leaderId,
    required this.leaderNickname,
    required this.currentCount,
    required this.totalCount,
    required this.depositPrice,
    this.finalPrice,
    required this.deadline,
    this.expectedShipDate,
    this.shippingFeeRule = 'AA制',
    this.rules = '',
    this.memberIds,
    this.status = GroupBuyStatus.recruiting,
  });
}

enum GroupBuyStatus {
  recruiting, // 招募中
  full, // 已满员
  shipping, // 发货中
  completed, // 已完成
}

/// 用户拼团进度
class UserGroupBuyProgress {
  final String groupBuyId;
  final String title;
  final GroupBuyStatus status;
  final bool hasPaidDeposit; // 已支付定金
  final bool waitingForSupplement; // 等待团长补款
  final bool shipped; // 已发货
  final bool received; // 已收货

  UserGroupBuyProgress({
    required this.groupBuyId,
    required this.title,
    this.status = GroupBuyStatus.recruiting,
    this.hasPaidDeposit = false,
    this.waitingForSupplement = false,
    this.shipped = false,
    this.received = false,
  });
}

/// 社区帖子（晒单、避雷、换谷需求）
class PostModel {
  final String id;
  final UserModel author;
  final String content;
  final List<String> imageUrls;
  final PostType type;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final ProductModel? relatedProduct;

  PostModel({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrls = const [],
    this.type = PostType.showOff,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.relatedProduct,
  });
}

enum PostType {
  showOff, // 晒单
  avoidPit, // 避雷
  tradeRequest, // 换谷需求
}

/// 聊天消息
class MessageModel {
  final String id;
  final UserModel fromUser;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.fromUser,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });
}