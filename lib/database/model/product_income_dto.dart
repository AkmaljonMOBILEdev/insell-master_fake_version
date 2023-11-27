import 'package:easy_sell/database/model/product_dto.dart';

import '../table/product_income_table.dart';

class ProductIncomeDTO {
  int id;
  bool isSynced;
  DateTime? syncedAt;
  DateTime createdAt;
  DateTime updatedAt;
  ProductDTO product;
  double price;
  double amount;
  String? description;
  DateTime? expireDate;
  bool? deleted;
  int? serverId;
  ProductIncomeCurrency? currency;

  ProductIncomeDTO(
      {required this.id,
      required this.isSynced,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.product,
      required this.price,
      required this.amount,
      this.description,
      this.expireDate,
      this.deleted,
      this.currency = ProductIncomeCurrency.USD,
      this.serverId});

  factory ProductIncomeDTO.fromJson(Map<String, dynamic> json) {
    return ProductIncomeDTO(
        id: json["id"],
        isSynced: json["isSynced"],
        syncedAt: json["syncedAt"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        product: json["product"],
        price: json["price"],
        amount: json["amount"],
        description: json["description"],
        expireDate: json["expireDate"],
        deleted: json["deleted"],
        serverId: json["serverId"],
        currency: ProductIncomeCurrency.fromString(json['currency']),
      );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "isSynced": isSynced,
      "syncedAt": syncedAt,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "productId": product,
      "price": price,
      "amount": amount,
      "description": description,
      "expireDate": expireDate,
      "deleted": deleted,
      "serverId": serverId,
      'currency': currency?.name,
    };
  }
}
