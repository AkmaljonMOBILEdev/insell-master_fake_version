import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class TransferDto extends Base {
  ShopDto? fromShop;
  ShopDto? toShop;
  String? description;
  TransferStatus status;
  DateTime createdTime;
  List<ProductOutcome> products;

  TransferDto({
    required this.fromShop,
    required this.toShop,
    required this.description,
    required this.status,
    required this.createdTime,
    required this.products,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static TransferDto fromJson(item) {
    List<ProductOutcome> products = [];
    item['products'].forEach((e) {
      products.add(ProductOutcome.fromJson(e));
    });
    return TransferDto(
      fromShop: ShopDto.fromJson(item['fromShop']),
      toShop: ShopDto.fromJson(item['toShop']),
      description: item['description'],
      status: TransferStatus.fromString(item['status'] ?? 'PENDING'),
      createdTime: DateTime.fromMillisecondsSinceEpoch(item['createdTime']),
      products: products,
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}

enum TransferStatus {
  PENDING,
  IN_PROGRESS,
  CANCELED,
  COMPLETED;

  static TransferStatus fromString(String str) {
    switch (str) {
      case 'PENDING':
        return TransferStatus.PENDING;
      case 'IN_PROGRESS':
        return TransferStatus.IN_PROGRESS;
      case 'CANCELED':
        return TransferStatus.CANCELED;
      case 'COMPLETED':
        return TransferStatus.COMPLETED;
      default:
        return TransferStatus.PENDING;
    }
  }
}

enum TransferPriceType {
  COST,
  RETAIL,
  DISCOUNT,
  MINIMUM;
}

class ProductOutcome extends Base {
  ProductData product;
  double amount;
  String? description;
  DateTime? expiredDate;

  ProductOutcome({
    required this.product,
    required this.amount,
    this.description,
    this.expiredDate,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static fromJson(e) {
    e['product']['isKit'] = e['product']['kit'];
    e['product']['productsInBox'] = e['product']['productsInBox'].toString();
    e['product']['isSynced'] = true;
    e['product']['serverId'] = e['product']['id'];
    e['product']['valueAddedTax'] = e['product']['valueAddedTax'] ?? 0.0;
    ProductData productData = ProductData.fromJson(e['product']);
    return ProductOutcome(
      product: productData,
      amount: e['amount'],
      description: e['description'],
      expiredDate: e['expiredDate'] != null ? DateTime.fromMillisecondsSinceEpoch(e['expiredDate']) : null,
      id: e['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(e['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(e['updatedAt']),
    );
  }
}
