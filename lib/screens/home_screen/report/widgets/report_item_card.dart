import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/utils.dart';

class ReportItemCard extends StatefulWidget {
  const ReportItemCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.icon,
      required this.color,
      required this.moneysByType,
      this.average,
      this.types});

  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final List<double> moneysByType;
  final String? average;
  final List<Widget>? types;

  @override
  State<ReportItemCard> createState() => _ReportItemCardState();
}

class _ReportItemCardState extends State<ReportItemCard> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(5),
                  child: Icon(widget.icon, color: AppColors.appColorWhite, size: 22),
                ),
                const SizedBox(width: 10),
                Text(widget.title, style: TextStyle(color: AppColors.appColorGrey400, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 5),
            Text(widget.amount, style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
            const SizedBox(height: 5),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.types != null
                        ? widget.types![0]
                        : Row(
                            children: [
                              const Icon(UniconsLine.money_bill, color: Colors.green, size: 18),
                              const SizedBox(width: 5),
                              Text("Naqd", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                            ],
                          ),
                    Text(formatNumber(widget.moneysByType[0]), style: TextStyle(color: AppColors.appColorWhite, fontSize: 13)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.types != null
                        ? widget.types![1]
                        : Row(
                            children: [
                              const Icon(UniconsLine.credit_card, color: Colors.grey, size: 18),
                              const SizedBox(width: 5),
                              Text('Karta', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                            ],
                          ),
                    Text(formatNumber(widget.moneysByType[1]), style: TextStyle(color: AppColors.appColorWhite, fontSize: 13)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.types != null
                        ? widget.types![2]
                        : Row(
                            children: [
                              const Icon(Icons.account_balance, color: Colors.blue, size: 18),
                              const SizedBox(width: 5),
                              Text('Bank', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                            ],
                          ),
                    Text(formatNumber(widget.moneysByType[2]), style: TextStyle(color: AppColors.appColorWhite, fontSize: 13)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.types != null
                        ? widget.types![3]
                        : Row(
                            children: [
                              const Icon(Icons.cached_sharp, color: Colors.yellow, size: 18),
                              const SizedBox(width: 5),
                              Text('Cashback', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                            ],
                          ),
                    widget.types != null
                        ? widget.types![3]
                        : Text(formatNumber(widget.moneysByType[3]),
                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
