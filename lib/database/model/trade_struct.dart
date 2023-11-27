import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/client_dto.dart';
import 'package:easy_sell/database/model/transactions_dto.dart';
import 'package:easy_sell/services/https_services.dart';
import '../my_database.dart';

class TradeStruct extends Base {
  PosSessionDto? posSession;
  ClientDto? client;
  List<TransactionDataStruct> invoices = [];
  List<ProductInTrade> productsInTrade = [];
  String? description;
  double? discount;
  double? refund;
  bool returned;
  bool? returnedMoney;
  bool? returnedProductsIncome;
  DateTime? createdTime;
  bool success;
  bool deleted;

  TradeStruct({
    required this.posSession,
    required this.client,
    required this.invoices,
    required this.productsInTrade,
    required this.description,
    required this.discount,
    required this.refund,
    required this.returned,
    required this.returnedMoney,
    required this.returnedProductsIncome,
    required this.createdTime,
    required this.success,
    required this.deleted,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  double get total => productsInTrade.fold(
        0.0,
        (previousValue, element) => previousValue + element.amount * element.price,
      );

  double get totalInvoice => invoices.fold(
        0.0,
        (previousValue, element) => previousValue + element.amount,
      );

  double get cash => invoices
      .where((element) => element.payType == PayType.CASH)
      .fold(0.0, (previousValue, element) => previousValue + element.amount);

  double get card => invoices
      .where((element) => element.payType == PayType.CARD)
      .fold(0.0, (previousValue, element) => previousValue + element.amount);

  double get bank => invoices
      .where((element) => element.payType == PayType.TRANSFER)
      .fold(0.0, (previousValue, element) => previousValue + element.amount);

  double get cashback => invoices
      .where((element) => element.payType == PayType.CASHBACK)
      .fold(0.0, (previousValue, element) => previousValue + element.amount);

  bool get isReturned => returned;

  get status => deleted
      ? 'DELETED'
      : returned
          ? 'RETURNED'
          : 'SUCCESS';

  // delete trade
  Future<bool> deleteTrade() async {
    try {
      var res = await HttpServices.delete("/trade/$id");
      if (res.statusCode == 200) {
        deleted = true;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // from json
  static TradeStruct fromJson(item) {
    List<TransactionDataStruct> invoices = [];
    item["transactions"].forEach((e) {
      invoices.add(TransactionDataStruct.fromJson(e));
    });
    List<ProductInTrade> productsInTrade = [];
    item['productsInTrade'].forEach((e) {
      productsInTrade.add(ProductInTrade.fromJson(e));
    });
    return TradeStruct(
      posSession: PosSessionDto.fromJson(item['posSession']),
      client: item['client'] != null ? ClientDto.fromJson(item['client']) : null,
      invoices: invoices,
      productsInTrade: productsInTrade,
      description: item['description'],
      discount: item['discount'],
      refund: item['refund'],
      returned: item['return'],
      returnedMoney: item['returnedMoney'],
      returnedProductsIncome: item['returnedProductsIncome'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(item['createdTime']),
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
      success: item['success'],
      deleted: item['deleted'],
    );
  }

  // to string

  @override
  String toString() {
    return 'TradeStruct(posSession: $posSession, client: $client,  invoices: $invoices, productsInTrade: $productsInTrade, description: $description, discount: $discount, refund: $refund, returned: $returned, returnedMoney: $returnedMoney, returnedProductsIncome: $returnedProductsIncome, createdTime: $createdTime)';
  }
}

class ProductInTrade extends Base {
  ProductData product;
  double amount;
  double price;
  String? priceName;
  double? discount;

  ProductInTrade({
    required this.product,
    required this.amount,
    required this.price,
    required this.priceName,
    required this.discount,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

// from json
  static ProductInTrade fromJson(item) {
    item['product']['isKit'] = item['product']['kit'];
    item['product']['productsInBox'] = item['product']['productsInBox'].toString();
    item['product']['isSynced'] = true;
    item['product']['serverId'] = item['product']['id'];
    item['product']['valueAddedTax'] = item['product']['valueAddedTax'] ?? 0.0;
    return ProductInTrade(
      product: ProductData.fromJson(item['product']),
      amount: item['amount'],
      price: item['price'],
      priceName: item['priceName'],
      discount: item['discount'],
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}

class PosSessionDto extends Base {
  POSData pos;
  EmployeeData cashier;
  DateTime? startTime;
  DateTime? endTime;
  String? sessionStartNote;
  String? sessionEndNote;

  PosSessionDto({
    required this.pos,
    required this.cashier,
    required this.startTime,
    required this.endTime,
    required this.sessionStartNote,
    required this.sessionEndNote,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static PosSessionDto fromJson(item) {
    item['pos']['isSynced'] = true;
    return PosSessionDto(
      pos: POSData.fromJson(item['pos']),
      cashier: EmployeeData.fromJson(item['cashier']),
      startTime: item['startTime'] != null ? DateTime.fromMillisecondsSinceEpoch(item['startTime']) : null,
      endTime: item['endTime'] != null ? DateTime.fromMillisecondsSinceEpoch(item['endTime']) : null,
      sessionStartNote: item['sessionStartNote'],
      sessionEndNote: item['sessionEndNote'],
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}
