import '../my_database.dart';

class TradeProductFullStruct {
  ProductData product;
  double tradeAmount;
  double tradeSum;
  double price;
  double startAmount;
  double endAmount;
  double totalIncome;
  double totalTransfer;
  double totalReturnFromCustomer;
  double totalReturnToSupplier;
  double totalProductTrade;
  double totalWriteOff;
  double costPrice;

  TradeProductFullStruct(
      {required this.product,
      required this.tradeAmount,
      required this.tradeSum,
      required this.price,
      required this.startAmount,
      required this.endAmount,
      required this.totalIncome,
      required this.totalTransfer,
      required this.totalReturnFromCustomer,
      required this.totalReturnToSupplier,
      required this.totalProductTrade,
      required this.totalWriteOff,
      required this.costPrice});

  // from json
  static TradeProductFullStruct fromJson(item) {
    item['product']['isKit'] = item['product']['kit'];
    item['product']['productsInBox'] = item['product']['productsInBox'].toString();
    item['product']['isSynced'] = true;
    item['product']['serverId'] = item['product']['id'];
    item['product']['valueAddedTax'] = item['product']['valueAddedTax'] ?? 0.0;
    return TradeProductFullStruct(
      product: ProductData.fromJson(item['product']),
      tradeAmount: item['tradeAmount'],
      tradeSum: item['tradeSum'],
      price: item['price'],
      startAmount: item['startAmount'],
      endAmount: item['endAmount'],
      totalIncome: item['totalIncome'],
      totalTransfer: item['totalTransfer'],
      totalReturnFromCustomer: item['totalReturnFromCustomer'],
      totalReturnToSupplier: item['totalReturnToSupplier'],
      totalProductTrade: item['totalProductTrade'],
      totalWriteOff: item['totalWriteOff'],
      costPrice: item['costPrice'],
    );
  }

  // to string

  @override
  String toString() {
    return 'TradeProductFullStruct(product: $product, tradeAmount: $tradeAmount, tradeSum: $tradeSum, price: $price, startAmount: $startAmount, endAmount: $endAmount, totalIncome: $totalIncome, totalTransfer: $totalTransfer, totalReturnFromCustomer: $totalReturnFromCustomer, totalReturnToSupplier: $totalReturnToSupplier, totalProductTrade: $totalProductTrade, totalWriteOff: $totalWriteOff, costPrice: $costPrice)';
  }
}
