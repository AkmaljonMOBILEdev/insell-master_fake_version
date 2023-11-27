import 'package:easy_sell/database/model/transfer_dto.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_info_product_dialog.dart';
import 'package:easy_sell/utils/translator.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_button.dart';

class MoveProductItem extends StatefulWidget {
  const MoveProductItem({Key? key, required this.index, required this.transferItem, required this.update}) : super(key: key);
  final int index;
  final TransferDto transferItem;
  final Null Function() update;

  @override
  State<MoveProductItem> createState() => _MoveProductItemState();
}

class _MoveProductItemState extends State<MoveProductItem> {
  String selectedUnit = 'PENDING';
  List<String> dropdownItems = ['PENDING', 'IN_PROGRESS', 'CANCELED', 'COMPLETED'];

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.transferItem.status.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 35,
          child: Row(
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
              Expanded(
                flex: 2,
                child: Text('${widget.transferItem.fromShop?.name}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 2,
                child: Text('${widget.transferItem.toShop?.name}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 1,
                child: Text(formatDateTime(widget.transferItem.createdAt), style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                      decoration: BoxDecoration(color: color(), borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(translate(selectedUnit), style: TextStyle(color: AppColors.appColorWhite)),
                        ],
                      ),
                    ),
                    AppButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TransferInfoProductDialog(
                              transferItem: widget.transferItem,
                              update: widget.update,
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

  MaterialColor color() {
    switch (selectedUnit) {
      case 'PENDING':
        return Colors.deepOrange;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'CANCELED':
        return Colors.red;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }
}
