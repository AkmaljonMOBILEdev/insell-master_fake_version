import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class ReportHeader extends StatefulWidget {
  const ReportHeader({super.key, required this.headers, this.backgroundColor, this.borderRadius});

  final List<HeaderStruct> headers;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<ReportHeader> createState() => _ReportHeaderState();
}

class _ReportHeaderState extends State<ReportHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var item in widget.headers)
            Expanded(
              flex: item.flex ?? 1,
              child: InkWell(
                onTap: item.sort,
                child: Row(
                  mainAxisAlignment: item.index == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    if (item.activeIndex == item.index)
                      Icon(
                        item.desc ? Icons.arrow_downward : Icons.arrow_upward,
                        color: AppColors.appColorWhite,
                        size: 18,
                      ),
                    const SizedBox(width: 5),
                    Text(
                      item.title,
                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HeaderStruct {
  final String title;
  final int index;
  final int activeIndex;
  final bool desc;
  final Function()? sort;
  final int? flex;

  HeaderStruct(
      {required this.title, required this.index, this.sort, required this.activeIndex, required this.desc, this.flex = 1});
}
