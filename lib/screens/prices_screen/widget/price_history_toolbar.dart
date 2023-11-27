import 'package:flutter/material.dart';
import '../../../widgets/app_table_item.dart';

class PriceHistoryToolbar extends StatefulWidget {
  const PriceHistoryToolbar({super.key});

  @override
  State<PriceHistoryToolbar> createState() => _PriceHistoryToolbarState();
}

class _PriceHistoryToolbarState extends State<PriceHistoryToolbar> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 40,
      items: [
        AppTableItemStruct(
          flex: 0,
          innerWidget: Container(
            constraints: const BoxConstraints(
              minWidth: 50,
            ),
            padding: const EdgeInsets.all(10),
            child: const Center(
              child: Text(
                "#",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: const Center(
            child: Text(
              'Narxi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: const Center(
            child: Text(
              'Sana',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: const Center(
            child: Text(
              "Yaratilgan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: const Center(
            child: Text(
              "O'zgartirilgan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
