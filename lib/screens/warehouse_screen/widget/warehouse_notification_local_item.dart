import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/transfer_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';

class WareHouseLocalNotificationItem extends StatefulWidget {
  const WareHouseLocalNotificationItem({super.key, required this.item, required this.index, required this.onPressed});

  final TransferDto item;
  final int index;
  final Function onPressed;

  @override
  State<WareHouseLocalNotificationItem> createState() => _WareHouseLocalNotificationItemState();
}

class _WareHouseLocalNotificationItemState extends State<WareHouseLocalNotificationItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        widget.onPressed();
      },
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: AppColors.appColorGreen300,
        child: Text("${widget.index}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
      title: Text('"${widget.item.fromShop?.name}"  dan mahsulot keldi', style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.bold)),
      subtitle: Text(formatDateTime((widget.item.createdTime)), style: TextStyle(color: AppColors.appColorWhite)),
      trailing: AppButton(
        onTap: () {
          widget.onPressed();
        },
        width: 35,
        height: 35,
        borderRadius: BorderRadius.circular(12),
        hoverRadius: BorderRadius.circular(12),
        hoverColor: AppColors.appColorGreen400,
        child: Icon(Icons.open_in_new_rounded, color: AppColors.appColorWhite, size: 22),
      ),
    );
  }
}
