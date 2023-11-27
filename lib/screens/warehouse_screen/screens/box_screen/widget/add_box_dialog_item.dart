import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../widgets/app_input_underline.dart';
import 'add_box_dialog.dart';

class AddBoxDialogItem extends StatefulWidget {
  const AddBoxDialogItem({super.key, required this.item, required this.onDelete, required this.index, required this.setAmount});

  final BoxItemsStruct item;
  final Function onDelete;
  final int index;
  final Null Function(double value) setAmount;

  @override
  State<AddBoxDialogItem> createState() => _AddBoxDialogItemState();
}

class _AddBoxDialogItemState extends State<AddBoxDialogItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.product.productData.name, style: TextStyle(color: AppColors.appColorWhite)),
                Text('${widget.item.product.productData.vendorCode}',
                    style: TextStyle(color: AppColors.appColorGrey300, fontSize: 12)),
              ],
            ),
          ],
        ),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.appColorGrey400.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: AppInputUnderline(
            hintText: formatNumber(widget.item.price),
            prefixIcon: Icons.numbers,
            inputFormatters: [AppTextInputFormatter()],
            enableBorderColor: Colors.transparent,
            hideIcon: true,
          ),
        ),
        SizedBox(
          width: 100,
          child: AppInputUnderline(
            hintText: 'Miqdor',
            validator: AppValidator().validate,
            prefixIcon: Icons.numbers,
            inputFormatters: [AppTextInputFormatter()],
            enableBorderColor: Colors.transparent,
            onChanged: (value) {
              if (value.isEmpty) return;
              widget.setAmount(double.parse(value.replaceAll(" ", "")));
            },
          ),
        ),
      ],
    );
  }
}
