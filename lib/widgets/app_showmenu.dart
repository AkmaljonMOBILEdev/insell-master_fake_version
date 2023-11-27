import 'package:flutter/material.dart';

void showAppMenu(
  BuildContext context,
  List<MenuItemStruct> menuItems, {
  double left = 0,
  double top = 0,
}) {
  List<PopupMenuEntry<String>> items = menuItems.map((e) {
    return PopupMenuItem<String>(
      onTap: e.onTap,
      enabled: e.enabled ?? true,
      height: 20,
      mouseCursor: SystemMouseCursors.click,
      child: e.widget,
    );
  }).toList();
  RelativeRect position = RelativeRect.fromLTRB(left, top, 0, 0);
  if (items.isEmpty) return;
  showMenu(context: context, position: position, items: items, color: Colors.black);
}

class MenuItemStruct {
  Widget widget;
  void Function()? onTap;
  bool? enabled;

  MenuItemStruct({required this.widget, required this.onTap, this.enabled});
}
