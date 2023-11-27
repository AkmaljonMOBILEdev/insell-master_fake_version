import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/services/storage_services.dart';
import '../../database/table/pos_table.dart';
import '../../utils/utils.dart';

class DownloadFunctions {
  final MyDatabase database;
  final void Function(VoidCallback fn) setter;
  final Map<String, dynamic> progress;

  DownloadFunctions({required this.database, required this.setter, required this.progress});

  progressCallback(int count, int? total, String field,
      {String? status = 'Serverdan yuklanmoqda...', bool? isFinished, bool? isActive}) {
    setter(() {
      progress[field] = {
        'total': total,
        'current': count,
        'status': status,
        'isFinished': isFinished ?? false,
        'isActivate': isActive,
      };
    });
  }

  getEmployee(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/employee/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        for (var item in data) {
          database.employeeDao.createEmployee(
            EmployeeData.fromJson(item).copyWith(
              serverId: toValue(item['id']),
              isSynced: toValue(true),
              syncedAt: toValue(DateTime.now()),
            ),
          );
        }
      }
    } catch (e) {
      progressCallback(0, null, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getRegions(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/region/all", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        for (var item in data) {
          database.regionDao.createRegion(RegionData.fromJson(item).copyWith(
            serverId: toValue(item['id']),
            syncedAt: toValue(DateTime.now()),
            isSynced: toValue(true),
            updatedAt: DateTime.now(),
          ));
        }
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getCategories(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/category/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        List<CategoryCompanion> categoriesCompanions = [];
        for (var item in data) {
          int? parentId = item['parentId'];
          if (parentId != null) {
            CategoryData? categoryData = await database.categoryDao.getCategoryByServerId(parentId);
            if (categoryData != null) {
              parentId = categoryData.id;
            }
          }
          CategoryCompanion newCategory = CategoryCompanion(
            serverId: toValue(item['id']),
            name: toValue(item['name']),
            code: toValue(item['code']),
            groupCode: toValue(item['groupCode']),
            description: toValue(item['description']),
            parentId: toValue(parentId),
            isSynced: toValue(true),
            isSyncedAt: toValue(DateTime.now()),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
          );
          bool isExist = await database.categoryDao.getCategoryByServerId(item['id']) != null;
          if (!isExist) {
            categoriesCompanions.add(newCategory);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Bazaga qo'shilmoqda...",
              isActive: true,
            );
          } else {
            await database.categoryDao.updateByServerIdCategory(newCategory);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Yangilanmoqda...",
              isActive: true,
            );
          }
        }
        progressCallback(0, 1, field, status: "Yangilanmoqda...");
        await database.categoryDao.batchCreateCategory(categoriesCompanions);
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getSeasons(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/season/all", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data['data'];
        List<SeasonCompanion> seasonsCompanions = [];
        for (var item in data) {
          SeasonCompanion newSeason = SeasonCompanion(
            serverId: toValue(item['id']),
            name: toValue(item['name']),
            isSynced: toValue(true),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
            endDate: toValue(DateTime.fromMillisecondsSinceEpoch(item['endDate'])),
            startDate: toValue(DateTime.fromMillisecondsSinceEpoch(item['startDate'])),
            syncedAt: toValue(DateTime.now()),
          );
          bool isExist = await database.seasonDao.checkWithServerId(item['id']);
          if (!isExist) {
            seasonsCompanions.add(newSeason);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Bazaga qo'shilmoqda...",
              isActive: true,
            );
          } else {
            await database.seasonDao.updateByServerIdCategory(newSeason);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Yangilanmoqda...",
              isActive: true,
            );
          }
        }
        progressCallback(0, 1, field, status: "Yangilanmoqda...");
        await database.seasonDao.batchCreateSeasons(seasonsCompanions);
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getSettings(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    Storage storage = Storage();
    try {
      var res = await HttpServices.get("/settings/discount/all");
      if (res.statusCode == 200) {
        await storage.write("discount_settings", res.body);
      }
      var resCashback = await HttpServices.get("/settings/cashback/all");
      if (res.statusCode == 200) {
        await storage.write("cashback_settings", resCashback.body);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getProducts(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/product/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        progressCallback(0, 0, field, status: "Boshlanmoqda...");
        var data = res.data;
        for (var item in data) {
          CategoryData? categoryData = await database.categoryDao.getCategoryByServerId(item['category']['id']);
          ProductCompanion newProductCompanion = ProductCompanion(
            serverId: toValue(item['id']),
            name: toValue(item['name']),
            code: toValue(item['code']),
            description: toValue(item['description']),
            categoryId: toValue(categoryData?.id),
            isSynced: toValue(true),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
            unit: toValue(item['unit']),
            syncedAt: toValue(DateTime.now()),
            vendorCode: toValue(item['vendorCode'] == '' ? null : item['vendorCode']),
            isKit: toValue(item['kit']),
            volume: toValue(item['volume']),
            weight: toValue(item['weight']),
            barcode: toValue(item['barcode']),
            valueAddedTax: toValue(item['valueAddedTax'] ?? 0),
          );
          bool isExist = await database.productDao.checkIfProductExistsByServerId(newProductCompanion);
          if (!isExist) {
            ProductData productData = await database.productDao.createWithCompanion(newProductCompanion);
            for (var barcode in item['productBarcodes']) {
              BarcodeCompanion newBarcode = BarcodeCompanion(
                productId: toValue(productData.id),
                barcode: toValue(barcode),
                isSynced: toValue(true),
                updatedAt: toValue(DateTime.now()),
                createdAt: toValue(DateTime.now()),
                syncedAt: toValue(DateTime.now()),
              );
              await database.barcodeDao.createBarcode(newBarcode);
            }
            var productKits = item['productKits'];
            if (productKits != null) {
              for (var productKit in productKits) {
                ProductData? productData = await database.productDao.getByServerId(productKit['product']['id']);
                if (productData != null) {
                  ProductKitCompanion newProductKit = ProductKitCompanion(
                    createdAt: toValue(DateTime.now()),
                    updatedAt: toValue(DateTime.now()),
                    amount: toValue(productKit['amount']),
                    serverId: toValue(productKit['id']),
                    syncedAt: toValue(DateTime.now()),
                    isSynced: toValue(true),
                    productId: toValue(productData.id),
                    price: toValue(productKit['price']),
                  );
                  await database.productKitDao.createProductKit(newProductKit);
                }
              }
            }
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Qo'shilmoqda...",
            );
          } else {
            await database.productDao.updateByServerId(newProductCompanion);
            ProductData? productData = await database.productDao.getByServerId(item['id']);
            for (String barcode in item['productBarcodes']) {
              BarcodeCompanion newBarcode = BarcodeCompanion(
                productId: toValue(productData?.id ?? 0),
                barcode: toValue(barcode),
                isSynced: toValue(true),
                updatedAt: toValue(DateTime.now()),
                createdAt: toValue(DateTime.now()),
                syncedAt: toValue(DateTime.now()),
              );
              bool isExist = await database.barcodeDao.checkIsExist(barcode);
              if (!isExist) {
                await database.barcodeDao.createBarcode(newBarcode);
              }
            }

            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Yangilanmoqda...",
            );
          }
        }
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getPrices(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/price/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        List<PriceCompanion> priceCompanions = [];
        for (var item in data) {
          ProductData? productData = await database.productDao.getByServerId(item['productId']);
          CurrencyTableData? currencyTableData = await database.currencyDao.getByServerId(item['id']);
          if (productData != null) {
            PriceCompanion newPriceCompanion = PriceCompanion(
              serverId: toValue(item['id']),
              productId: toValue(productData.id),
              value: toValue(item['price']),
              currencyId: toValue(currencyTableData?.id ?? -1),
              discount: toValue(item['discount']),
              isSynced: toValue(true),
              updatedAt: toValue(DateTime.now()),
              createdAt: toValue(DateTime.fromMillisecondsSinceEpoch(item['createdAt'])),
              syncedAt: toValue(DateTime.now()),
            );
            priceCompanions.add(newPriceCompanion);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Bazaga qo'shilmoqda...",
            );
          }
        }
        progressCallback(0, 1, field, status: "Yangilanmoqda...");
        await database.priceDao.batchCreatePrices(priceCompanions);
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getAllPos(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/pos/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        for (var pos in data) {
          bool exist = await database.posDao.hasPosWithServerId(pos['id']);
          POSCompanion newPos = POSCompanion(
            name: toValue(pos['name']),
            serverId: toValue(pos['id']),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
            active: toValue(pos['active']),
            isSynced: toValue(true),
            syncedAt: toValue(DateTime.now()),
            type: toValue(PosType.fromString(pos['type'])),
          );
          if (!exist) {
            await database.posDao.createPos(newPos);
          } else {
            await database.posDao.updatePos(newPos);
          }
        }
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getClients(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/client/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        List<ClientCompanion> clientsCompanions = [];
        for (var item in data) {
          ClientCompanion newClient = ClientCompanion(
            phoneNumber2: toValue(item['phoneNumber2']),
            phoneNumber1: toValue(item['phoneNumber']),
            name: toValue(item['name']),
            address: toValue(item['address']),
            code: toValue(item['code']),
            gender: toValue(item['gender']),
            regionId: toValue(item['region'] == null ? null : item['region']['id']),
            serverId: toValue(item['id']),
            isSynced: toValue(true),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
            syncedAt: toValue(DateTime.now()),
            discountCard: toValue(item['discountCard']),
            description: toValue(item['description']),
            organizationName: toValue(item['organizationName']),
            cashback: toValue(item['cashback']),
            typeId: toValue(item['typeId']),
            cashbackId: toValue(item['type']['cashbackId']),
          );
          bool isExist = await database.clientDao.checkIfClientExistsByServerId(newClient);
          if (!isExist) {
            clientsCompanions.add(newClient);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Bazaga qo'shilmoqda...",
            );
          } else {
            await database.clientDao.updateByServerId(newClient);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Yangilanmoqda...",
            );
          }
        }
        progressCallback(0, 1, field, status: "Yangilanmoqda...");
        await database.clientDao.batchCreateClients(clientsCompanions);
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getBarcodes(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/barcode/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        List<BarcodeCompanion> barcodesCompanions = [];
        for (var item in data) {
          ProductData? productData = await database.productDao.getByServerId(item['productID']);
          BarcodeCompanion newBarcode = BarcodeCompanion(
            productId: toValue(productData?.id ?? -1),
            barcode: toValue(item['barcode'].toString()),
            serverId: toValue(item['id']),
            isSynced: toValue(true),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
            syncedAt: toValue(DateTime.now()),
          );
          bool isExist = await database.barcodeDao.checkIsExist(item['barcode'].toString());
          if (!isExist) {
            barcodesCompanions.add(newBarcode);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Bazaga qo'shilmoqda...",
              isActive: true,
            );
          } else {
            await database.barcodeDao.updateByServerId(newBarcode);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Yangilanmoqda...",
              isActive: true,
            );
          }
        }
        progressCallback(0, 1, field, status: "Yangilanmoqda...", isActive: true);
        await database.barcodeDao.batchCreateBarcodes(barcodesCompanions);
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getSessions(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/pos-session/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        var data = res.data;
        for (var item in data) {
          int serverId = item['id'];
          int posServerId = item['pos']['id'];
          int cashierServerId = item['cashier']['id'];
          EmployeeData? cashier = await database.employeeDao.getByServerId(cashierServerId);
          PosSessionCompanion newPosSession = PosSessionCompanion(
            serverId: toValue(item['id']),
            isSynced: toValue(true),
            updatedAt: toValue(DateTime.now()),
            createdAt: toValue(DateTime.now()),
            syncedAt: toValue(DateTime.now()),
            sessionEndNote: toValue(item['sessionEndNote']),
            sessionStartNote: toValue(item['sessionStartNote']),
            endTime: toValue(item['endTime'] == null ? null : DateTime.fromMillisecondsSinceEpoch(item['endTime'])),
            startTime: toValue(DateTime.fromMillisecondsSinceEpoch(item['startTime'])),
            pos: toValue(posServerId),
            cashier: toValue(cashier?.id),
          );
          bool isExist = await database.posSessionDao.checkIfExistsByServerId(serverId);
          if (!isExist && cashier != null) {
            await database.posSessionDao.createPosSession(newPosSession);
            progressCallback(
              data.indexOf(item),
              data.length,
              field,
              status: "Bazaga qo'shilmoqda...",
            );
          }
        }
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getTrades(
    String field, {
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      var res = await HttpServices.getWithProgress("/trade/all/updates?fromStart=$fromStart", (int count, int total) {
        progressCallback(count, total, field, isActive: true);
      }, cancelToken: cancelToken);
      if (res.statusCode == 200) {
        List<dynamic> allTrades = res.data;
        for (var jsonData in allTrades) {
          if (jsonData['deleted'] == false) {
            TradeData? tradeData = await database.tradeDao.getByServerId(jsonData['id']);
            var posSession = jsonData['posSession'];
            var invoices = jsonData["transactions"];
            var productsInTrade = jsonData['productsInTrade'];
            var client = jsonData['client'];
            if (tradeData == null) {
              int? clientId;
              if (client != null) {
                ClientData? clientData = await database.clientDao.getByServerId(client['id']);
                clientId = clientData?.id;
              }
              PosSessionData? posSessionData = await database.posSessionDao.getByServerId(posSession['id']);
              if (posSessionData == null) {
                throw Exception('Mavjud bo\'lmagan Sessiyadagi savdo ');
              }
              // ======================= TRADE =======================
              TradeData newTrade = await database.tradeDao.createTrade(TradeCompanion(
                serverId: toValue(jsonData['id']),
                syncedAt: toValue(DateTime.now()),
                updatedAt: toValue(DateTime.now()),
                isSynced: toValue(true),
                createdAt: toValue(DateTime.now()),
                description: toValue(jsonData['description']),
                discount: toValue(jsonData['discount']),
                finishedAt: toValue(DateTime.fromMillisecondsSinceEpoch(jsonData['createdTime'])),
                returnedProductsIncome: toValue(jsonData['returnedProductsIncome']),
                isFinished: toValue(true),
                isCanceled: toValue(false),
                isReturned: toValue(jsonData['return']),
                returnedMoney: toValue(jsonData['returnedMoney']),
                refund: toValue(jsonData['refund']),
                clientId: toValue(clientId),
                posSessionId: toValue(posSessionData.id),
              ));

              // ======================= INVOICES =======================
              for (var i = 0; i < invoices.length; i++) {
                await database.transactionsDao.createNewInvoice(TransactionsCompanion(
                  tradeId: toValue(newTrade.id),
                  updatedAt: toValue(DateTime.now()),
                  createdAt: toValue(DateTime.fromMillisecondsSinceEpoch(jsonData['createdTime'])),
                  isSynced: toValue(true),
                  serverId: toValue(invoices[i]['id']),
                  syncedAt: toValue(DateTime.now()),
                  description: toValue(invoices[i]['description']),
                  amount: toValue(invoices[i]['amount']),
                  income: toValue(true),
                  payType: toValue(InvoiceType.fromString(invoices[i]['payType'])),
                ));
              }
              // ======================= PRODUCTS IN TRADE =======================
              for (var i = 0; i < productsInTrade.length; i++) {
                ProductData? productData = await database.productDao.getByServerId(productsInTrade[i]['product']['id']);
                if (productData == null) {
                  throw Exception('Mavjud bo\'lmagan mahsulot');
                } else {
                  await database.tradeProductDao.create(TradeProductCompanion(
                    updatedAt: toValue(DateTime.now()),
                    createdAt: toValue(DateTime.now()),
                    isSynced: toValue(true),
                    syncedAt: toValue(DateTime.now()),
                    amount: toValue(productsInTrade[i]['amount']),
                    discount: toValue(productsInTrade[i]['discount']),
                    serverId: toValue(productsInTrade[i]['id']),
                    price: toValue(productsInTrade[i]['price']),
                    priceName: toValue(productsInTrade[i]['priceName']),
                    tradeId: toValue(newTrade.id),
                    unit: toValue(productsInTrade[i]['product']['unit']),
                    productId: toValue(productData.id),
                  ));
                }
              }
              progressCallback(allTrades.indexOf(jsonData) + 1, allTrades.length, field, status: 'Bazaga Qo\'shilmoqda...');
            } else {
              await database.tradeDao.updateTrade(tradeData.copyWith(
                syncedAt: toValue(DateTime.now()),
                updatedAt: (DateTime.now()),
                isSynced: (true),
              ));
              progressCallback(allTrades.indexOf(jsonData) + 1, allTrades.length, field, status: 'Yangilanmoqda...');
            }
          } else {
            await database.tradeDao.deleteTradeByServerId(jsonData['id']);
          }
        }
        progressCallback(1, 1, field, status: "Yangilandi", isFinished: true, isActive: false);
      }
    } catch (e) {
      progressCallback(0, 0, field, status: 'Xatolik: ${e.toString()}');
      rethrow;
    }
  }

  getAll({
    CancelToken? cancelToken,
    bool? fromStart = false,
  }) async {
    try {
      await getSettings('settings', cancelToken: cancelToken, fromStart: fromStart);
      await getSeasons('season', cancelToken: cancelToken, fromStart: fromStart);
      await getAllPos('pos', cancelToken: cancelToken, fromStart: fromStart);
      await getRegions('regions', cancelToken: cancelToken, fromStart: fromStart);
      await getEmployee('employee', cancelToken: cancelToken, fromStart: fromStart);
      await getCategories('category', cancelToken: cancelToken, fromStart: fromStart);
      await getCategories('category', cancelToken: cancelToken, fromStart: true);
      await getProducts('product', cancelToken: cancelToken, fromStart: fromStart);
      await getPrices('price', cancelToken: cancelToken, fromStart: fromStart);
      await getClients('customer', cancelToken: cancelToken, fromStart: fromStart);
      await getBarcodes('barcode', cancelToken: cancelToken, fromStart: fromStart);
      await getSessions('session', cancelToken: cancelToken, fromStart: fromStart);
      await getTrades('trade', cancelToken: cancelToken, fromStart: fromStart);
    } catch (e) {
      rethrow;
    }
  }
}
