import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/model/trade_product_data_dto.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_input_underline.dart';

class SellItem extends StatefulWidget {
  const SellItem({
    super.key,
    required this.index,
    required this.currentProduct,
    required this.onRemove,
    required this.setAmount,
    required this.tradeProductData,
    this.readOnly = false,
    this.focusToSearch,
    required this.setPrice,
  });

  final int index;
  final ProductDTO currentProduct;
  final TradeProductDataDto tradeProductData;
  final Future Function() onRemove;
  final Future Function(int amount) setAmount;
  final Future Function(double price) setPrice;
  final bool? readOnly;
  final Null Function()? focusToSearch;

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  bool readOnly = false;
  FocusNode focusNode = FocusNode();
  bool readOnlyForPrice = false;
  FocusNode focusNodeForPrice = FocusNode();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = formatNumber(widget.tradeProductData.amount);
    priceController.text = formatNumber(widget.tradeProductData.price);
  }

  @override
  Widget build(BuildContext context) {
    ProductDTO currentProduct = widget.currentProduct;

    return AppTableItems(
      height: 45,
      hideBorder: true,
      layouts: const [6, 4, 4, 3, 1],
      items: [
        AppTableItemStruct(
          flex: 6,
          innerWidget: Row(
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 15),
              Text(
                currentProduct.productData.name,
                style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentProduct.productData.code ?? '',
                style: TextStyle(color: AppColors.appColorWhite),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (!readOnly)
                  ? AppButton(
                      onTap: () {
                        if (widget.tradeProductData.amount == 1) return;
                        widget.setAmount(widget.tradeProductData.amount.toInt() - 1);
                      },
                      width: 24,
                      height: 24,
                      hoverColor: AppColors.appColorRed400,
                      borderRadius: BorderRadius.circular(8),
                      hoverRadius: BorderRadius.circular(8),
                      child: const Icon(Icons.remove_rounded, color: Colors.white, size: 20),
                    )
                  : const SizedBox(),
              GestureDetector(
                  onTap: toggle,
                  child: (readOnly && widget.readOnly == false)
                      ? SizedBox(
                          width: 100,
                          child: AppInputUnderline(
                            controller: amountController,
                            focusNode: focusNode,
                            onTapOutside: (event) {
                              focusNode.unfocus();
                              widget.focusToSearch != null ? widget.focusToSearch!() : null;
                              setState(() {
                                readOnly = false;
                              });
                            },
                            hintText: 'Miqdor',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Miqdor kiritilmagan';
                              return null;
                            },
                            inputFormatters: [AppTextInputFormatter()],
                            hideIcon: true,
                            enableBorderColor: Colors.green,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value.isEmpty) return;
                              widget.setAmount(int.parse(value.replaceAll(' ', '')));
                            },
                          ),
                        )
                      : Container(
                          constraints: const BoxConstraints(minWidth: 50),
                          child:
                              Text(formatNumber(widget.tradeProductData.amount), style: TextStyle(color: AppColors.appColorWhite), textAlign: TextAlign.center),
                        )),
              (!readOnly)
                  ? AppButton(
                      onTap: () {
                        widget.setAmount(widget.tradeProductData.amount.toInt() + 1);
                      },
                      width: 24,
                      height: 24,
                      hoverColor: AppColors.appColorGreen400,
                      borderRadius: BorderRadius.circular(8),
                      hoverRadius: BorderRadius.circular(8),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        AppTableItemStruct(
          flex: 3,
          innerWidget: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 50),
              child: Text(formatNumber(widget.tradeProductData.price), style: TextStyle(color: AppColors.appColorWhite), textAlign: TextAlign.center),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 1,
          innerWidget: (widget.readOnly == true)
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(width: 5),
                  ],
                ),
        ),
      ],
    );
  }

  void toggle() {
    amountController.text = formatNumber(widget.tradeProductData.amount);
    setState(() {
      readOnly = !readOnly;
    });
    if (readOnly) {
      focusNode.requestFocus();
    }
  }

  void toggleForPrice() {
    priceController.text = formatNumber(widget.tradeProductData.price);
    priceController.selection = TextSelection(baseOffset: 0, extentOffset: priceController.text.length, isDirectional: false);
    setState(() {
      readOnlyForPrice = !readOnlyForPrice;
    });
    if (readOnlyForPrice) {
      focusNodeForPrice.requestFocus();
    }
  }

  @override
  void dispose() {
    focusNodeForPrice.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
