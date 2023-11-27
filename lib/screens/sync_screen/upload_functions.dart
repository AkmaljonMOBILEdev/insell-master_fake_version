import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/sync_screen/syn_enums.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../database/model/trade_dto.dart';
import '../../database/model/trade_product_dto.dart';
import '../../services/https_services.dart';

class UploadFunctions {
  final MyDatabase database;
  final Map<String, dynamic> progress;
  final void Function(VoidCallback fn) setter;
  Storage storage = Storage();

  UploadFunctions({required this.database, required this.progress, required this.setter});

  progressCallback(int count, int? total, String field, {String? status = 'Serverga yuklanmoqda...'}) {
    setter(() {
      progress[field] = {
        'total': total,
        'current': count,
        'status': status,
        'isFinished': status == 'Yuklandi',
        'isActivate': status == 'Serverga yuklanmoqda...',
      };
    });
  }

  Future<bool> connectionMode() async {
    String? mode = await storage.read("online");
    return mode == "on";
  }

  uploadSessions(String field) async {
    progressCallback(0, null, field, status: 'Baza tekshirilmoqda...');
    List<PosSessionData> allSessions = await database.posSessionDao.getAllPosSessionsUnSynced();
    for (PosSessionData session in allSessions) {
      Map<String, dynamic> request = {
        "posId": session.pos,
        "cashierId": session.cashier,
        "startTime": session.startTime?.millisecondsSinceEpoch,
        "endTime": session.endTime?.millisecondsSinceEpoch,
        "sessionStartNote": session.sessionStartNote,
        "sessionEndNote": session.sessionEndNote,
      };
      http.Response responseStart;
      if (session.serverId != null && session.endTime != null) {
        responseStart = await HttpServices.post('/pos-session/end', request);
      } else {
        responseStart = await HttpServices.post('/pos-session/start', request);
      }
      if (responseStart.statusCode != 200) {
        progressCallback(0, null, field, status: 'Server bilan bog\'lanishda xatolik yuz berdi');
        return;
      }
      var responseStartJson = jsonDecode(responseStart.body);
      await database.posSessionDao.updatePosSessionByCompanion(PosSessionCompanion(
        serverId: toValue(responseStartJson['id']),
        id: toValue(session.id),
        syncedAt: toValue(DateTime.now()),
        updatedAt: toValue(DateTime.now()),
        isSynced: toValue(true),
        createdAt: toValue(session.createdAt),
        startTime: toValue(session.startTime),
        pos: toValue(session.pos),
        cashier: toValue(session.cashier),
        endTime: toValue(session.endTime),
        sessionStartNote: toValue(session.sessionStartNote),
        sessionEndNote: toValue(session.sessionEndNote),
      ));
      progressCallback(allSessions.indexOf(session) + 1, allSessions.length, field, status: 'Serverga yuklanmoqda...');
    }
    progressCallback(1, 1, field, status: 'Yuklandi');
  }

  uploadCategories(String field) async {
    progressCallback(0, null, field, status: 'Baza tekshirilmoqda...');
    List<CategoryData> unSyncedCategories = await database.categoryDao.getAllUnsyncedCategories();
    for (CategoryData category in unSyncedCategories) {
      int? parentId = category.parentId;
      if (parentId != null) {
        CategoryData parentCategory = await database.categoryDao.getById(parentId);
        parentId = parentCategory.serverId;
      }
      Map<String, dynamic> request = {
        "name": category.name,
        "description": category.description,
        "code": category.code,
        "parentId": parentId,
      };
      http.Response response;
      if (category.serverId != null) {
        response = await HttpServices.put('/category/${category.serverId}', request);
      } else {
        response = await HttpServices.post('/category/create', request);
      }
      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        progressCallback(0, null, field, status: 'Server bilan bog\'lanishda xatolik yuz berdi');
        throw response.body;
      }
      var responseJson = jsonDecode(response.body);
      await database.categoryDao.updateCategoryByCompanion(CategoryCompanion(
        id: toValue(category.id),
        serverId: toValue(responseJson['id']),
        updatedAt: toValue(DateTime.now()),
        isSynced: toValue(true),
        isSyncedAt: toValue(DateTime.now()),
        name: toValue(category.name),
        createdAt: toValue(category.createdAt),
        code: toValue(responseJson['code']),
        groupCode: toValue(responseJson['groupCode']),
      ));
      progressCallback(unSyncedCategories.indexOf(category) + 1, unSyncedCategories.length, field,
          status: 'Serverga yuklanmoqda...');
    }
    progressCallback(1, 1, field, status: 'Yuklandi');
  }

  uploadRegions(String field) async {
    progressCallback(0, null, field, status: 'Baza tekshirilmoqda...');
    List<RegionData> unSyncedCategories = await database.regionDao.getAllUnsyncedRegions();
    for (RegionData region in unSyncedCategories) {
      int? parentId = region.parentId;
      if (parentId != null) {
        RegionData parentCategory = await database.regionDao.getById(parentId);
        parentId = parentCategory.serverId;
      }
      Map<String, dynamic> request = {
        "name": region.name,
        "parentId": parentId,
        "code": region.code,
        "type": region.type?.name ?? "COUNTRY",
      };
      http.Response response;
      if (region.serverId != null) {
        response = await HttpServices.put('/region/${region.serverId}', request);
      } else {
        response = await HttpServices.post('/region/create', request);
      }
      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        progressCallback(0, null, field, status: 'Server bilan bog\'lanishda xatolik yuz berdi');
        throw response.body;
      }
      var responseJson = jsonDecode(response.body);
      await database.regionDao.updateRegion(region.copyWith(
        serverId: toValue(responseJson['id']),
        updatedAt: (DateTime.now()),
        isSynced: toValue(true),
        syncedAt: toValue(DateTime.now()),
      ));
      progressCallback(unSyncedCategories.indexOf(region) + 1, unSyncedCategories.length, field,
          status: 'Serverga yuklanmoqda...');
    }
    progressCallback(1, 1, field, status: 'Yuklandi');
  }

  uploadProducts(String field) async {
    try {
      progressCallback(0, null, field, status: 'Baza tekshirilmoqda...');
      List<ProductDTO> unSyncedProducts = await database.productDao.getAllUnSyncedProducts();
      for (ProductDTO product in unSyncedProducts) {
        CategoryData category = await database.categoryDao.getById(product.productData.categoryId ?? -1);
        Map<String, dynamic> request = {
          "name": product.productData.name,
          "code": product.productData.code,
          "description": product.productData.description,
          "weight": product.productData.weight,
          "volume": product.productData.volume,
          "vendorCode": product.productData.vendorCode,
          "unit": product.productData.unit,
          "barcodes": product.barcodes.map((barcode) => barcode.barcode).toList(),
          "productsInBox": product.productData.productsInBox,
          "categoryId": category.serverId,
          "productKits": product.productsKit
              ?.map((productKit) => {
                    "amount": productKit.productKit.amount,
                    "productId": productKit.product.productData.serverId,
                    "price": productKit.productKit.price,
                  })
              .toList(),
          "seasonsIds": product.seasons.map((season) => season.serverId).toList(),
          "valueAddedTax": product.productData.valueAddedTax,
          "kit": product.productData.isKit,
        };
        http.Response response;
        if (product.productData.serverId != null) {
          response = await HttpServices.put('/product/${product.productData.serverId}', request);
        } else {
          response = await HttpServices.post('/product/create', request);
        }
        if (!(response.statusCode == 200 || response.statusCode == 201)) {
          progressCallback(0, null, field, status: 'Server bilan bog\'lanishda xatolik yuz berdi');
          return;
        }
        var responseJson = jsonDecode(response.body);
        await database.productDao.updateWithReplace(ProductCompanion(
          id: toValue(product.productData.id),
          serverId: toValue(responseJson['id']),
          isSynced: toValue(true),
          syncedAt: toValue(DateTime.now()),
          updatedAt: toValue(DateTime.now()),
          name: toValue(product.productData.name),
          unit: toValue(product.productData.unit),
          createdAt: toValue(product.productData.createdAt),
          code: toValue(responseJson['code']),
          vendorCode: toValue(responseJson['vendorCode']),
          isKit: toValue(responseJson['kit']),
          description: toValue(product.productData.description ?? ''),
          volume: toValue(product.productData.volume ?? ''),
          weight: toValue(product.productData.weight ?? ''),
          barcode: toValue(product.productData.barcode),
          categoryId: toValue(category.id),
          valueAddedTax: toValue(product.productData.valueAddedTax),
        ));
        progressCallback(unSyncedProducts.indexOf(product) + 1, unSyncedProducts.length, field,
            status: 'Serverga yuklanmoqda...');
      }
      progressCallback(1, 1, field, status: 'Yuklandi');
    } catch (e) {
      progressCallback(0, null, field, status: 'Xatolik yuz berdi: $e');
    }
  }

  uploadCustomers(String field) async {
    progressCallback(0, null, field, status: 'Baza tekshirilmoqda...');
    List<ClientData> allCustomers = await database.clientDao.getAllPosCustomersUnSynced();
    for (ClientData client in allCustomers) {
      Map<String, dynamic> request = {
        "name": client.name,
        "address": client.address,
        "phoneNumber": client.phoneNumber1,
        "phoneNumber2": client.phoneNumber2,
        "gender": client.gender,
        "organizationName": client.organizationName,
        "description": client.description,
        "regionId": client.regionId,
        'clientCurrency': client.clientCurrency?.name,
      };
      http.Response response;
      if (client.serverId != null) {
        response = await HttpServices.put('/client/${client.serverId}', request);
      } else {
        response = await HttpServices.post('/client/create', request);
      }
      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        progressCallback(0, null, field, status: 'Server bilan bog\'lanishda xatolik yuz berdi');
        return;
      }
      var responseJson = jsonDecode(response.body);
      await database.clientDao.updateClientByCompanion(ClientCompanion(
        serverId: toValue(responseJson['id']),
        id: toValue(client.id),
        syncedAt: toValue(DateTime.now()),
        updatedAt: toValue(DateTime.now()),
        isSynced: toValue(true),
        name: toValue(client.name),
        gender: toValue(client.gender),
        createdAt: toValue(client.createdAt),
        code: toValue(responseJson['code']),
      ));
      progressCallback(allCustomers.indexOf(client) + 1, allCustomers.length, field, status: 'Serverga yuklanmoqda...');
    }
    progressCallback(1, 1, field, status: 'Yuklandi');
  }

  uploadTrades(String field) async {
    try {
      progressCallback(0, null, field, status: 'Baza tekshirilmoqda...');
      autoUpload(UploadTypes.CUSTOMERS);
      List<TradeDTO> allTrades = await database.tradeDao.getAllUnSynced();
      for (TradeDTO tradeElement in allTrades) {
        int? clientId = tradeElement.trade.clientId;
        if (clientId != null) {
          await uploadCustomers("customers");
          ClientData client = await database.clientDao.getById(clientId);
          if (client.serverId == null) {
            return;
          }
          clientId = client.serverId;
        }
        Map<String, dynamic> request = {
          "clientId": clientId,
          "description": tradeElement.trade.description,
          "discount": tradeElement.trade.discount,
          "transactions": tradeElement.invoices
              .map((invoice) => {
                    "amount": invoice.amount,
                    "description": invoice.description,
                    "payType": invoice.payType.name,
                  })
              .toList(),
          "productsInTrade": tradeElement.tradeProducts
              .map((productInTrade) => {
                    "productId": productInTrade.product.productData.serverId,
                    "amount": productInTrade.tradeProduct.amount,
                    "price": productInTrade.tradeProduct.price,
                    "discount": productInTrade.tradeProduct.discount,
                  })
              .toList(),
          "createdTime": tradeElement.trade.finishedAt?.millisecondsSinceEpoch,
          "refund": tradeElement.trade.refund,
          "return": tradeElement.trade.isReturned,
          "returnedMoney": tradeElement.trade.returnedMoney,
          "returnedProductsIncome": tradeElement.trade.returnedProductsIncome,
        };
        http.Response response;
        if (tradeElement.trade.serverId != null) {
          response = await HttpServices.put('/trade/${tradeElement.trade.serverId}', request);
        } else {
          response = await HttpServices.post('/trade/${tradeElement.trade.isReturned ? "return" : "create"}', request);
        }
        if (!(response.statusCode == 200 || response.statusCode == 201)) {
          progressCallback(0, null, field, status: 'Server bilan bog\'lanishda xatolik yuz berdi');
          return;
        }
        var responseJson = jsonDecode(response.body);
        // ===================================PRODUCTS IN TRADE===================================
        var products = responseJson['productsInTrade'];
        List<TradeProductDto> tradeProducts = tradeElement.tradeProducts;
        for (var i = 0; i < products.length; i++) {
          TradeProductDto tradeProduct =
              tradeProducts.where((element) => element.product.productData.serverId == products[i]['product']['id']).first;
          await database.tradeProductDao.replaceByData(tradeProduct.tradeProduct.copyWith(
            serverId: toValue(products[i]['id']),
            syncedAt: toValue(DateTime.now()),
            updatedAt: DateTime.now(),
            isSynced: true,
          ));
        }
        // ===================================INVOICES===================================
        var invoicesJson = responseJson['transactions'] ?? [];
        List<Transaction> invoices = tradeElement.invoices;
        for (var i = 0; i < invoicesJson.length; i++) {
          Transaction invoiceData = invoices.where((element) => element.payType.name == invoicesJson[i]['payType']).first;
          await database.transactionsDao.replaceByData(invoiceData.copyWith(
            syncedAt: toValue(DateTime.now()),
            updatedAt: DateTime.now(),
            isSynced: true,
            serverId: toValue(invoicesJson[i]['id']),
          ));
        }
        // ===================================TRADE===================================
        await database.tradeDao.replaceTrade(tradeElement.trade.copyWith(
          serverId: toValue(responseJson['id']),
          syncedAt: toValue(DateTime.now()),
          updatedAt: DateTime.now(),
          isSynced: true,
        ));
        progressCallback(allTrades.indexOf(tradeElement) + 1, allTrades.length, field, status: 'Serverga yuklanmoqda...');
      }
      progressCallback(1, 1, field, status: 'Yuklandi');
    } catch (e) {
      progressCallback(0, null, field, status: 'XATOLIK:$e');
      rethrow;
    }
  }

  getAll({required CancelToken cancelToken}) async {
    try {
      await uploadSessions('sessions');
      await uploadCategories('category');
      await uploadRegions('region');
      await uploadProducts('product');
      await uploadCustomers('customer');
      await uploadTrades('trade');
    } catch (e) {
      rethrow;
    }
  }

  autoUpload(UploadTypes type) async {
    switch (type) {
      case UploadTypes.SESSIONS:
        await uploadSessions('sessions');
        break;
      case UploadTypes.CATEGORIES:
        await uploadCategories('category');
        break;
      case UploadTypes.REGIONS:
        await uploadRegions('region');
        break;
      case UploadTypes.PRODUCTS:
        await uploadProducts('product');
        break;
      case UploadTypes.CUSTOMERS:
        await uploadCustomers('customer');
        break;
      case UploadTypes.TRADES:
        await uploadTrades('trade');
        break;
    }
  }
}
