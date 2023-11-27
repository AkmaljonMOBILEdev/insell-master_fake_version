import 'dart:convert';

import 'package:easy_sell/screens/warehouse_screen/widget/update_dialog/warehouse_new_update_dialog.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_readonly_item.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../database/model/product_income_document.dart';
import '../../../../constants/user_role.dart';
import '../../../../services/excel_service.dart';
import '../../../../services/https_services.dart';
import '../../../../utils/utils.dart';
import '../../../transfer_product_screen/widget/transfer_items_header.dart';

class WarehouseReadHistoryDialog extends StatefulWidget {
  const WarehouseReadHistoryDialog({super.key, required this.productIncomeDocument, required this.update});

  final ProductIncomeDocumentDto productIncomeDocument;
  final Function() update;

  @override
  State<WarehouseReadHistoryDialog> createState() => _WarehouseReadHistoryDialogState();
}

class _WarehouseReadHistoryDialogState extends State<WarehouseReadHistoryDialog> {
  @override
  void initState() {
    super.initState();
    getMe();
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () async {
                List<ProductIncomeDto> all = widget.productIncomeDocument.productIncomes;
                List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Miqdori'];
                List data = all.map((e) => [e.product.name, e.product.vendorCode, e.product.code, e.amount]).toList();
                await ExcelService.createExcelFile(
                    [header, ...data], 'Zakupka ${formatDate(widget.productIncomeDocument.createdTime).toString()}', context);
              },
              icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('Maxsulotlarni kirim tarixi', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      ]),
      content: SizedBox(
        width: Get.width * 0.9,
        height: Get.height * 0.9,
        child: Column(children: [
          Container(
            width: Get.width * 0.9,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 400,
                  child: Row(children: [
                    Icon(UniconsLine.user, color: AppColors.appColorWhite),
                    const SizedBox(width: 15),
                    Text(widget.productIncomeDocument.supplier?.name ?? "",
                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                  ]),
                ),
                SizedBox(
                  width: 400,
                  child: Row(children: [
                    Icon(UniconsLine.comment_alt, color: AppColors.appColorWhite),
                    const SizedBox(width: 15),
                    Text(widget.productIncomeDocument.description ?? '',
                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                  ]),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 10,
            child: Container(
              width: Get.width * 0.9,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Expanded(
                      flex: 1,
                      child: TransferItemsHeader(
                        layouts: [6, 6, 6, 6, 1],
                        readOnly: true,
                      )),
                  Expanded(
                    flex: 10,
                    child: ListView.builder(
                      itemExtent: 50,
                      shrinkWrap: true,
                      cacheExtent: 3000,
                      itemCount: widget.productIncomeDocument.productIncomes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return WarehouseReadonlyItem(
                          layouts: const [6, 6, 6, 6, 1],
                          index: index,
                          incomeProduct: widget.productIncomeDocument.productIncomes[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
