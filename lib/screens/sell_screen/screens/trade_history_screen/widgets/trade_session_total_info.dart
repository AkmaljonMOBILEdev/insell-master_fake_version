import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../constants/colors.dart';
import '../../../../../database/model/trade_dto.dart';
import '../../../../../utils/utils.dart';

class TradeSessionTotalInfo extends StatelessWidget {
  const TradeSessionTotalInfo({super.key, required this.filteredTrades, required this.tradesCount, required this.returnedTradesCount, required this.tradesTotalSum, required this.returnedTradesTotalSum, required this.paymentsTotalSum, required this.paymentCashTotal, required this.paymentCardTotal});
  final List<TradeDTO> filteredTrades;
  final int tradesCount;
  final int returnedTradesCount;
  final double tradesTotalSum;
  final double returnedTradesTotalSum;
  final double paymentsTotalSum;
  final double paymentCashTotal;
  final double paymentCardTotal;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(17)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.keyboard_double_arrow_up_rounded, color: AppColors.appColorGreen400, size: 23),
                  Row(
                    children: [
                      Text('Savdolar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text('$tradesCount ta', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.keyboard_double_arrow_down_rounded, color: AppColors.appColorRed300, size: 23),
                  Row(
                    children: [
                      Text('Vozvratlar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text('$returnedTradesCount ta', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.blueGrey, size: 23),
                  Row(
                    children: [
                      Text('Mijozlar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text('${filteredTrades.length - returnedTradesCount} ta', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const VerticalDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(UniconsLine.shopping_cart_alt, color: AppColors.appColorGreen400, size: 23),
                  Row(
                    children: [
                      Text('Umumiy savdo: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text(formatNumber(tradesTotalSum), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.arrow_upward_rounded, color: AppColors.appColorRed300, size: 23),
                  Row(
                    children: [
                      Text('Umumiy vozvrat: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text(formatNumber(returnedTradesTotalSum), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.arrow_downward_rounded, color: AppColors.appColorGreen400, size: 23),
                  Row(
                    children: [
                      Text('Umumiy kirim: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text(formatNumber(paymentsTotalSum - returnedTradesTotalSum), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),

            ],
          ),
          const VerticalDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(UniconsLine.money_bill, color: Colors.blue, size: 23),
                  Row(
                    children: [
                      Text('Naqd : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text(formatNumber(paymentCashTotal), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(UniconsLine.credit_card, color: Colors.orange, size: 23),
                  Row(
                    children: [
                      Text('Karta : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text(formatNumber(paymentCardTotal), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.align_vertical_bottom, color: Colors.blueGrey, size: 23),
                  Row(
                    children: [
                      Text('Or\'tacha chek : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                      Text(formatNumber(tradesTotalSum / (filteredTrades.length - returnedTradesCount)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
