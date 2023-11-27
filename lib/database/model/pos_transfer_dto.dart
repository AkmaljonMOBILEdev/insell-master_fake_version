import 'package:drift/src/runtime/data_class.dart';
import 'package:easy_sell/database/model/shop_dto.dart';

import 'base_dto.dart';

class PosTransferDto extends Base {
  POSDataStruct? fromPos;
  POSDataStruct? toPos;
  PosTransferStatus? status;
  double amount;
  String? description;
  PayType? payType;

  PosTransferDto({
    this.fromPos,
    this.toPos,
    this.status,
    required this.amount,
    this.description,
    this.payType,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  PosTransferDto copyWith(
      {required DateTime updatedAt, required Value<DateTime> syncedAt, required Value<PosTransferStatus> status}) {
    return PosTransferDto(
      fromPos: fromPos,
      toPos: toPos,
      status: status.value,
      amount: amount,
      description: description,
      payType: payType,
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // from json
  static PosTransferDto fromJson(item) {
    return PosTransferDto(
      fromPos: item['fromPos'] != null ? POSDataStruct.fromJson(item['fromPos']) : null,
      toPos: item['toPos'] != null ? POSDataStruct.fromJson(item['toPos']) : null,
      status: PosTransferStatus.fromString(item['status']),
      amount: item['amount'],
      description: item['description'],
      payType: PayType.fromString(item['payType']),
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}

enum PosTransferStatus {
  CONFIRMED,
  CANCELED,
  CREATED;

  static PosTransferStatus fromString(String status) {
    switch (status) {
      case 'CONFIRMED':
        return CONFIRMED;
      case 'CANCELED':
        return CANCELED;
      case 'CREATED':
        return CREATED;
      default:
        return CREATED;
    }
  }
}

enum PayType {
  CASH,
  CARD,
  TRANSFER;

  static PayType fromString(String status) {
    switch (status) {
      case 'CASH':
        return CASH;
      case 'CARD':
        return CARD;
      case 'TRANSFER':
        return TRANSFER;
      default:
        return CASH;
    }
  }
}

class POSDataStruct extends Base {
  String? name;
  ShopDto? shop;
  bool? active;

  POSDataStruct({
    this.name,
    this.shop,
    this.active,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static POSDataStruct fromJson(item) {
    return POSDataStruct(
      name: item['name'],
      shop: item['shop'] != null ? ShopDto.fromJson(item['shop']) : null,
      active: item['active'],
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}
