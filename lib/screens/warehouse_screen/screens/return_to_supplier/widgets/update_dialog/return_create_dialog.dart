import 'dart:convert';

import 'package:easy_sell/screens/warehouse_screen/screens/return_to_supplier/widgets/update_dialog/return_info.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/return_to_supplier/widgets/update_dialog/return_product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../database/model/product_dto.dart';
import '../../../../../../database/model/product_income_price.dart';
import '../../../../../../database/model/product_outcome_document.dart';
import '../../../../../../database/my_database.dart';
import '../../../../../../services/auto_sync.dart';
import '../../../../../../services/excel_service.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_input_table.dart';
import '../../../../widget/crud/warehouse_excel_upload_widget.dart';

class ReturnProductUpdateDialog extends StatefulWidget {
  const ReturnProductUpdateDialog(
      {super.key, required this.productOutcomeDocument, required this.setter, required this.reload, this.isCreate});

  final ProductOutcomeDocumentDto productOutcomeDocument;
  final Function(ProductOutcomeDocumentDto) setter;
  final void Function() reload;
  final bool? isCreate;

  @override
  State<ReturnProductUpdateDialog> createState() => _ReturnProductUpdateDialogState();
}

class _ReturnProductUpdateDialogState extends State<ReturnProductUpdateDialog> {
  ProductOutcomeDocumentDto get productOutcomeDocument => widget.productOutcomeDocument;
  final _formKey = GlobalKey<FormState>();

  set productOutcomeDocument(ProductOutcomeDocumentDto val) {
    widget.setter(val);
  }

  bool loading = false;

  void onTapProduct(
    ProductDTO product, {
    double price = 0,
    double amount = 1.0,
  }) {
    ProductExpense newProductIncome = ProductExpense(
        product: product.productData,
        price: price,
        amount: amount,
        id: productOutcomeDocument.productExpenses.length + 1,
        currency: productOutcomeDocument.currency);
    productOutcomeDocument.productExpenses.insert(0, newProductIncome);
    widget.setter(productOutcomeDocument);
  }

  List<Map<String, dynamic>> unknownProducts = [];
  bool canSetPrices = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Scaffold(
          backgroundColor: AppColors.appColorBlackBg,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              labelColor: AppColors.appColorWhite,
              indicatorColor: AppColors.appColorGreen400,
              unselectedLabelColor: Colors.white,
              tabs: [
                const Tab(icon: Icon(Icons.info_outline), text: 'Malumotlar'),
                Tab(
                  icon: const Icon(Icons.pageview_rounded),
                  text: 'Mahsulotlar (${productOutcomeDocument.productExpenses.length} ta)',
                ),
              ],
            ),
            title: Text(widget.isCreate == true ? 'Qaytarish' : "O'zgartirish", style: const TextStyle(color: Colors.white)),
            actions: [
              Row(
                children: [
                  if (unknownProducts.isNotEmpty)
                    IconButton(
                      onPressed: () async {
                        showAppAlertDialog(
                          context,
                          title: 'Xatolik(${unknownProducts.length} ta)',
                          message: 'Topilmagan mahsulotlar',
                          buttonLabel: 'Ok',
                          cancelLabel: 'Bekor qilish',
                          messageWidget: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: unknownProducts.map((e) => e.values.join(", ")).toList().join('\n')));
                                    if (context.mounted) {
                                      showAppAlertDialog(
                                        context,
                                        title: 'Muvaffaqiyatli',
                                        message: 'Nusxalangan',
                                        cancelLabel: "OK",
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.copy, color: AppColors.appColorWhite, size: 25)),
                              IconButton(
                                onPressed: () async {
                                  List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Sotuv narxi'];

                                  List data = unknownProducts.map((e) {
                                    return [
                                      e['0'].toString(),
                                      e['1'].toString(),
                                      e['2'].toString(),
                                    ];
                                  }).toList();
                                  await ExcelService.createExcelFile(
                                      [header, ...data], 'Topilmaganlar ${formatDate(DateTime.now()).toString()}', context);
                                },
                                icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.device_unknown, color: AppColors.appColorRed400, size: 25),
                    ),
                ],
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        Map<String, dynamic> result = await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Excelga yuklash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                                IconButton(
                                    onPressed: Get.back, icon: Icon(Icons.close, color: AppColors.appColorWhite, size: 25)),
                              ],
                            ),
                            insetPadding: const EdgeInsets.all(0),
                            content: SizedBox(width: MediaQuery.of(context).size.width, child: const UploadPurchaseExcel()),
                            backgroundColor: Colors.black,
                          ),
                        );
                        List<Map<String, dynamic>> products = result['json'];
                        for (var product in products) {
                          onTapProduct(
                            ProductDTO(productData: product['product'], barcodes: [], prices: [], amount: 0, seasons: []),
                            amount: double.tryParse(product['amount']) ?? 0,
                            price: double.tryParse(product['price']) ?? 0,
                          );
                        }
                        unknownProducts = result['unknownProducts'];
                        setState(() {});
                      },
                      icon: const Icon(Icons.cloud_upload_outlined, color: Colors.yellow, size: 25),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AppInputTable(
                            callback: (List<TableResult> result) async {
                              try {
                                const List<String> selectedFields = ['name', 'vendor_code', 'code'];
                                for (var item in result) {
                                  ProductData? product = await database.productDao.findByTableResults(item, selectedFields);
                                  if (product != null) {
                                    int priceIndex = item.fields.indexOf('price');
                                    int amountIndex = item.fields.indexOf('amount');

                                    onTapProduct(
                                        ProductDTO(productData: product, barcodes: [], prices: [], amount: 0, seasons: []),
                                        amount: double.tryParse(item.values[amountIndex]) ?? 1,
                                        price: double.tryParse(item.values[priceIndex]) ?? 0);
                                  } else {
                                    if (mounted) {
                                      showAppAlertDialog(
                                        context,
                                        title: 'XATOLIK!',
                                        message: 'So\'rov bo\'yicha topilmadi:${item.values.join(",")}',
                                        cancelLabel: "OK",
                                      );
                                    }
                                  }
                                }
                                Get.back();
                              } catch (e) {
                                if (mounted) {
                                  showAppAlertDialog(context,
                                      title: 'Xatolik', message: e.toString(), buttonLabel: 'Ok', cancelLabel: 'Bekor qilish');
                                }
                              }
                            },
                            defaultFieldsForHeader: [
                              TableField(
                                label: 'Mahsulot',
                                value: 'name',
                              ),
                              TableField(
                                label: 'Taminotchi Artikuli',
                                value: 'vendor_code',
                              ),
                              TableField(
                                label: 'Artikul',
                                value: 'code',
                              ),
                              TableField(
                                label: 'Miqdor',
                                value: 'amount',
                              ),
                              TableField(
                                label: 'Narx',
                                value: 'price',
                              ),
                              TableField(
                                label: 'Yaroqlilik',
                                value: 'expire_date',
                                inputFormatter: [
                                  MaskTextInputFormatter(
                                    mask: '##.##.####',
                                    filter: {"#": RegExp(r'[0-9]')},
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.paste_outlined, color: AppColors.appColorWhite, size: 25),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        List<ProductExpense> all = widget.productOutcomeDocument.productExpenses;
                        List header = [
                          'Mahsulot',
                          'Taminotchi artikuli',
                          'Artikul',
                          'Miqdori',
                          'Narxi',
                          'Valyuta',
                          'Sotuv Narxi',
                          'Rentabl',
                          'Umumiy',
                          'Yaroqlilik'
                        ];
                        List data = all.map((e) {
                          return [
                            e.product.name,
                            e.product.vendorCode,
                            e.product.code,
                            e.amount,
                            e.price,
                            e.currency?.abbreviation,
                            e.amount * e.price,
                          ];
                        }).toList();
                        await ExcelService.createExcelFile([header, ...data],
                            'Vazvrat (ADMIN) ${formatDate(widget.productOutcomeDocument.createdTime).toString()}', context);
                      },
                      icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                    ),
                    const SizedBox(width: 10),
                    AppButton(
                        onTap: () async {
                          var response = await HttpServices.post('/report/last-product-income-price', {});
                          var json = jsonDecode(response.body);
                          for (var item in json) {
                            ProductIncomePrice incomePrice = ProductIncomePrice.fromJson(item);
                            for (var element in productOutcomeDocument.productExpenses) {
                              if (element.product.serverId == incomePrice.product.serverId) {
                                setState(() {
                                  element.price = incomePrice.price;
                                  element.currency = incomePrice.currency;
                                });
                              }
                            }
                          }
                        },
                        width: 40,
                        child: const Icon(Icons.expand_circle_down_outlined, color: Colors.green)),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AppButton(
                tooltip: '',
                onTap: loading
                    ? null
                    : () {
                        showAppAlertDialog(
                          context,
                          title: 'Diqqat',
                          message: 'Ma\'lumotlar saqlansinmi?',
                          buttonLabel: 'Saqlash',
                          cancelLabel: 'Bekor qilish',
                          onConfirm: () async {
                            try {
                              setState(() {
                                loading = true;
                              });
                              if (productOutcomeDocument.productExpenses.isEmpty) {
                                throw Exception('Mahsulotlar bo\'sh bo\'lishi mumkin emas');
                              }
                              if (productOutcomeDocument.supplier == null) {
                                throw Exception('Taminotchi bo\'sh bo\'lishi mumkin emas');
                              }
                              if (productOutcomeDocument.currency == null) {
                                throw Exception('Valyuta bo\'sh bo\'lishi mumkin emas');
                              }
                              var responseForStock = await HttpServices.get('/product/all/remainder');
                              var jsonForStock = jsonDecode(responseForStock.body);
                              for (var item in jsonForStock) {
                                int id = item['id'];
                                double amount = item['amount'];
                                for (var element in productOutcomeDocument.productExpenses) {
                                  if (element.product.serverId == id) {
                                    if (amount < element.amount) {
                                      throw ('Siz omborda ${element.product.name} mahsulotidan ${formatNumber(element.amount)} ta ola olmaysiz\nMavjud soni: ${formatNumber(amount)} ta\n\n');
                                    }
                                  }
                                }
                              }
                              if (_formKey.currentState!.validate()) {
                                var res;
                                if (widget.isCreate == true) {
                                  res = await HttpServices.post(
                                      "/product-outcome/return-income", productOutcomeDocument.toRequestJson());
                                } else {
                                  res = await HttpServices.put(
                                      "/product-outcome/${productOutcomeDocument.id}", productOutcomeDocument.toRequestJson());
                                }

                                if (res.statusCode == 200 || res.statusCode == 201) {
                                  Get.back();
                                  widget.reload();
                                } else {
                                  throw Exception(res.body);
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                loading = false;
                              });
                              if (mounted) {
                                showAppAlertDialog(context,
                                    title: 'Xatolik', message: 'Xatolik yuz berdi\n ${e.toString()}', cancelLabel: 'ok');
                              }
                            }
                          },
                        );
                      },
                width: 100,
                height: 40,
                color: AppColors.appColorGreen400,
                hoverColor: AppColors.appColorGreen300,
                colorOnClick: AppColors.appColorGreen700,
                splashColor: AppColors.appColorGreen700,
                borderRadius: BorderRadius.circular(12),
                hoverRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColorWhite),
                            ),
                          )
                        : Text(
                            'Saqlash',
                            style: TextStyle(
                                color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: TabBarView(
            children: [
              ReturnInfoUpdate(
                productOutcomeDocument: productOutcomeDocument,
                setter: (ProductOutcomeDocumentDto val) {
                  setState(() {
                    productOutcomeDocument = val;
                  });
                },
              ),
              ReturnProductsUpdate(
                productOutcomeDocument: productOutcomeDocument,
                onTapProduct: onTapProduct,
                setter: (ProductOutcomeDocumentDto val) {
                  setState(() {
                    productOutcomeDocument = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
