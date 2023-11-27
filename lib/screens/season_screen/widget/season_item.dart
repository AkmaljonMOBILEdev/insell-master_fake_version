import 'package:easy_sell/database/model/season_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';

class SeasonItem extends StatefulWidget {
  const SeasonItem({Key? key, required this.item, required this.index}) : super(key: key);
  final Season item;
  final int index;

  @override
  State<SeasonItem> createState() => _SeasonItemState();
}

class _SeasonItemState extends State<SeasonItem> {
  MyDatabase database = Get.find<MyDatabase>();
  late MoneyCalculatorService moneyCalculatorService;
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
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
                  decoration: BoxDecoration(
                      // color: widget.item.posTransferData.isSynced ? AppColors.appColorGreen700 : Colors.white12,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(widget.item.name, style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatDateTime(widget.item.startDate), style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatDateTime(widget.item.endDate), style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              const Expanded(
                flex: 0,
                child: SizedBox(),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white24),
      ],
    );
  }
}
