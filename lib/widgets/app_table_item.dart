import 'package:easy_sell/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTableItemStruct {
  Widget? innerWidget = Container();
  int? flex = 1;
  BoxDecoration? decoration;
  bool? hideBorder = false;

  AppTableItemStruct({this.innerWidget, this.flex, this.decoration, this.hideBorder});
}

class AppTableItems extends StatefulWidget {
  const AppTableItems({super.key, required this.items, this.height, this.hideBorder = false, this.margin, this.layouts, this.backgroundColor})
      : assert(layouts == null || layouts.length == items.length);

  final List<AppTableItemStruct> items;
  final double? height;
  final bool? hideBorder;
  final EdgeInsets? margin;
  final List<int>? layouts;
  final Color? backgroundColor;

  @override
  State<AppTableItems> createState() => _AppTableItemsState();
}

class _AppTableItemsState extends State<AppTableItems> {
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent
        ),
        height: widget.height,
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items
              .map((item) => Expanded(
                    flex: widget.layouts != null ? widget.layouts![widget.items.indexOf(item)] : item.flex ?? 1,
                    child: Container(
                      margin: widget.margin,
                      constraints: const BoxConstraints(minHeight: 40),
                      decoration: widget.hideBorder == true
                          ? null
                          : item.hideBorder == true
                              ? null
                              : (item.decoration ??
                                  BoxDecoration(border: Border.all(width: 0.1, color: AppColors.appColorGrey300))),
                      child: item.innerWidget ?? Container(),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
