import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';

class WareHouseNotificationItem extends StatefulWidget {
  const WareHouseNotificationItem({super.key, required this.item, required this.index, required this.onPressed});

  final Map<String, dynamic> item;
  final int index;
  final Function onPressed;

  @override
  State<WareHouseNotificationItem> createState() => _WareHouseNotificationItemState();
}

class _WareHouseNotificationItemState extends State<WareHouseNotificationItem> {
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
          radius: 16,
          backgroundColor: AppColors.appColorGreen300,
          child: Text(
            "${widget.index}",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          "${widget.item['fromShop']['name']} dan mahsulot keldi",
          style: TextStyle(
            color: AppColors.appColorWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          formatDateTime(DateTime.fromMillisecondsSinceEpoch(widget.item['createdTime'])),
          style: TextStyle(
            color: AppColors.appColorWhite,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            widget.onPressed();
          },
          icon: Icon(
            Icons.open_in_new_outlined,
            color: AppColors.appColorWhite,
            size: 20,
          ),
        ));
  }
}
