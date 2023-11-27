import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/sell_screen/widget/sell_item.dart';
import 'package:easy_sell/screens/sell_screen/widget/sell_item_info.dart';
import 'package:easy_sell/screens/sell_screen/widget/sell_right_containers.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/services/excel_service.dart';
import 'package:easy_sell/utils/translator.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../database/model/product_dto.dart';
import '../../database/model/trade_product_data_dto.dart';
import '../../database/model/trade_product_dto.dart';
import '../../utils/routes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_search_field.dart';
import '../sync_screen/syn_enums.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  List<TradeDTO> _trades = [];
  MyDatabase database = Get.find<MyDatabase>();
  int _initialTradeIndex = 0;
  bool loading = false;
  List<ProductDTO> _searchList = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool searchLoading = false;
  String oldSearch = '';
  late UploadFunctions uploadFunctions;
  late DownloadFunctions downloadFunctions;

  @override
  void initState() {
    super.initState();
    getUnFinishedTrades();
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
    downloadFunctions = DownloadFunctions(database: database, progress: {}, setter: setter);
  }

  void setter(void Function() fn) {}

  void getUnFinishedTrades() async {
    try {
      setState(() {
        loading = true;
      });
      List<TradeDTO> tradeDTOs = [];
      List<TradeData> trades = await database.tradeDao.getAllNotFinished();
      if (trades.isEmpty) {
        TradeDTO newTrade = await createTrade();
        tradeDTOs.add(newTrade);
      }
      for (TradeData trade in trades) {
        List<TradeProductDto> tradeProducts = await database.tradeProductDao.getByTradeId(trade.id);
        List<TradeProductDataDto> currentProductData = [];
        for (var element in tradeProducts) {
          currentProductData.add(TradeProductDataDto(
            productId: element.product.productData.id,
            price: element.tradeProduct.price,
            unit: element.tradeProduct.unit,
            amount: element.tradeProduct.amount,
            priceName: 'RETAIL',
            index: tradeProducts.indexOf(element),
          ));
        }
        List<Transaction> invoices = await database.transactionsDao.getByTradeId(trade.id);
        tradeDTOs.add(TradeDTO(trade: trade, tradeProducts: tradeProducts, invoices: invoices, data: currentProductData));
      }
      setState(() {
        _trades = tradeDTOs;
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<TradeDTO> createTrade() async {
    PosSessionData? posSession = await database.posSessionDao.getLastSession();
    TradeData newTrade = await database.tradeDao.createTrade(TradeCompanion(
      posSessionId: toValue(posSession?.id ?? 0),
      isFinished: toValue(false),
      isCanceled: toValue(false),
      isReturned: toValue(false),
      createdAt: toValue(DateTime.now()),
      updatedAt: toValue(DateTime.now()),
    ));
    return TradeDTO(trade: newTrade, tradeProducts: [], invoices: [], data: []);
  }

  Future<void> downloadAllTrades() async {
    try {
      List<TradeDTO> trades = await database.tradeDao.getAllWithJoin();
      await ExcelService.createExcelFile(trades.map((e) => e.toArray()).toList(), 'Savdolar', context);
    } catch (e) {
      print(e);
    }
  }

  void onPay(ClientData? client, {double? discount, double? refund}) async {
    try {
      await database.tradeDao.tradeTransaction(() async {
        List<TradeProductDto> tradeProducts = _trades[_initialTradeIndex].tradeProducts;
        for (TradeProductDto tradeProduct in tradeProducts) {
          int index = tradeProducts.indexOf(tradeProduct);
          await database.tradeProductDao.replaceById(
              tradeProduct.tradeProduct.id,
              tradeProduct.tradeProduct.copyWith(
                amount: _trades[_initialTradeIndex].data[index].amount,
                price: _trades[_initialTradeIndex].data[index].price,
                updatedAt: DateTime.now(),
              ));
        }
        await database.tradeDao.closeTrade(_trades[_initialTradeIndex].trade.id, client?.id, discount: discount, refund: refund);
        setState(() {
          _trades.removeAt(_initialTradeIndex);
        });
      });
      uploadFunctions.autoUpload(UploadTypes.CUSTOMERS);
      uploadFunctions.autoUpload(UploadTypes.TRADES);
      TradeDTO newTrade = await createTrade();
      setState(() {
        _trades.add(newTrade);
        _initialTradeIndex = _trades.length - 1;
        Get.back();
      });
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, 'Xatolik : $e', 'OK', isError: true);
      }
    }
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.numpadAdd): const OpenNewWindow(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyX): const CloseWindow(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          OpenNewWindow: CallbackAction<OpenNewWindow>(
            onInvoke: (OpenNewWindow intent) async {
              TradeDTO newTrade = await createTrade();
              setState(() {
                _trades.add(newTrade);
                _initialTradeIndex = _trades.length - 1;
              });
              return null;
            },
          ),
          CloseWindow: CallbackAction<CloseWindow>(
            onInvoke: (CloseWindow intent) async {
              showAppAlertDialog(
                context,
                title: 'Kassani o\'chirmoqchimisiz?',
                onConfirm: () async {
                  await database.tradeDao.cancelTrade(_trades[_initialTradeIndex].trade.id);
                  setState(() {
                    _trades.remove(_trades[_initialTradeIndex]);
                    _initialTradeIndex = _trades.length - 1;
                  });
                },
                message: 'Kassani o\'chirish orqali siz  vaqtincha yopib qo\'yishingiz mumkin',
                buttonLabel: 'Yopish',
                cancelLabel: 'Bekor qilish',
              );
              return null;
            },
          ),
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.black12,
            leading: AppButton(
              onTap: () => Get.back(),
              width: 50,
              height: 50,
              margin: const EdgeInsets.all(7),
              color: AppColors.appColorGrey700.withOpacity(0.5),
              hoverColor: AppColors.appColorGreen300,
              colorOnClick: AppColors.appColorGreen700,
              splashColor: AppColors.appColorGreen700,
              borderRadius: BorderRadius.circular(13),
              hoverRadius: BorderRadius.circular(13),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.appColorWhite),
            ),
            centerTitle: false,
            title: Text('Kassa', style: TextStyle(color: AppColors.appColorWhite)),
            actions: [
              Tooltip(
                message: 'Excelga yuklash',
                child: AppButton(
                  onTap: () async {
                    List<TradeDTO> all = await database.tradeDao.getAllWithJoin();
                    List header = ['ID', 'Mijoz', 'Sana', 'Mahsulotlar', "To'lov", "Chegirma"];
                    List data = [];
                    for (var e in all) {
                      String clientName = '';
                      if (e.trade.clientId != null) {
                        ClientData? client = await database.clientDao.getById(e.trade.clientId ?? -1);
                        clientName = client.name;
                      }
                      data.add([
                        e.trade.id,
                        clientName,
                        e.trade.createdAt.toString().split(' ')[0],
                        e.tradeProducts
                            .map((e) =>
                                " ${e.product.productData.name} dan ${e.tradeProduct.amount} ta ${e.tradeProduct.price} so'mdan")
                            .join('\n'),
                        e.invoices.map((e) => "${e.amount} so'm ${translate(e.payType.name)}").join('\n'),
                        e.trade.discount
                      ]);
                    }
                    await ExcelService.createExcelFile(
                        [header, ...data], 'Savdolar ${DateTime.now().toString().split(' ')[0]}', context);
                  },
                  width: 35,
                  height: 35,
                  margin: const EdgeInsets.all(7),
                  hoverColor: AppColors.appColorGreen300,
                  colorOnClick: AppColors.appColorGreen700,
                  splashColor: AppColors.appColorGreen700,
                  borderRadius: BorderRadius.circular(30),
                  hoverRadius: BorderRadius.circular(30),
                  child: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 21),
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(Routes.TRADE_HISTORY),
                icon: Icon(Icons.history_rounded, color: AppColors.appColorWhite, size: 25),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Container(
              constraints: const BoxConstraints.expand(),
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF26525f), Color(0xFF0f2228)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 47,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(13)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                Row(
                                    children: _trades
                                        .map(
                                          (e) => AppButton(
                                            onTap: () {
                                              setState(() {
                                                _initialTradeIndex = _trades.indexOf(e);
                                              });
                                            },
                                            width: 100,
                                            height: 45,
                                            margin: const EdgeInsets.only(right: 5),
                                            color: _initialTradeIndex == _trades.indexOf(e)
                                                ? AppColors.appColorGreen700
                                                : AppColors.appColorGrey700.withOpacity(0.5),
                                            colorOnClick: AppColors.appColorGreen700,
                                            splashColor: AppColors.appColorGreen700,
                                            borderRadius: BorderRadius.circular(13),
                                            hoverRadius: BorderRadius.circular(13),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Kassa ${_trades.indexOf(e) + 1}',
                                                      style: TextStyle(
                                                          color: AppColors.appColorWhite,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20)),
                                                  const SizedBox(width: 5),
                                                  if (_trades.length > 1)
                                                    AppButton(
                                                      width: 20,
                                                      onTap: () {
                                                        showAppAlertDialog(
                                                          context,
                                                          title: 'Kassani o\'chirmoqchimisiz?',
                                                          onConfirm: () async {
                                                            await database.tradeDao.cancelTrade(e.trade.id);
                                                            setState(() {
                                                              _trades.remove(e);
                                                              _initialTradeIndex = _trades.length - 1;
                                                            });
                                                          },
                                                          message:
                                                              'Kassani o\'chirish orqali siz  vaqtincha yopib qo\'yishingiz mumkin',
                                                          buttonLabel: 'Yopish',
                                                          cancelLabel: 'Bekor qilish',
                                                        );
                                                      },
                                                      child: Icon(Icons.close_rounded, color: AppColors.appColorWhite, size: 20),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()),
                                // Trade add button
                                IconButton(
                                  onPressed: () async {
                                    TradeDTO newTrade = await createTrade();
                                    setState(() {
                                      _trades.add(newTrade);
                                      _initialTradeIndex = _trades.length - 1;
                                    });
                                  },
                                  icon: Icon(Icons.add_rounded, color: AppColors.appColorWhite),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Last added product
                        Container(
                          height: 47,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColors.appColorBlackBg),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 35,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration:
                                    BoxDecoration(color: AppColors.appColorGrey700, borderRadius: BorderRadius.circular(13)),
                                child: Center(
                                  child:
                                      Text("So'nggi maxsulot:", style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                loading || _trades.isEmpty || _trades[_initialTradeIndex].tradeProducts.isEmpty
                                    ? ''
                                    : '${_trades[_initialTradeIndex].tradeProducts.last.product.productData.name} / ${_trades[_initialTradeIndex].tradeProducts.last.product.productData.vendorCode}',
                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Trade body (products, ...)
                        Expanded(
                          flex: 10,
                          child: Column(
                            children: [
                              const SellItemInfo(),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)),
                                    color: AppColors.appColorBlackBg,
                                  ),
                                  width: double.infinity,
                                  child: loading
                                      ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen700))
                                      : (_trades.isEmpty || _trades[_initialTradeIndex].tradeProducts.isEmpty)
                                          ? Center(
                                              child: Text(
                                                _trades.isEmpty ? 'Yangi Kassa oching' : 'Savdo qilinmagan',
                                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
                                              ),
                                            )
                                          : SingleChildScrollView(
                                              controller: _scrollController,
                                              child: ListView.separated(
                                                padding: const EdgeInsets.only(top: 5),
                                                itemCount: _trades[_initialTradeIndex].tradeProducts.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  return SellItem(
                                                    index: index,
                                                    currentProduct: _trades[_initialTradeIndex].tradeProducts[index].product,
                                                    tradeProductData: _trades[_initialTradeIndex].data[index],
                                                    onRemove: () async {
                                                      await database.tradeProductDao.deleteById(
                                                          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.id,
                                                          tradeId: _trades[_initialTradeIndex].trade.id);
                                                      // remove this from current data
                                                      setState(() {
                                                        _trades[_initialTradeIndex].tradeProducts.removeAt(index);
                                                        _trades[_initialTradeIndex].data.removeAt(index);
                                                      });
                                                    },
                                                    setAmount: (amount) async {
                                                      await database.tradeProductDao.updateByProductIdByData(
                                                          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.id,
                                                          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.copyWith(
                                                                amount: double.parse(amount.toString()),
                                                              ));
                                                      setState(() {
                                                        _trades[_initialTradeIndex].data[index].amount =
                                                            double.parse(amount.toString());
                                                      });
                                                    },
                                                    setPrice: (price) async {
                                                      await database.tradeProductDao.updateByProductIdByData(
                                                          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.id,
                                                          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.copyWith(
                                                                price: double.parse(price.toString()),
                                                              ));
                                                      setState(() {
                                                        _trades[_initialTradeIndex].data[index].price =
                                                            double.parse(price.toString());
                                                      });
                                                    },
                                                    focusToSearch: () {
                                                      setState(() {
                                                        _searchFocusNode.requestFocus();
                                                      });
                                                    },
                                                  );
                                                },
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return const Divider(height: 1, color: Colors.white24);
                                                },
                                              ),
                                            ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (_trades.isEmpty) Expanded(child: Container()),
                        if (_searchList.isNotEmpty)
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                              decoration: BoxDecoration(
                                color: AppColors.appColorBlackBg,
                                borderRadius:
                                    const BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17)),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _searchList
                                      .map(
                                        (product) => Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(10),
                                            onTap: () async {
                                              onSelectedProduct(product);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                              decoration:
                                                  BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                                              child: Text(product.productData.name,
                                                  style: TextStyle(color: AppColors.appColorGreen400)),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        // Search products result
                        AppSearchBar(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: _searchList.isEmpty
                                ? const BorderRadius.all(Radius.circular(17))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(17),
                                    bottomRight: Radius.circular(17),
                                  ),
                            color: AppColors.appColorBlackBg,
                          ),
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          focusedColor: Colors.transparent,
                          searchEngine: (
                            String searchTerm, {
                            bool isEmptySearch = false,
                          }) async {
                            if (isEmptySearch) {
                              setState(() {
                                _searchList = [];
                              });
                              return;
                            }
                            List<ProductDTO> products =
                                await database.productDao.getAllProductsByLimitOrSearch(search: searchTerm, limit: 20);
                            setState(() {
                              _searchList = products;
                            });
                          },
                          onEditingComplete: () async {
                            List<ProductDTO> products = await database.productDao
                                .getAllProductsByLimitOrSearch(search: _searchController.text, limit: 20);
                            setState(() {
                              _searchList = products;
                            });
                            if (_searchList.isEmpty) {
                              if (context.mounted) {
                                showAppAlertDialog(
                                  context,
                                  title: 'Xatolik',
                                  message:
                                      'Siz kiritgan maxsulot bazada mavjud emas\nQidiruv so\'rovi: ${_searchController.text}',
                                  buttonLabel: 'Ok',
                                  cancelLabel: 'Bekor qilish',
                                );
                              }
                              setState(() {
                                _searchController.text = '';
                                _searchList = [];
                              });
                              return;
                            }
                            onSelectedProduct(_searchList[0]);
                            setState(() {
                              _searchController.text = '';
                              _searchList = [];
                            });
                          },
                          searchWhenEmpty: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (loading || _trades.isEmpty)
                    Container()
                  else
                    SellRightContainers(
                      tradeData: (loading || _trades.isEmpty) ? [] : _trades[_initialTradeIndex].data,
                      trades: _trades,
                      initialTradeIndex: _initialTradeIndex,
                      setClient: (ClientData? client) async {
                        int tradeId = _trades[_initialTradeIndex].trade.id;
                        await database.tradeDao.setClient(tradeId, client);
                      },
                      onPay: onPay,
                      onReturn: (int tradeId, Map additional) async {
                        try {
                          await database.tradeDao.tradeTransaction(() async {
                            if (additional['returnedProductsIncome'] == true) {
                              double totalPrice = 0;
                              for (var element in _trades[_initialTradeIndex].tradeProducts) {
                                int index = _trades[_initialTradeIndex].tradeProducts.indexOf(element);
                                TradeProductDataDto tradeProductData = _trades[_initialTradeIndex].data[index];
                                totalPrice += tradeProductData.price * tradeProductData.amount;
                              }
                            }
                            await database.tradeDao.returnTrade(tradeId, additional: additional);
                            setState(() {
                              _trades.removeAt(_initialTradeIndex);
                            });
                          });
                          await uploadFunctions.autoUpload(UploadTypes.TRADES);
                          TradeDTO newTrade = await createTrade();
                          setState(() {
                            _trades.add(newTrade);
                            _initialTradeIndex = _trades.length - 1;
                          });
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showAppSnackBar(context, 'Xatolik : $e', 'OK', isError: true);
                          }
                        }
                      },
                      onSelectProduct: onSelectedProduct,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSelectedProduct(ProductDTO product) async {
    double retailPrice = product.prices.first.value;
    TradeProductCompanion tradeProductData = TradeProductCompanion(
      createdAt: toValue(DateTime.now()),
      tradeId: toValue(_trades[_initialTradeIndex].trade.id),
      productId: toValue(product.productData.id),
      price: toValue(retailPrice),
      unit: toValue(product.productData.unit),
      amount: toValue(1),
      discount: toValue(0),
      updatedAt: toValue(DateTime.now()),
      priceName: toValue('RETAIL'),
    );
    // if this product is exist in current trade
    int index = _trades[_initialTradeIndex].data.indexWhere((element) => element.productId == product.productData.id);
    if (index == -1) {
      _trades[_initialTradeIndex].data.add(TradeProductDataDto(
            productId: product.productData.id,
            amount: 1.0,
            index: _trades[_initialTradeIndex].data.length,
            unit: product.productData.unit,
            price: retailPrice,
            priceName: 'RETAIL',
          ));
      TradeProductDto newTradeProduct = await database.tradeProductDao.create(tradeProductData);
      _trades[_initialTradeIndex].tradeProducts.add(newTradeProduct);
    } else {
      double amount = _trades[_initialTradeIndex].data[index].amount;
      await database.tradeProductDao.updateByProductIdByData(
          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.id,
          _trades[_initialTradeIndex].tradeProducts[index].tradeProduct.copyWith(
                amount: amount + 1,
                updatedAt: DateTime.now(),
              ));
      // if this product is exist in current trade then increase amount
      setState(() {
        _trades[_initialTradeIndex].data[index] = _trades[_initialTradeIndex].data[index].copyWith(amount: amount + 1);
      });
    }
    _searchController.clear();
    setState(() {
      _searchList.clear();
    });
    _scrollDown();
  }
}

class OpenNewWindow extends Intent {
  const OpenNewWindow();
}

class CloseWindow extends Intent {
  const CloseWindow();
}
