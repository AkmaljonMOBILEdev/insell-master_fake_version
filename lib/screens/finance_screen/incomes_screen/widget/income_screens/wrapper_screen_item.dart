import 'package:easy_sell/database/model/income_dto.dart';
import 'package:easy_sell/screens/finance_screen/finance_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/utils.dart';

class WrapperScreenItem extends StatefulWidget {
  const WrapperScreenItem({super.key, required this.income, required this.index, required this.callback, required this.type});

  final IncomeDto income;
  final int index;
  final void Function() callback;
  final IncomeWrapperScreenType type;

  @override
  State<WrapperScreenItem> createState() => _WrapperScreenItemState();
}

class _WrapperScreenItemState extends State<WrapperScreenItem> {
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.appColorGreen700),
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
                    returnName(widget.income),
                    style: TextStyle(color: AppColors.appColorWhite),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatNumber(widget.income.invoice?.amount), style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatDate(widget.income.createdTime), style: TextStyle(color: AppColors.appColorWhite)),
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

  String returnName(IncomeDto income) {
    switch (widget.type) {
      case IncomeWrapperScreenType.PAY_FROM_CLIENT:
        return '${income.client?.clientCode} ${income.client?.name}';
      case IncomeWrapperScreenType.PAY_FROM_BANK:
        return '${income.counterParty?.counterpartyCode} ${income.counterParty?.name}';
      case IncomeWrapperScreenType.PAY_FROM_COUNTERPARTY:
        return income.counterParty?.name ?? '';
      case IncomeWrapperScreenType.PAY_FROM_OTHER_ORG:
        return income.counterParty?.name ?? '';
      case IncomeWrapperScreenType.RETURN_FROM_SUPPLIER:
        return '${income.supplier?.supplierCode} ${income.supplier?.name}';
      case IncomeWrapperScreenType.PAY_FROM_OTHER_CASH:
        return income.fromPos?.name ?? "";
      case IncomeWrapperScreenType.PAY_FROM_EMPLOYEE:
        return income.employee?.name ?? '';
      case IncomeWrapperScreenType.PAY_FROM_CREDIT:
        return income.counterParty?.name ?? '';
      case IncomeWrapperScreenType.PAY_OTHER:
        return income.description ?? 'Boshqa';
      default:
        return '-';
    }
  }
}
