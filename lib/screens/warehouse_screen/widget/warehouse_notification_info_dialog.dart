import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../database/model/transfer_dto.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';

class WarehouseNotificationDialog extends StatefulWidget {
  const WarehouseNotificationDialog({super.key, required this.item, required this.onClose});

  final Map item;
  final Function onClose;

  @override
  State<WarehouseNotificationDialog> createState() => _WarehouseNotificationDialogState();
}

class _WarehouseNotificationDialogState extends State<WarehouseNotificationDialog> {
  MyDatabase myDatabase = Get.find<MyDatabase>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      "№",
                      style: TextStyle(color: AppColors.appColorWhite),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      "Nomi",
                      style: TextStyle(color: AppColors.appColorWhite),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      "Artikul",
                      style: TextStyle(color: AppColors.appColorWhite),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      "Miqdori",
                      style: TextStyle(color: AppColors.appColorWhite),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      'Narxi',
                      style: TextStyle(color: AppColors.appColorWhite),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      'Jami',
                      style: TextStyle(color: AppColors.appColorWhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.item['products'].length,
              itemBuilder: (context, index) {
                final product = widget.item['products'][index];
                print(product);
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(color: AppColors.appColorWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            "${product['product']['name']}",
                            style: TextStyle(color: AppColors.appColorWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            "${product['product']['vendorCode']}",
                            style: TextStyle(color: AppColors.appColorWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            formatNumber(product["amount"]),
                            style: TextStyle(color: AppColors.appColorWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            formatNumber(product["price"]),
                            style: TextStyle(color: AppColors.appColorWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appColorWhite, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            formatNumber(product["price"] * product["amount"]),
                            style: TextStyle(color: AppColors.appColorWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                onTap: () {
                  widget.onClose();
                },
                width: 130,
                height: 40,
                margin: const EdgeInsets.all(7),
                color: AppColors.appColorGrey700,
                hoverColor: AppColors.appColorGrey400,
                colorOnClick: AppColors.appColorGrey700,
                splashColor: AppColors.appColorGrey700,
                borderRadius: BorderRadius.circular(15),
                hoverRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      UniconsLine.arrow_left,
                      color: AppColors.appColorWhite,
                      size: 23,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Orqaga', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              (widget.item['status'] == TransferStatus.COMPLETED.name || widget.item['status'] == TransferStatus.CANCELED.name)
                  ? Text(
                      "Ushbu mahsulotlar allaqachon ${widget.item['status'] == TransferStatus.COMPLETED.name ? 'QABUL QILINGAN' : 'RAD ETILGAN'}",
                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          onTap: () async {
                            onTapButtons(TransferStatus.COMPLETED);
                          },
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.all(7),
                          color: AppColors.appColorGreen400,
                          hoverColor: AppColors.appColorGreen300,
                          colorOnClick: AppColors.appColorGreen700,
                          splashColor: AppColors.appColorGreen700,
                          borderRadius: BorderRadius.circular(15),
                          hoverRadius: BorderRadius.circular(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                UniconsLine.check_circle,
                                color: AppColors.appColorWhite,
                                size: 23,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Qabul qilish',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        AppButton(
                          onTap: () async {
                            onTapButtons(TransferStatus.CANCELED);
                          },
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.all(7),
                          color: AppColors.appColorRed400,
                          hoverColor: AppColors.appColorRed300,
                          colorOnClick: AppColors.appColorRed400,
                          splashColor: AppColors.appColorRed400,
                          borderRadius: BorderRadius.circular(15),
                          hoverRadius: BorderRadius.circular(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                UniconsLine.times_circle,
                                color: AppColors.appColorWhite,
                                size: 23,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Rad etish',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }

  void onTapButtons(TransferStatus status) async {
    try {
      final response = await HttpServices.patch("/products-transfer/status/${widget.item['id']}?status=${status.name}", {});
      print(response.body);
      widget.onClose();
      if (response.statusCode == 200) {
        if (context.mounted) {
          showAppSnackBar(context, 'Muvaffaqiyatli ${status == TransferStatus.COMPLETED ? "QABUL" : "RAD"} qilindi', 'OK');
          // await myDatabase.transferDao.updateTransferStatus(widget.item['id'], status);
        }
      } else {
        throw response.body;
      }
    } catch (e) {
      if (e.toString().contains("You can't change status")) {
        showAppSnackBar(context, 'Xatolik yuz berdi: Siz ushbu tovarlarni qabul qila olmaysiz', 'OK', isError: true);
      } else {
        showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
      }
    }
  }
}
