import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TransferItemsHeader extends StatefulWidget {
  const TransferItemsHeader({super.key, this.layouts, this.readOnly});

  final List<int>? layouts;
  final bool? readOnly;

  @override
  State<TransferItemsHeader> createState() => _TransferItemsHeaderState();
}

class _TransferItemsHeaderState extends State<TransferItemsHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      decoration: BoxDecoration(
          color: AppColors.appColorBlackBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: AppTableItems(
        hideBorder: true,
        layouts: widget.layouts,
        items: [
          AppTableItemStruct(
            flex: 3,
            innerWidget: const Row(
              children: [
                Icon(Icons.format_list_numbered, color: Colors.white, size: 18),
                SizedBox(width: 20),
                Text('Mahsulot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          AppTableItemStruct(
            flex: 1,
            innerWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' Taminotchi artikuli', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          AppTableItemStruct(
            flex: 1,
            innerWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' Artikul', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          AppTableItemStruct(
            flex: 1,
            innerWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' Miqdor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          if (widget.readOnly != true)
            AppTableItemStruct(
              flex: 2,
              innerWidget: const Center(child: Text('Narx', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ),
          if (widget.readOnly != true)
            AppTableItemStruct(
              flex: 2,
              innerWidget: const Center(
                  child: Text('Valyuta', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12))),
            ),
          if (widget.readOnly != true)
            AppTableItemStruct(
              flex: 1,
              innerWidget:
                  const Center(child: Text('Sotuv Narx', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ),
          if (widget.readOnly != true)
            AppTableItemStruct(
              flex: 1,
              innerWidget:
                  const Center(child: Text('Rentabil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ),
          if (widget.readOnly != true)
            AppTableItemStruct(
              flex: 1,
              innerWidget:
                  const Center(child: Text('Yaroqlilik', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ),
          if (widget.readOnly != true)
            AppTableItemStruct(
              flex: 1,
              innerWidget: const Center(
                  child: Text('Umumiy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12))),
            ),
          AppTableItemStruct(
            flex: 0,
            innerWidget: Container(width: 21),
          ),
        ],
      ),
    );
  }
}
