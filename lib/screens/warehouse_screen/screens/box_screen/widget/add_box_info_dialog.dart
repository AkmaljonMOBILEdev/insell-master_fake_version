import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../constants/colors.dart';
import '../../../../../database/model/product_dto.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../widgets/app_input_underline.dart';

class AddBoxInfoDialog extends StatefulWidget {
  const AddBoxInfoDialog({super.key, required this.productBox});

  final ProductDTO productBox;

  @override
  State<AddBoxInfoDialog> createState() => _AddBoxInfoDialogState();
}

class _AddBoxInfoDialogState extends State<AddBoxInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final boxNameController = TextEditingController();
  final boxDescriptionController = TextEditingController();
  final boxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() {
    boxNameController.text = widget.productBox.productData.name;
    boxDescriptionController.text = widget.productBox.productData.description ?? '';
    boxPriceController.text = widget.productBox.prices.first.value.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
        title: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
              ),
            ),
            Text('Set malumotlari', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
          ],
        ),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 900,
            height: 500,
            child: Column(children: [
              Container(
                width: 850,
                padding: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 300,
                        child: AppInputUnderline(
                          hintText: 'Set nomi',
                          textInputAction: TextInputAction.newline,
                          prefixIcon: UniconsLine.box,
                          controller: boxNameController,
                        )),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 300,
                      child: AppInputUnderline(
                        maxLines: 1,
                        hintText: 'Izoh',
                        textInputAction: TextInputAction.newline,
                        prefixIcon: UniconsLine.comment_alt,
                        controller: boxDescriptionController,
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: AppInputUnderline(
                        maxLines: 1,
                        hintText: 'Narx',
                        textInputAction: TextInputAction.newline,
                        prefixIcon: UniconsLine.money_insert,
                        iconColor: AppColors.appColorGreen400,
                        controller: boxPriceController,
                        inputFormatters: [AppTextInputFormatter()],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 10,
                child: Container(
                  width: 850,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    itemCount: widget.productBox.productsKit?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                                        child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text('${widget.productBox.productsKit?[index].product.productData.name}',
                                        style: TextStyle(color: AppColors.appColorWhite)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${widget.productBox.productsKit?[index].product.productData.vendorCode}',
                                        style: TextStyle(color: AppColors.appColorWhite)),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                                SizedBox(
                                  width: 100,
                                  child: AppInputUnderline(
                                    hintText: 'Miqdor',
                                    validator: AppValidator().validate,
                                    prefixIcon: Icons.numbers,
                                    inputFormatters: [AppTextInputFormatter()],
                                    enableBorderColor: Colors.transparent,
                                    defaultValue: widget.productBox.productsKit?[index].productKit.amount.toString(),
                                    onChanged: (value) {
                                      if (value.isEmpty) return;
                                      // setState(() {
                                      //   widget.productBox.productsKit[index].productKit.amount = double.parse(value.replaceAll(" ", ""));
                                      // });
                                    },
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
        ));
  }
}
