import 'package:easy_sell/database/model/user_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/user_screen/widgets/user_edit.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.reload, required this.user});

  final UserDto user;
  final void Function(VoidCallback fn) reload;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      hideBorder: false,
      height: 50,
      items: [
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.user.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.user.username ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget:
              Center(child: Text(widget.user.phoneNumber ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget:
              Center(child: Text(widget.user.shop?.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget:
              Center(child: Text(widget.user.pos?.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => UserEditButton(
                  user: widget.user,
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
