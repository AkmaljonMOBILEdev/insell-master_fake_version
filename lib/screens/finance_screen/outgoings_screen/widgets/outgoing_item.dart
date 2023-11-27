import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;

import '../../../../constants/colors.dart';
import '../../../../database/model/outgoing_dto.dart';

class OutgoingItem extends StatefulWidget {
  const OutgoingItem({Key? key, required this.outgoingDto, required this.index, required this.callback}) : super(key: key);
  final OutgoingDto? outgoingDto;
  final int index;
  final Function() callback;

  @override
  State<OutgoingItem> createState() => _OutgoingItemState();
}

class _OutgoingItemState extends State<OutgoingItem> {
  MyDatabase database = Get.find<MyDatabase>();

  @override
  void initState() {
    super.initState();
    print(widget.outgoingDto?.expenseDto?.name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    '${widget.index + 1}',
                    style: TextStyle(color: AppColors.appColorWhite),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(
                    "${widget.outgoingDto?.supplierDto?.name ?? widget.outgoingDto?.counterparty?.name ?? widget.outgoingDto?.toPos?.name ?? widget.outgoingDto?.expenseDto?.name}",
                    style: TextStyle(color: AppColors.appColorWhite),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatNumber(widget.outgoingDto?.invoiceDto?.amount), style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatDateTimeEpoch(widget.outgoingDto!.createdTime), style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(flex: 0, child: Container()),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white24),
      ],
    );
  }
}
