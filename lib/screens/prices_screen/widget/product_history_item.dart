import 'dart:convert';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

class ProductHistoryItem extends StatefulWidget {
  const ProductHistoryItem({super.key, required this.priceData, required this.index});

  final int index;
  final PriceData priceData;

  @override
  State<ProductHistoryItem> createState() => _ProductHistoryItemState();
}

class _ProductHistoryItemState extends State<ProductHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 40,
      items: [
        AppTableItemStruct(
          flex: 0,
          innerWidget: Container(
            color: widget.priceData.isSynced ? Colors.green : Colors.transparent,
            constraints: const BoxConstraints(
              minWidth: 50,
            ),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                "${widget.index + 1}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(widget.priceData.value),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatDateTime(widget.priceData.createdAt),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: FutureBuilder(
                future: HttpServices.get("/price/${widget.priceData.serverId}"),
                builder: (context, snapshot) {
                  var json = jsonDecode(snapshot.data?.body ?? "{}");
                  int? createdBy = json["createdBy"];
                  if (createdBy == null) return const Text("");
                  if (snapshot.hasData) {
                    return FutureBuilder(
                        future: HttpServices.get("/user/$createdBy"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var json = jsonDecode(snapshot.data?.body ?? "");
                            return Text(
                              json["name"],
                              style: const TextStyle(color: Colors.white),
                            );
                          } else {
                            return const CircularProgressIndicator(color: Colors.white);
                          }
                        });
                  } else {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                }),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: FutureBuilder(
                future: HttpServices.get("/price/${widget.priceData.serverId}"),
                builder: (context, snapshot) {
                  var json = jsonDecode(snapshot.data?.body ?? "{}");
                  int? createdBy = json["updatedBy"];
                  if (createdBy == null) return const Text("");
                  if (snapshot.hasData) {
                    return FutureBuilder(
                        future: HttpServices.get("/user/$createdBy"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var json = jsonDecode(snapshot.data?.body ?? "");
                            return Text(
                              json["name"],
                              style: const TextStyle(color: Colors.white),
                            );
                          } else {
                            return const CircularProgressIndicator(color: Colors.white);
                          }
                        });
                  } else {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                }),
          ),
        ),
      ],
    );
  }
}
