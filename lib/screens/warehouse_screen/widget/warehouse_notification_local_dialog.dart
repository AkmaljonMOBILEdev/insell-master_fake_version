import 'package:easy_sell/database/model/transfer_dto.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';

class WarehouseNotificationLocalDialog extends StatefulWidget {
  const WarehouseNotificationLocalDialog({super.key, required this.item, required this.onClose});

  final TransferDto item;
  final Function onClose;

  @override
  State<WarehouseNotificationLocalDialog> createState() => _WarehouseNotificationLocalDialogState();
}

class _WarehouseNotificationLocalDialogState extends State<WarehouseNotificationLocalDialog> {
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
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                  child: Center(
                    child: Text("№", style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                  child: Center(
                    child: Text("Nomi", style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                  child: Center(
                    child: Text("Taminotchi artikuli", style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                  child: Center(
                    child: Text("Artikul", style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                  child: Center(
                    child: Text("Miqdori", style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.item.products.length,
              itemBuilder: (context, index) {
                final transferProduct = widget.item.products[index];
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                        child: Center(
                          child: Text("${index + 1}", style: TextStyle(color: AppColors.appColorWhite)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                        child: Center(
                          child: Text(transferProduct.product.name, style: TextStyle(color: AppColors.appColorWhite)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                        child: Center(
                          child: Text("${transferProduct.product.vendorCode}", style: TextStyle(color: AppColors.appColorWhite)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                        child: Center(
                          child: Text("${transferProduct.product.code}", style: TextStyle(color: AppColors.appColorWhite)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.appColorWhite, width: 0.5)),
                        child: Center(
                          child: Text(formatNumber(transferProduct.amount), style: TextStyle(color: AppColors.appColorWhite)),
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
                onTap: () => widget.onClose(),
                width: 130,
                height: 40,
                margin: const EdgeInsets.all(7),
                color: AppColors.appColorGrey700,
                hoverColor: AppColors.appColorGrey400,
                colorOnClick: AppColors.appColorGrey700,
                splashColor: AppColors.appColorGrey700,
                borderRadius: BorderRadius.circular(12),
                hoverRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(UniconsLine.arrow_left, color: AppColors.appColorWhite, size: 23),
                    const SizedBox(width: 5),
                    Text('Orqaga', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              (widget.item.status == TransferStatus.COMPLETED || widget.item.status == TransferStatus.CANCELED)
                  ? Text(
                      "Ushbu mahsulotlar allaqachon ${widget.item.status == TransferStatus.COMPLETED ? 'QABUL QILINGAN' : 'RAD ETILGAN'}",
                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          onTap: () async {
                            onTapButtons(TransferStatus.CANCELED);
                          },
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.all(7),
                          borderRadius: BorderRadius.circular(12),
                          hoverRadius: BorderRadius.circular(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(UniconsLine.times_circle, color: AppColors.appColorRed400, size: 23),
                              const SizedBox(width: 5),
                              Text('Rad etish',
                                  style: TextStyle(color: AppColors.appColorRed400, fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
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
                          borderRadius: BorderRadius.circular(12),
                          hoverRadius: BorderRadius.circular(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(UniconsLine.check_circle, color: AppColors.appColorWhite, size: 23),
                              const SizedBox(width: 5),
                              Text('Qabul qilish',
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
      final response = await HttpServices.patch("/products-transfer/status/${widget.item.id}?status=${status.name}", {});
      widget.onClose();
      if (response.statusCode == 200) {
        if (context.mounted) {
          showAppSnackBar(context, 'Muvaffaqiyatli ${status == TransferStatus.COMPLETED ? "QABUL" : "RAD"} qilindi', 'OK');
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
