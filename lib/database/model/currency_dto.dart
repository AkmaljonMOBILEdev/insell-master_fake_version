import 'base_dto.dart';

class CurrencyDataStruct extends Base {
  String name;
  String abbreviation;
  String symbol;
  bool defaultCurrency;

  CurrencyDataStruct({
    required int id,
    required this.name,
    required this.abbreviation,
    required this.symbol,
    required this.defaultCurrency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static CurrencyDataStruct fromJson(Map<String, dynamic> json) {
    return CurrencyDataStruct(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      symbol: json['symbol'],
      defaultCurrency: json['default'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return '$name ($abbreviation)';
  }
}
