import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/currency_dto.dart';

class ExchangeRateDataStruct extends Base {
  double rate;
  String? description;
  CurrencyDataStruct currency;
  CurrencyDataStruct fromCurrency;

  ExchangeRateDataStruct({
    required this.rate,
    required this.currency,
    required this.fromCurrency,
    this.description,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  ExchangeRateDataStruct copyWith({
    double? rate,
    String? description,
    int? id,
    CurrencyDataStruct? currency,
    CurrencyDataStruct? fromCurrency,
  }) {
    return ExchangeRateDataStruct(
      rate: rate ?? this.rate,
      description: description ?? this.description,
      id: id ?? this.id,
      currency: currency ?? this.currency,
      fromCurrency: fromCurrency ?? this.fromCurrency,
    );
  }

  factory ExchangeRateDataStruct.fromJson(Map<String, dynamic> json) {
    return ExchangeRateDataStruct(
      rate: json["rate"],
      description: json["description"],
      id: json["id"],
      currency: CurrencyDataStruct.fromJson(json["currency"]),
      fromCurrency: CurrencyDataStruct.fromJson(json["fromCurrency"]),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "rate": rate,
        "description": description,
        "id": id,
        "currency": currency.toJson(),
        "fromCurrency": fromCurrency.toJson(),
      };
}
