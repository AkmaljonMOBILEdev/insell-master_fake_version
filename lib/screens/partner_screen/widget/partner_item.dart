import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import "package:http/http.dart" as http;

import '../../../database/model/counter_party_dto.dart';
import '../../../widgets/app_button.dart';


class PartnerItem extends StatefulWidget {
  const PartnerItem({Key? key, required this.counterParty, required this.index, required this.callback, required this.type}) : super(key: key);
  final CounterPartyDto counterParty;
  final String type;
  final int index;
  final Function() callback;

  @override
  State<PartnerItem> createState() => _PartnerItemState();
}

class _PartnerItemState extends State<PartnerItem> {
  MyDatabase database = Get.find<MyDatabase>();

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
                  decoration: BoxDecoration(color: AppColors.appColorGreen700, borderRadius: BorderRadius.circular(5)),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text("${widget.counterParty.counterpartyCode} ${widget.counterParty.name}", style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text('${widget.counterParty.phoneNumber}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text('${widget.counterParty.region?.name}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PartnerAddDialog(
                        counterParty: widget.counterParty,
                        type: widget.type,
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
