import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/shop_screen/widgets/shop_edit.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

import '../../../../../../database/model/shop_dto.dart';

class ShopItem extends StatefulWidget {
  const ShopItem({super.key, required this.shop, required this.reload});

  final ShopDto shop;
  final void Function(VoidCallback fn) reload;

  @override
  State<ShopItem> createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      hideBorder: false,
      height: 50,
      items: [
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.shop.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.shop.region.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.shop.type.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          // edit
          innerWidget: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ShopEditButton(
                  shop: widget.shop,
                  reload: widget.reload,
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            iconSize: 18,
          ),
        ),
      ],
    );
  }
}
