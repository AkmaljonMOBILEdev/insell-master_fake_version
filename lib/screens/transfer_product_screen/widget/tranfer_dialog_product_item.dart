import 'dart:convert';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_add_product_dialog.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../services/https_services.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class TransferDialogItem extends StatefulWidget {
  const TransferDialogItem({
    super.key,
    required this.index,
    required this.productData,
    required this.onRemove,
    required this.setAmount,
    this.layouts,
    required this.setExpireDate,
  });

  final int index;
  final TransferProductDataStruct productData;
  final Null Function() onRemove;
  final Null Function(int amount) setAmount;
  final List<int>? layouts;
  final Null Function(DateTime? expireDate) setExpireDate;

  @override
  State<TransferDialogItem> createState() => _TransferDialogItemState();
}

class _TransferDialogItemState extends State<TransferDialogItem> {
  bool readOnly = false;
  bool readOnlyPrice = false;
  FocusNode focusNode = FocusNode();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = formatNumber(widget.productData.amount);
  }

  @override
  Widget build(BuildContext context) {
    ProductData currentProduct = widget.productData.product;
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: AppTableItems(
            hideBorder: true,
            layouts: widget.layouts,
            items: [
              AppTableItemStruct(
                flex: 3,
                innerWidget: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                        child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      currentProduct.name,
                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppTableItemStruct(
                flex: 3,
                innerWidget: Center(
                  child: Text(currentProduct.vendorCode ?? '', style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
                ),
              ),
              AppTableItemStruct(
                flex: 3,
                innerWidget: Center(
                    child: Text(currentProduct.code ?? '', style: TextStyle(color: AppColors.appColorWhite, fontSize: 14))),
              ),
              AppTableItemStruct(
                innerWidget: GestureDetector(
                  onTap: toggle,
                  child: readOnly
                      ? Center(
                          child: AppInputUnderline(
                            focusNode: focusNode,
                            controller: amountController,
                            hintText: 'Miqdor',
                            hideIcon: true,
                            enableBorderColor: Colors.green,
                            onChanged: (value) {
                              if (value.isEmpty) return;
                              widget.setAmount(int.parse(value.replaceAll(' ', '')));
                            },
                            onTapOutside: (PointerDownEvent event) {
                              setState(() {
                                readOnly = false;
                              });
                            },
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                          child: Center(
                            child:
                                Text(formatNumber(widget.productData.amount), style: TextStyle(color: AppColors.appColorWhite)),
                          ),
                        ),
                ),
              ),
              AppTableItemStruct(
                innerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                        future: HttpServices.get("/product/${widget.productData.product.serverId}/remainder"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var json = jsonDecode(snapshot.data?.body ?? "");
                            var amount = json ?? 0;
                            return Text(formatNumber(amount), style: TextStyle(color: AppColors.appColorWhite));
                          } else {
                            return const Text("-");
                          }
                        }),
                  ],
                ),
              ),
              AppTableItemStruct(
                innerWidget: Center(
                  child: Text(
                    widget.productData.expireDate == null ? '-' : formatDateTime(widget.productData.expireDate),
                    style: TextStyle(color: AppColors.appColorWhite),
                  ),
                ),
              ),
              AppTableItemStruct(
                flex: 0,
                innerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      onTap: widget.onRemove,
                      width: 24,
                      height: 24,
                      color: AppColors.appColorRed300,
                      borderRadius: BorderRadius.circular(8),
                      hoverRadius: BorderRadius.circular(8),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white24),
      ],
    );
  }

  void toggle() {
    if (!readOnly) {
      focusNode.requestFocus();
      amountController.selection = TextSelection(baseOffset: 0, extentOffset: amountController.text.length);
    }
    setState(() {
      readOnly = !readOnly;
    });
  }

  void toggleForPrice() {
    setState(() {
      readOnlyPrice = !readOnlyPrice;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
