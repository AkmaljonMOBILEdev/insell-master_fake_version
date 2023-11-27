import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';

class MoneySendHistoryItem extends StatefulWidget {
  const MoneySendHistoryItem({Key? key, required this.callback, required this.index}) : super(key: key);

  final VoidCallback callback;
  final int index;

  @override
  State<MoneySendHistoryItem> createState() => _MoneySendHistoryItemState();
}

class _MoneySendHistoryItemState extends State<MoneySendHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 40,
      hideBorder: false,
      items: [
        AppTableItemStruct(
          flex: 10,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'fjdkfjdk',
                  style: TextStyle(color: AppColors.appColorWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        AppTableItemStruct(
          flex: 6,
          innerWidget: Center(
            child: Text('fdfdfdf', style: TextStyle(color: AppColors.appColorWhite)),
          ),
        ),
        AppTableItemStruct(
          flex: 6,
          innerWidget: Center(
            child: Text('fdfdfdf', style: TextStyle(color: AppColors.appColorWhite)),
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Center(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(color: AppColors.appColorGreen700, borderRadius: BorderRadius.circular(5)),
                  child: Text('fdfdfdf', style: TextStyle(color: AppColors.appColorWhite)))),
        ),
      ],
    );
  }
}
