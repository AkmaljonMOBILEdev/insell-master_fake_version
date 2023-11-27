import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/model/transactions_dto.dart';

class InvoiceDataStruct extends Base {
  double amount;
  String? description;
  CurrencyDataStruct currency;
  bool paid;
  List<FundDataStruct> funds;

  InvoiceDataStruct({
    required this.amount,
    required this.description,
    required this.currency,
    required this.paid,
    required this.funds,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static InvoiceDataStruct fromJson(Map<String, dynamic> map) {
    List<FundDataStruct> funds = [];
    map['funds'].forEach((e) {
      funds.add(FundDataStruct.fromJson(e));
    });
    return InvoiceDataStruct(
      amount: map['amount'],
      description: map['description'],
      currency: CurrencyDataStruct.fromJson(map['currency']),
      paid: map['paid'],
      funds: funds,
      id: map['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'currency': currency.toJson(),
      'paid': paid,
      'funds': funds.map((e) => e.toJson()).toList(),
      'id': id,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}

class FundDataStruct extends Base {
  double amount;
  TransactionDataStruct transaction;

  FundDataStruct({
    required this.amount,
    required this.transaction,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static FundDataStruct fromJson(Map<String, dynamic> map) {
    return FundDataStruct(
      amount: map['amount'],
      transaction: TransactionDataStruct.fromJson(map['transaction']),
      id: map['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'transaction': transaction.toJson(),
      'id': id,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}
