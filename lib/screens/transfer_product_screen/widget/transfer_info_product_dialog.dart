import 'dart:convert';

import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_toolbar.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_update_diaolog.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../constants/user_role.dart';
import '../../../database/model/transfer_dto.dart';
import '../../../services/excel_service.dart';
import '../../../services/https_services.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';

class TransferInfoProductDialog extends StatefulWidget {
  const TransferInfoProductDialog({super.key, required this.transferItem, required this.update});

  final TransferDto transferItem;
  final Null Function() update;

  @override
  State<TransferInfoProductDialog> createState() => _TransferInfoProductDialogState();
}

class _TransferInfoProductDialogState extends State<TransferInfoProductDialog> {
  final formKey = GlobalKey<FormState>();
  List<ShopDto> shopList = [];
  String selectedUnit = 'PENDING';
  List<String> dropdownItems = ['PENDING', 'IN_PROGRESS', 'CANCELED', 'COMPLETED'];
  final TextEditingController _commentController = TextEditingController();
  TransferDto? transferItem;
  ShopDto? selectedFromShop;
  ShopDto? selectedToShop;

  @override
  void initState() {
    super.initState();
    transferItem = widget.transferItem;
    selectedFromShop = widget.transferItem.fromShop;
    selectedToShop = widget.transferItem.toShop;
    getValues();
    getMe();
    getAllShops();
  }

  void getAllShops() async {
    var res = await HttpServices.get("/shop/all");
    List<ShopDto> shops = [];
    var json = jsonDecode(res.body);
    for (var item in json['data']) {
      shops.add(ShopDto.fromJson(item));
    }
    setState(() {
      shopList = shops;
    });
  }

  List<UserRole> editRoles = [UserRole.ADMIN];
  bool canEdit = false;
  bool isEditable = false;

  void getMe() async {
    var res = await HttpServices.get("/user/get-me");
    var json = jsonDecode(res.body);
    var roles = json['roles'];
    setState(() {
      canEdit = editRoles.any((element) => roles.contains(element.name));
    });
  }

  void getValues() async {
    _commentController.text = widget.transferItem.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f9): () {
          if (canEdit) {
            setState(() {
              isEditable = !isEditable;
            });
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: isEditable
            ? TransferUpdateDialog(
                transferItem: widget.transferItem,
                shopList: shopList,
                close: () {
                  widget.update();
                  setState(() {
                    isEditable = false;
                  });
                })
            : AppDialog(
                backgroundColor: Colors.black.withOpacity(0.9),
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (canEdit)
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isEditable = !isEditable;
                                });
                              },
                              icon: Icon(Icons.edit,
                                  color: isEditable ? AppColors.appColorGreen400 : Colors.orangeAccent, size: 20)),
                        IconButton(
                          onPressed: () async {
                            List<ProductOutcome> all = widget.transferItem.products;
                            List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Miqdori'];
                            List data = all.map((e) => [e.product.name, e.product.vendorCode, e.product.code, e.amount]).toList();
                            await ExcelService.createExcelFile(
                                [header, ...data], 'Peremesheniya ${formatDate(widget.transferItem.createdTime)}', context);
                          },
                          icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
                        ),
                      ],
                    ),
                    Text('Maxsulotlarni harakati malumotlari', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                  ],
                ),
                content: Form(
                  key: formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.appColorGrey700, width: 1),
                        ),
                        child: isEditable
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: AppAutoComplete(
                                      initialValue: selectedFromShop?.name ?? "",
                                      prefixIcon: UniconsLine.share,
                                      hintText: 'Yuboruvchi',
                                      getValue: (AutocompleteDataStruct value) {
                                        setState(() {
                                          selectedFromShop = shopList.firstWhereOrNull(
                                              (element) => element.name == value.value && element.id == value.uniqueId);
                                        });
                                      },
                                      options: shopList
                                          .map((e) => AutocompleteDataStruct(
                                                uniqueId: e.id,
                                                value: e.name,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 300,
                                    child: AppAutoComplete(
                                      initialValue: selectedToShop?.name ?? "",
                                      prefixIcon: UniconsLine.user_circle,
                                      hintText: 'Qabul qiluvchi',
                                      getValue: (AutocompleteDataStruct value) {
                                        setState(() {
                                          selectedToShop = shopList.firstWhereOrNull(
                                              (element) => element.name == value.value && element.id == value.uniqueId);
                                        });
                                      },
                                      options: shopList
                                          .map((e) => AutocompleteDataStruct(
                                                uniqueId: e.id,
                                                value: e.name,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.appColorGrey400),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white12,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_upward, color: AppColors.appColorWhite, size: 20),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.transferItem.fromShop?.name ?? "",
                                                style: TextStyle(color: AppColors.appColorWhite)),
                                            Text('Yuboruvchi', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(formatDateTime(widget.transferItem.createdTime),
                                          style: TextStyle(color: AppColors.appColorWhite)),
                                      Text("Vaqti", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 12)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.appColorGreen400),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green.withOpacity(0.2),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_downward_outlined, color: AppColors.appColorGreen700, size: 20),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.transferItem.toShop?.name ?? "",
                                                style: TextStyle(color: AppColors.appColorWhite)),
                                            Text('Qabul qiluvchi',
                                                style: TextStyle(color: AppColors.appColorGrey400, fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 10),
                      const Expanded(
                        child: TransferItemsToolbar(
                          layouts: [3, 1, 1, 1, 1, 1],
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(0.7),
                          ),
                          child: ListView.builder(
                            itemCount: widget.transferItem.products.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                                                  child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(widget.transferItem.products[index].product.name,
                                                  style: TextStyle(color: AppColors.appColorWhite)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${widget.transferItem.products[index].product.vendorCode}',
                                                  style: TextStyle(color: AppColors.appColorWhite)),
                                              const SizedBox(width: 10)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${widget.transferItem.products[index].product.code}',
                                                  style: TextStyle(color: AppColors.appColorWhite)),
                                              const SizedBox(width: 10)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: isEditable
                                              ? Center(
                                                  child: AppInputUnderline(
                                                    hideIcon: true,
                                                    hintText: 'Miqdor',
                                                    defaultValue: formatNumber(widget.transferItem.products[index].amount),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        widget.transferItem.products[index].amount =
                                                            double.tryParse(value.replaceAll(' ', '')) ?? 0;
                                                      });
                                                    },
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(formatNumber(widget.transferItem.products[index].amount),
                                                        style: TextStyle(color: AppColors.appColorWhite)),
                                                    const SizedBox(width: 10)
                                                  ],
                                                ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              FutureBuilder(
                                                  future: HttpServices.get(
                                                      "/product/${widget.transferItem.products[index].product.serverId}"),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      var json = jsonDecode(snapshot.data?.body ?? "");
                                                      var amount = json['data'];
                                                      return Text(formatNumber(amount),
                                                          style: TextStyle(color: AppColors.appColorWhite));
                                                    } else {
                                                      return const Text("-");
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  widget.transferItem.products[index].expiredDate != null
                                                      ? formatDate(widget.transferItem.products[index].expiredDate)
                                                      : "-",
                                                  style: TextStyle(color: AppColors.appColorWhite)),
                                              const SizedBox(width: 10)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: Colors.white24),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                actions: [
                  if (isEditable)
                    AppButton(
                      tooltip: '',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            if (selectedToShop == null) {
                              throw 'Qabul qiluvchi tanlanmagan';
                            } else if (widget.transferItem.products.isEmpty) {
                              throw 'Mahsulotlar tanlanmagan';
                            }
                            var request = {
                              "fromShopId": selectedFromShop?.id,
                              "toShopId": selectedToShop?.id,
                              "description": _commentController.text,
                              "createdTime": DateTime.now().millisecondsSinceEpoch,
                              "products": [
                                for (var item in widget.transferItem.products)
                                  {
                                    "productId": item.product.serverId,
                                    "amount": item.amount,
                                  },
                              ],
                            };
                            var res = await HttpServices.put("/products-transfer/${widget.transferItem.id}", request);
                            if (res.statusCode == 200 || res.statusCode == 201) {
                              // widget.close();
                            } else {
                              throw res.body;
                            }
                          } catch (e) {
                            showAppAlertDialog(context,
                                title: 'Xatolik', message: 'Xatolik yuz berdi:\n$e', cancelLabel: 'Ok', buttonLabel: 'OK');
                          }
                        }
                      },
                      width: 95,
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
                          Text(
                            'Saqlash',
                            style: TextStyle(
                                color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class UpdateDialog extends Intent {}
