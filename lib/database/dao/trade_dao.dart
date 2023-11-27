import 'package:drift/drift.dart';
import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/model/trade_product_data_dto.dart';
import 'package:easy_sell/database/table/trade_table.dart';
import 'package:easy_sell/utils/utils.dart';

import '../model/trade_product_dto.dart';
import '../my_database.dart';

part 'trade_dao.g.dart';

@DriftAccessor(tables: [Trade])
class TradeDao extends DatabaseAccessor<MyDatabase> with _$TradeDaoMixin {
  TradeDao(MyDatabase db) : super(db);

  // get all
  Future<List<TradeData>> getAll() => select(trade).get();

  // get all with join
  Future<List<TradeDTO>> getAllWithJoin({int? sessionId}) async {
    List<TradeDTO> result = [];
    final List<TradeData> trades = await (select(trade)
          ..where((tbl) =>
              sessionId != null ? tbl.isFinished.equals(true) & tbl.posSessionId.equals(sessionId) : tbl.isFinished.equals(true)))
        .get();
    for (TradeData trade in trades) {
      int index = trades.indexOf(trade);
      final List<TradeProductDto> tradeProducts = await db.tradeProductDao.getByTradeId(trade.id);
      final List<Transaction> invoices = await db.transactionsDao.getByTradeId(trade.id);
      result.add(TradeDTO(
          trade: trade,
          tradeProducts: tradeProducts,
          invoices: invoices,
          data: tradeProducts
              .map((e) => TradeProductDataDto(
                    productId: e.product.productData.id,
                    amount: e.tradeProduct.amount,
                    index: index,
                    unit: e.product.productData.unit,
                    price: e.tradeProduct.price,
                    priceName: 'RETAIL',
                  ))
              .toList()));
    }
    return result;
  }

  // get all not finished
  Future<List<TradeData>> getAllNotFinished() =>
      (select(trade)..where((t) => t.isFinished.equals(false) & t.isReturned.equals(false) & t.isCanceled.equals(false))).get();

  // get by id
  Future<TradeData> getById(int id) => (select(trade)..where((t) => t.id.equals(id))).getSingle();

  // create
  Future<TradeData> createTrade(TradeCompanion newTrade) async {
    int id = await into(trade).insert(newTrade);
    return getById(id);
  }

  // cancel trade
  Future<void> cancelTrade(int id) async {
    await (update(trade)..where((t) => t.id.equals(id))).write(const TradeCompanion(isCanceled: Value(true)));
  }

  // close trade
  Future<void> closeTrade(int id, int? clientId, {double? discount, double? refund}) async {
    PosSessionData? currentSession = await db.posSessionDao.getLastSession();
    if (currentSession == null) throw Exception("No session found");
    await (update(trade)..where((t) => t.id.equals(id))).write(
      TradeCompanion(
        clientId: Value(clientId),
        isFinished: const Value(true),
        finishedAt: Value(DateTime.now()),
        discount: Value(discount),
        refund: Value(refund),
        posSessionId: Value(currentSession.id),
      ),
    );
  }

  // return trade
  Future<void> returnTrade(
    int id, {
    Map? additional,
  }) async {
    bool returnedMoney = additional != null ? additional['returnedMoney'] : true;
    bool returnedProductsIncome = additional != null ? additional['returnedProductsIncome'] : true;
    int? clientId = additional != null ? additional['clientId'] : 0;
    await (update(trade)..where((t) => t.id.equals(id))).write(TradeCompanion(
      isReturned: const Value(true),
      returnedMoney: Value(returnedMoney),
      returnedProductsIncome: Value(returnedProductsIncome),
      updatedAt: Value(DateTime.now()),
      finishedAt: Value(DateTime.now()),
      isFinished: const Value(true),
      clientId: Value(clientId),
    ));
  }

  // update trade
  Future<int> updateTradeByJson(int id, Map<String, dynamic> json) async {
    TradeData tradeData = await getById(id);
    return await (update(trade)..where((t) => t.id.equals(id))).write(tradeData.copyWith(
      serverId: toValue(json['id']),
      isSynced: true,
      syncedAt: toValue(DateTime.now()),
      updatedAt: DateTime.now(),
    ));
  }

  Future<bool> isFinished(int tradeId) {
    return (select(trade)..where((t) => t.id.equals(tradeId))).getSingle().then((value) => value.isFinished);
  }

  Future<List<TradeDTO>> getTradesByPosSessionId(
    int possessionId, {
    bool desc = false,
  }) async {
    List<TradeDTO> result = [];
    final List<TradeData> trades = await (select(trade)
          ..orderBy([(t) => OrderingTerm(expression: t.id, mode: desc ? OrderingMode.desc : OrderingMode.asc)])
          ..where((tbl) => tbl.posSessionId.equals(possessionId) & tbl.isFinished.equals(true)))
        .get();
    for (TradeData trade in trades) {
      int index = trades.indexOf(trade);
      final List<TradeProductDto> tradeProducts = await db.tradeProductDao.getByTradeId(trade.id);
      final List<Transaction> invoices = await db.transactionsDao.getByTradeId(trade.id);
      result.add(TradeDTO(
          trade: trade,
          tradeProducts: tradeProducts,
          invoices: invoices,
          data: tradeProducts
              .map((e) => TradeProductDataDto(
                    productId: e.product.productData.id,
                    amount: e.tradeProduct.amount,
                    index: index,
                    unit: e.product.productData.unit,
                    price: e.tradeProduct.price,
                    priceName: 'RETAIL',
                  ))
              .toList()));
    }
    return result;
  }

  Future<void> tradeTransaction(Future Function() callbackTransaction) async {
    try {
      transaction(() => callbackTransaction());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TradeDTO>> getTradeByClientId(int clientId, {DateTime? at}) async {
    List<TradeDTO> result = [];
    at ??= DateTime(2000);
    final List<TradeData> trades = await (select(trade)
          ..where((tbl) => tbl.clientId.equals(clientId) & tbl.isFinished.equals(true) & tbl.finishedAt.isBiggerThanValue(at!)))
        .get();
    for (TradeData trade in trades) {
      int index = trades.indexOf(trade);
      final List<TradeProductDto> tradeProducts = await db.tradeProductDao.getByTradeId(trade.id);
      final List<Transaction> invoices = await db.transactionsDao.getByTradeId(trade.id);
      result.add(TradeDTO(
          trade: trade,
          tradeProducts: tradeProducts,
          invoices: invoices,
          data: tradeProducts
              .map((e) => TradeProductDataDto(
                    productId: e.product.productData.id,
                    amount: e.tradeProduct.amount,
                    index: index,
                    unit: e.product.productData.unit,
                    price: e.tradeProduct.price,
                    priceName: 'RETAIL',
                  ))
              .toList()));
    }
    return result;
  }

  Future<List<TradeDTO>> getAllUnSynced() async {
    List<TradeDTO> result = [];
    final List<TradeData> trades = await (select(trade)
          ..where((tbl) => (tbl.syncedAt.isNull() | tbl.isSynced.equals(false)) & tbl.isFinished.equals(true)))
        .get();
    for (TradeData trade in trades) {
      int index = trades.indexOf(trade);
      final List<TradeProductDto> tradeProducts = await db.tradeProductDao.getByTradeId(trade.id);
      final List<Transaction> invoices = await db.transactionsDao.getByTradeId(trade.id);
      result.add(TradeDTO(
          trade: trade,
          tradeProducts: tradeProducts,
          invoices: invoices,
          data: tradeProducts
              .map((e) => TradeProductDataDto(
                    productId: e.product.productData.id,
                    amount: e.tradeProduct.amount,
                    index: index,
                    unit: e.product.productData.unit,
                    price: e.tradeProduct.price,
                    priceName: 'RETAIL',
                  ))
              .toList()));
    }
    return result;
  }

  // replace
  Future<void> replaceTrade(TradeData tradeData) async {
    await update(trade).replace(tradeData);
  }

  Future<void> setClient(int tradeId, ClientData? client) async {
    await (update(trade)..where((t) => t.id.equals(tradeId))).write(TradeCompanion(
      clientId: Value(client?.id),
    ));
  }

  Future<TradeData?> getByServerId(int serverId) {
    return (select(trade)..where((t) => t.serverId.equals(serverId))).getSingleOrNull();
  }

  Future<bool> updateTrade(TradeData copyWith) async {
    return update(trade).replace(copyWith);
  }

  Future<void> deleteTradeByServerId(int serverId) async {
    // find trade
    TradeData? tradeData = await getByServerId(serverId);
    if (tradeData != null) {
      // delete transactions
      await db.transactionsDao.deleteByTradeId(tradeData.id);
      // delete trade products
      await db.tradeProductDao.deleteByTradeId(tradeData.id);
      // delete trade
      await (delete(trade)..where((t) => t.id.equals(tradeData.id))).go();
    }
  }
}
