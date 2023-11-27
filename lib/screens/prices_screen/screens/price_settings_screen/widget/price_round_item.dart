import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../constants/colors.dart';
import '../../../../../database/model/price_rounded_dto.dart';
import 'add_price_rounding_dialog.dart';

class PriceRoundItem extends StatefulWidget {
  const PriceRoundItem({Key? key, required this.index, required this.callback, required this.roundedDto}) : super(key: key);
  final PriceRoundedDto roundedDto;
  final VoidCallback callback;
  final int index;

  @override
  State<PriceRoundItem> createState() => _PriceRoundItemState();
}

class _PriceRoundItemState extends State<PriceRoundItem> {
  MyDatabase database = Get.find<MyDatabase>();
  late MoneyCalculatorService moneyCalculatorService;

  @override
  void initState() {
    super.initState();
    moneyCalculatorService = MoneyCalculatorService(database: database);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(color: AppColors.appColorGreen700, borderRadius: BorderRadius.circular(5)),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(widget.roundedDto.name, style: TextStyle(color: AppColors.appColorWhite)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(formatDateTimeEpoch(widget.roundedDto.createdAt), style: TextStyle(color: AppColors.appColorWhite)),
              ),
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddPriceRoundingDialog(
                        roundedDto: widget.roundedDto,
                        callback: widget.callback,
                      );
                    },
                  );
                },
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(10),
                hoverRadius: BorderRadius.circular(10),
                hoverColor: AppColors.appColorGreen300,
                child: Center(child: Icon(UniconsLine.eye, color: AppColors.appColorWhite, size: 20)),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white24),
      ],
    );
  }
}
