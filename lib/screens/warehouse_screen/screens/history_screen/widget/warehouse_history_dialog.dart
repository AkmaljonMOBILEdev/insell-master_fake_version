import 'package:easy_sell/database/my_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/model/product_income_document.dart';
import '../../../../transfer_product_screen/widget/transfer_items_header.dart';
import '../../../widget/crud/warehouse_create_dialog.dart';
import '../../../widget/warehouse_income_product_item.dart';

class WarehouseHistoryDialog extends StatelessWidget {
  const WarehouseHistoryDialog({super.key, required this.productIncomeListBySupplier});

  final ProductIncomeDocumentDto productIncomeListBySupplier;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(children: [
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            )),
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
                    Text(productIncomeListBySupplier.supplier?.name ?? "",
                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                  ]),
                ),
                SizedBox(
                  width: 400,
                  child: Row(children: [
                    Icon(UniconsLine.comment_alt, color: AppColors.appColorWhite),
                    const SizedBox(width: 15),
                    Text(productIncomeListBySupplier.description ?? '',
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
                        layouts: [6, 6, 6, 6, 6, 2, 6, 4, 9, 1],
                      )),
                  Expanded(
                    flex: 10,
                    child: ListView.builder(
                      itemCount: productIncomeListBySupplier.productIncomes.length,
                      itemBuilder: (BuildContext context, int index) {
                        ProductData currentProduct = productIncomeListBySupplier.productIncomes[index].product;
                        ProductIncomeDataStruct productData = ProductIncomeDataStruct(
                          amount: productIncomeListBySupplier.productIncomes[index].amount.toInt(),
                          price: productIncomeListBySupplier.productIncomes[index].price,
                          currency: productIncomeListBySupplier.productIncomes[index].currency,
                          expireDate: productIncomeListBySupplier.productIncomes[index].expiredDate,
                          product: productIncomeListBySupplier.productIncomes[index].product,
                        );
                        return WareHouseIncomeProductItem(
                          priceSettingId: -1,
                          layouts: const [6, 6, 6, 6, 4, 6, 2, 4, 6, 4, 9, 1],
                          index: index,
                          currentProduct: currentProduct,
                          productData: productData,
                          onRemove: () async {},
                          setAmount: (int amount) async {},
                          setPrice: (double price) async {},
                          setExpireDate: (arg) {},
                          setCurrency: (arg) {},
                          setAutomaticPrice: (arg) async {},
                          readOnly: true, currencies: [],
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
