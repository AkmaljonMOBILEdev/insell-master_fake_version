import 'dart:convert';
import 'package:easy_sell/screens/warehouse_screen/screens/history_screen/widget/warehouse_history_item_info.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_read_dialog.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/user_role.dart';
import '../../../../database/model/product_income_document.dart';
import '../../../../widgets/app_button.dart';
import '../../widget/update_dialog/warehouse_new_update_dialog.dart';

class WarehouseHistoryScreen extends StatefulWidget {
  const WarehouseHistoryScreen({Key? key, this.updated}) : super(key: key);
  final bool? updated;

  @override
  State<WarehouseHistoryScreen> createState() => _WarehouseHistoryScreenState();
}

class _WarehouseHistoryScreenState extends State<WarehouseHistoryScreen> {
  List<ProductIncomeDocumentDto> productIncomeDocuments = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getAllIncomes();
    getMe();
  }

  void getAllIncomes() async {
    setState(() {
      loading = true;
    });
    var res = await HttpServices.get("/product-income/all/income");
    var json = jsonDecode(res.body);
    List<ProductIncomeDocumentDto> _productIncomeDocuments = [];
    for (var item in json['data']) {
      _productIncomeDocuments.add(ProductIncomeDocumentDto.fromJson(item));
    }
    if (mounted) {
      setState(() {
        productIncomeDocuments = _productIncomeDocuments;
        loading = false;
      });
    }
  }

  List<UserRole> editRoles = [UserRole.ADMIN];
  bool canEdit = false;

  void getMe() async {
    var res = await HttpServices.get("/user/get-me");
    var json = jsonDecode(res.body);
    var roles = json['roles'];
    setState(() {
      canEdit = editRoles.any((element) => roles.contains(element.name));
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAllIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const WarehouseHistoryItemInfo(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.appColorBlackBg,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              child: loading
                  ? Center(child: CircularProgressIndicator(color: AppColors.appColorWhite))
                  : productIncomeDocuments.isEmpty
                      ? Center(child: Text('Ma\'lumot mavjud emas', style: TextStyle(color: AppColors.appColorWhite)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: productIncomeDocuments.length,
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
                                                    color: AppColors.appColorGreen700, borderRadius: BorderRadius.circular(5)),
                                                child: Text('${productIncomeDocuments[index].id}',
                                                    style: TextStyle(color: AppColors.appColorWhite)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "${productIncomeDocuments[index].supplier?.supplierCode ?? ""} ${productIncomeDocuments[index].supplier?.name ?? ""}",
                                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              (productIncomeDocuments[index].shop?.name ?? ""),
                                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(formatDate(productIncomeDocuments[index].createdTime),
                                                style: TextStyle(color: AppColors.appColorWhite)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text((calculateTotalPrice(productIncomeDocuments[index])),
                                                style: TextStyle(color: AppColors.appColorWhite)),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Text(formatDateTime(productIncomeDocuments[index].expiredDebtDate),
                                                style: TextStyle(color: AppColors.appColorWhite)),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          AppButton(
                                            onTap: () {
                                              showDialog(
                                                useRootNavigator: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return WarehouseReadHistoryDialog(
                                                    productIncomeDocument: productIncomeDocuments[index],
                                                    update: () {
                                                      setState(() {});
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            width: 30,
                                            height: 30,
                                            borderRadius: BorderRadius.circular(10),
                                            hoverRadius: BorderRadius.circular(10),
                                            hoverColor: AppColors.appColorGreen300,
                                            child: Center(child: Icon(UniconsLine.eye, color: AppColors.appColorWhite, size: 20)),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Get.to(() => WarehouseUpdateDialog(
                                                      reload: getAllIncomes,
                                                      productIncomeDocument: productIncomeDocuments[index],
                                                      setter: (ProductIncomeDocumentDto val) {
                                                        setState(() {
                                                          productIncomeDocuments[index] = val;
                                                        });
                                                      },
                                                    ));
                                              },
                                              icon: const Icon(Icons.edit, color: Colors.orange)),
                                          (productIncomeDocuments[index].fromShop != null)
                                              ? Tooltip(
                                                  message: "${productIncomeDocuments[index].fromShop?.name} orqali kelgan",
                                                  child: const Icon(Icons.verified_user, color: Colors.blue, size: 20),
                                                )
                                              : const SizedBox(),
                                        ],
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
        ],
      ),
    );
  }

  String calculateTotalPrice(ProductIncomeDocumentDto productIncomeDocument) {
    double total = productIncomeDocument.productIncomes.fold(0.0, (previousValue, element) {
      return previousValue + element.amount * element.price;
    });
    total -= productIncomeDocument.discount;
    return "${formatNumber(total)} ${productIncomeDocument.currency?.name ?? ""}";
  }
}
