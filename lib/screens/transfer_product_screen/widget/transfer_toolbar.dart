import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TransferItemsToolbar extends StatefulWidget {
  const TransferItemsToolbar({super.key, this.layouts});

  final List<int>? layouts;

  @override
  State<TransferItemsToolbar> createState() => _TransferItemsToolbarState();
}

class _TransferItemsToolbarState extends State<TransferItemsToolbar> {
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
                Text('Mahsulot nomi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
          AppTableItemStruct(
            flex: 1,
            innerWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' Qoldiq', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          AppTableItemStruct(
            flex: 1,
            innerWidget: const Center(
                child: Text('Yaroqlilik muddati', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
