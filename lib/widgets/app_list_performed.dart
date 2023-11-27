import 'package:flutter/material.dart';

class AppListPerformedWidget extends StatefulWidget {
  const AppListPerformedWidget({super.key, required this.data, this.cellWidth = 200, this.backgroundColor});

  final List<List<String>> data;
  final double? cellWidth;
  final Color? backgroundColor;

  @override
  State<AppListPerformedWidget> createState() => _AppListPerformedWidgetState();
}

class _AppListPerformedWidgetState extends State<AppListPerformedWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.data.length,
      prototypeItem: PerformedItem(rowTexts: widget.data[0]),
      itemBuilder: (context, index) {
        return PerformedItem(cellWidth: widget.cellWidth, rowTexts: widget.data[index], backgroundColor: widget.backgroundColor);
      },
    );
  }
}

class PerformedItem extends StatefulWidget {
  const PerformedItem({super.key, required this.rowTexts, this.cellWidth, this.backgroundColor});

  final List<String> rowTexts;
  final double? cellWidth;
  final Color? backgroundColor;

  @override
  State<PerformedItem> createState() => _PerformedItemState();
}

class _PerformedItemState extends State<PerformedItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    widget.rowTexts.map((e) => {
      print(e)
    });

    super.build(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.rowTexts
          .map(
            (e) => Container(
              width: widget.cellWidth ?? 200,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(color: widget.backgroundColor ?? Colors.transparent, border: Border.all(color: Colors.white12)),
              child: Text(e, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
          )
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
