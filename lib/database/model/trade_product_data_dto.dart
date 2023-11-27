class TradeProductDataDto {
  final int productId;
  double amount;
  final int index;
  final String unit;
  double price;
  String? priceName;

  TradeProductDataDto({
    required this.productId,
    required this.amount,
    required this.index,
    required this.unit,
    required this.price,
    this.priceName,
  });

  factory TradeProductDataDto.fromJson(Map<String, dynamic> json) {
    return TradeProductDataDto(
      productId: json['productId'],
      amount: json['amount'],
      index: json['index'],
      unit: json['unit'],
      price: json['price'],
      priceName: json['priceName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'amount': amount,
        'unit': unit,
        'price': price,
        'priceName': priceName,
      };

  TradeProductDataDto copyWith({double? amount, double? price, String? priceName}) {
    return TradeProductDataDto(
      productId: productId,
      index: index,
      unit: unit,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      priceName: priceName ?? this.priceName,
    );
  }
}
