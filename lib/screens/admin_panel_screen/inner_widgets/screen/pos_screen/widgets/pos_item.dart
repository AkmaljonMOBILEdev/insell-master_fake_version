import 'package:easy_sell/database/model/pos_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/pos_screen/widgets/pos_edit.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

class PosItem extends StatefulWidget {
  const PosItem({super.key, required this.reload, required this.pos});

  final PosDto pos;
  final void Function(VoidCallback fn) reload;

  @override
  State<PosItem> createState() => _PosItemState();
}

class _PosItemState extends State<PosItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      hideBorder: false,
      height: 50,
      items: [
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.pos.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.pos.shop.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          // edit
          innerWidget: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PosEditButton(
                  pos: widget.pos,
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
