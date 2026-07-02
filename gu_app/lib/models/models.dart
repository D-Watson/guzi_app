// SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft
/// 数据模型定义

// ========== 枚举扩展 ==========
extension TradeTypeX on TradeType {
  String get value => switch (this) {
        TradeType.fixedPrice => 'fixedPrice',
        TradeType.depositFinal => 'depositFinal',
        TradeType.groupBuy => 'groupBuy',
      };

  static TradeType fromString(String s) => switch (s) {
        'fixedPrice' => TradeType.fixedPrice,
        'depositFinal' => TradeType.depositFinal,
        'groupBuy' => TradeType.groupBuy,
        _ => TradeType.fixedPrice,
      };
}

extension ConditionX on Condition {
  String get value => switch (this) {
        Condition.brandNew => 'brandNew',
        Condition.likeNew => 'likeNew',
        Condition.good => 'good',
        Condition.acceptable => 'acceptable',
      };

  static Condition fromString(String s) => switch (s) {
        'brandNew' => Condition.brandNew,
        'likeNew' => Condition.likeNew,
        'good' => Condition.good,
        'acceptable' => Condition.acceptable,
        _ => Condition.brandNew,
      };
}

extension PostTypeX on PostType {
  String get value => switch (this) {
        PostType.showOff => 'showOff',
        PostType.avoidPit => 'avoidPit',
        PostType.tradeRequest => 'tradeRequest',
      };

  static PostType fromString(String s) => switch (s) {
        'showOff' => PostType.showOff,
        'avoidPit' => PostType.avoidPit,
        'tradeRequest' => PostType.tradeRequest,
        _ => PostType.showOff,
      };
}

extension GroupBuyStatusX on GroupBuyStatus {
  String get value => switch (this) {
        GroupBuyStatus.recruiting => 'recruiting',
        GroupBuyStatus.full => 'full',
        GroupBuyStatus.shipping => 'shipping',
        GroupBuyStatus.completed => 'completed',
      };

  static GroupBuyStatus fromString(String s) => switch (s) {
        'recruiting' => GroupBuyStatus.recruiting,
        'full' => GroupBuyStatus.full,
        'shipping' => GroupBuyStatus.shipping,
        'completed' => GroupBuyStatus.completed,
        _ => GroupBuyStatus.recruiting,
      };
}

extension OrderStatusX on OrderStatus {
  String get value => switch (this) {
        OrderStatus.pendingPayment => 'pendingPayment',
        OrderStatus.paid => 'paid',
        OrderStatus.shipped => 'shipped',
        OrderStatus.received => 'received',
        OrderStatus.cancelled => 'cancelled',
      };

  static OrderStatus fromString(String s) => switch (s) {
        'pendingPayment' => OrderStatus.pendingPayment,
        'paid' => OrderStatus.paid,
        'shipped' => OrderStatus.shipped,
        'received' => OrderStatus.received,
        'cancelled' => OrderStatus.cancelled,
        _ => OrderStatus.pendingPayment,
      };
}

/// 用户模型
class UserModel {
  final String id;
  final String nickname;
  final String avatarUrl;
  final double creditScore;
  final int completedOrders;
  final double goodRate;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.nickname,
    this.avatarUrl = '',
    this.creditScore = 100,
    this.completedOrders = 0,
    this.goodRate = 1.0,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: (json['avatarUrl'] as String?) ?? '',
      creditScore: (json['creditScore'] as num?)?.toDouble() ?? 100,
      completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
      goodRate: (json['goodRate'] as num?)?.toDouble() ?? 1.0,
      isVerified: (json['isVerified'] as bool?) ?? false,
    );
  }
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

  factory IPModel.fromJson(Map<String, dynamic> json) {
    return IPModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: (json['iconUrl'] as String?) ?? '',
      characters: (json['characters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// 品类
class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({required this.id, required this.name, this.icon = ''});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: (json['icon'] as String?) ?? '',
    );
  }
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
  final double price;
  final double? depositPrice;
  final double? finalPrice;
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
  final List<String> tags;
  final String? groupBuyId;
  final DateTime? finalPaymentDeadline;
  final bool isSpot;
  final bool isNew;

  // C服专属属性
  final String? sizeInfo;
  final String? productionTime;
  final List<String>? includedParts;
  final String? materialInfo;
  final String? defectsDescription;

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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['price'] as num).toDouble(),
      depositPrice: (json['depositPrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      ip: IPModel.fromJson(json['ip'] as Map<String, dynamic>),
      characterName: (json['characterName'] as String?) ?? '',
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      tradeType: TradeTypeX.fromString((json['tradeType'] as String?) ?? 'fixedPrice'),
      status: _parseStatus((json['status'] as String?) ?? 'active'),
      condition: ConditionX.fromString((json['condition'] as String?) ?? 'brandNew'),
      seller: UserModel.fromJson(json['seller'] as Map<String, dynamic>),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      salesCount: (json['salesCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      groupBuyId: json['groupBuyId'] as String?,
      finalPaymentDeadline: json['finalPaymentDeadline'] != null
          ? DateTime.tryParse(json['finalPaymentDeadline'] as String)
          : null,
      isSpot: (json['isSpot'] as bool?) ?? false,
      isNew: (json['isNew'] as bool?) ?? true,
      sizeInfo: json['sizeInfo'] as String?,
      productionTime: json['productionTime'] as String?,
      includedParts: (json['includedParts'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      materialInfo: json['materialInfo'] as String?,
      defectsDescription: json['defectsDescription'] as String?,
      sellerCompletedOrders: (json['sellerCompletedOrders'] as num?)?.toInt() ?? 0,
      sellerGoodRate: (json['sellerGoodRate'] as num?)?.toDouble() ?? 1.0,
    );
  }

  static ProductStatus _parseStatus(String s) => switch (s) {
        'active' => ProductStatus.active,
        'sold' => ProductStatus.sold,
        'paused' => ProductStatus.paused,
        _ => ProductStatus.active,
      };
}

/// 拼团模型
class GroupBuyModel {
  final String id;
  final String title;
  final IPModel ip;
  final String characterName;
  final String imageUrl;
  final String leaderId;
  final String leaderNickname;
  final int currentCount;
  final int totalCount;
  final double depositPrice;
  final double? finalPrice;
  final DateTime deadline;
  final DateTime? expectedShipDate;
  final String shippingFeeRule;
  final String rules;
  final List<String>? memberIds;
  final GroupBuyStatus status;

  GroupBuyModel({
    required this.id,
    required this.title,
    required this.ip,
    this.characterName = '',
    this.imageUrl = '',
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

  factory GroupBuyModel.fromJson(Map<String, dynamic> json) {
    return GroupBuyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      ip: IPModel.fromJson(json['ip'] as Map<String, dynamic>),
      characterName: (json['characterName'] as String?) ?? '',
      imageUrl: (json['imageUrl'] as String?) ?? '',
      leaderId: json['leaderId'] as String,
      leaderNickname: json['leaderNickname'] as String,
      currentCount: (json['currentCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      depositPrice: (json['depositPrice'] as num).toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      deadline: DateTime.parse(json['deadline'] as String),
      expectedShipDate: json['expectedShipDate'] != null
          ? DateTime.tryParse(json['expectedShipDate'] as String)
          : null,
      shippingFeeRule: (json['shippingFeeRule'] as String?) ?? 'AA制',
      rules: (json['rules'] as String?) ?? '',
      memberIds: (json['memberIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      status: GroupBuyStatusX.fromString((json['status'] as String?) ?? 'recruiting'),
    );
  }
}

enum GroupBuyStatus {
  recruiting,
  full,
  shipping,
  completed,
}

/// 用户拼团进度
class UserGroupBuyProgress {
  final String groupBuyId;
  final String title;
  final GroupBuyStatus status;
  final bool hasPaidDeposit;
  final bool waitingForSupplement;
  final bool shipped;
  final bool received;

  UserGroupBuyProgress({
    required this.groupBuyId,
    required this.title,
    this.status = GroupBuyStatus.recruiting,
    this.hasPaidDeposit = false,
    this.waitingForSupplement = false,
    this.shipped = false,
    this.received = false,
  });

  factory UserGroupBuyProgress.fromJson(Map<String, dynamic> json) {
    return UserGroupBuyProgress(
      groupBuyId: json['groupBuyId'] as String,
      title: (json['title'] as String?) ?? '',
      status: GroupBuyStatusX.fromString((json['status'] as String?) ?? 'recruiting'),
      hasPaidDeposit: (json['hasPaidDeposit'] as bool?) ?? false,
      waitingForSupplement: (json['waitingForSupplement'] as bool?) ?? false,
      shipped: (json['shipped'] as bool?) ?? false,
      received: (json['received'] as bool?) ?? false,
    );
  }
}

/// 社区帖子
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

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      type: PostTypeX.fromString((json['type'] as String?) ?? 'showOff'),
      createdAt: DateTime.parse(json['createdAt'] as String),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
    );
  }
}

enum PostType {
  showOff,
  avoidPit,
  tradeRequest,
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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      fromUser: UserModel.fromJson(json['fromUser'] as Map<String, dynamic>),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: (json['isRead'] as bool?) ?? false,
    );
  }
}

/// 订单状态
enum OrderStatus {
  pendingPayment,
  paid,
  shipped,
  received,
  cancelled,
}

/// 订单模型
class OrderModel {
  final String id;
  final String productId;
  final String productTitle;
  final double productPrice;
  final String productImageUrl;
  final String tradeTypeLabel;
  final double? depositAmount;
  final double totalAmount;
  final int quantity;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    this.productImageUrl = '',
    this.tradeTypeLabel = '一口价',
    this.depositAmount,
    required this.totalAmount,
    this.quantity = 1,
    this.status = OrderStatus.pendingPayment,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productImageUrl: (json['productImageUrl'] as String?) ?? '',
      tradeTypeLabel: (json['tradeTypeLabel'] as String?) ?? '一口价',
      depositAmount: (json['depositAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      status: OrderStatusX.fromString((json['status'] as String?) ?? 'pendingPayment'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}