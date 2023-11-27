import 'package:easy_sell/screens/home_screen/report/report_dialog.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';

class ReportTypeCard extends StatefulWidget {
  const ReportTypeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.total,
    required this.type,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String total;
  final MoneyFromType type;
  final Null Function() onTap;

  @override
  State<ReportTypeCard> createState() => _ReportTypeCardState();
}

class _ReportTypeCardState extends State<ReportTypeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(widget.icon, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Expanded(child: Text(widget.total, style: const TextStyle(color: Colors.white, fontSize: 18))),
            Text(formatDate(DateTime.now()), style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
