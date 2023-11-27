import 'base_dto.dart';
import 'currency_dto.dart';

class TransactionDataStruct extends Base {
  double amount;
  PayType payType;
  CurrencyDataStruct? currency;

  TransactionDataStruct({
    required this.amount,
    required this.payType,
    this.currency,
    required super.id,
  });

  static TransactionDataStruct fromJson(Map<String, dynamic> map) {
    return TransactionDataStruct(
      amount: map['amount'],
      payType: PayType.fromString(map['payType']),
      id: map['id'],
      currency: map['currency'] != null ? CurrencyDataStruct.fromJson(map['currency']) : null,
    );
  }
}

enum PayType {
  CASH,
  CARD,
  TRANSFER,
  CASHBACK;

  static PayType fromString(String type) {
    switch (type) {
      case 'CASH':
        return PayType.CASH;
      case 'CARD':
        return PayType.CARD;
      case 'TRANSFER':
        return PayType.TRANSFER;
      default:
        return PayType.CASHBACK;
    }
  }
}
