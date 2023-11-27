
import 'package:easy_sell/database/model/pos_dto.dart';
import 'package:easy_sell/database/model/supplier_dto.dart';

import '../my_database.dart';
import 'base_dto.dart';
import 'counter_party_dto.dart';
import 'expense_dto.dart';
import 'transactions_dto.dart';

class OutgoingDto extends Base {
  SupplierDto? supplierDto;
  RegionData? region;
  CounterPartyDto? counterparty;
  PosDto? pos;
  PosDto? toPos;
  ExpenseDto? expenseDto;
  int createdTime;
  int? amount;
  // PayType? payType;
  TransactionDataStruct? invoiceDto;
  String? description;

  OutgoingDto({
    this.supplierDto,
    this.region,
    this.pos,
    this.toPos,
    this.expenseDto,
    required this.createdTime,
    required this.amount,
    this.description,
    required super.id,
    this.invoiceDto,
    this.counterparty,
  });

  static OutgoingDto fromJson(Map<String, dynamic> map) {
    return OutgoingDto(
      supplierDto: map['supplier'] != null ? SupplierDto.fromJson(map['supplier']) : null,
      region: map['region'] != null ? RegionData.fromJson(map['region']) : null,
      counterparty: map['counterparty'] != null ? CounterPartyDto.fromJson(map['counterparty']) : null,
      pos: map['pos'] != null ? PosDto.fromJson(map['pos']) : null,
      toPos: map['toPos'] != null ? PosDto.fromJson(map['toPos']) : null,
      expenseDto: map['expense'] != null ? ExpenseDto.fromJson(map['expense']) : null,
      createdTime: map['createdAt'],
      amount: map['amount'],
      description: map['description'],
      id: map['id'],
      invoiceDto: map['invoice'] != null ? TransactionDataStruct.fromJson(map['invoice']) : null,
    );
  }
}

// enum PayType {
//   CASH,
//   CARD,
//   TRANSFER,
//   CASHBACK;
//
//   static PayType fromString(String type) {
//     switch (type) {
//       case 'CASH':
//         return PayType.CASH;
//       case 'CARD':
//         return PayType.CARD;
//       case 'TRANSFER':
//         return PayType.TRANSFER;
//       default:
//         return PayType.CASHBACK;
//     }
//   }
// }