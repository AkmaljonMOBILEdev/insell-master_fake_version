import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/client_dto.dart';
import 'client_info_dialog.dart';

class ClientItem extends StatefulWidget {
  const ClientItem({Key? key, required this.client, required this.index, required this.callback}) : super(key: key);
  final ClientDto client;
  final VoidCallback callback;
  final int index;

  @override
  State<ClientItem> createState() => _ClientItemState();
}

class _ClientItemState extends State<ClientItem> {
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
                  decoration: BoxDecoration(
                    color: AppColors.appColorGreen700,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      widget.client.gender?.name == 'MALE' ? Icons.face : Icons.face_3,
                      color: widget.client.gender?.name == 'MALE' ? Colors.blue : Colors.pinkAccent.shade100,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Text("${widget.client.clientCode} ${widget.client.name}",
                            style: TextStyle(color: AppColors.appColorWhite)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(widget.client.discountCard ?? '', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 1,
                child: Text(formatDate(widget.client.dateOfBirth), style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 1,
                child: Text('${widget.client.phoneNumber}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ClientInfoDialog(
                        client: widget.client,
                        callback: widget.callback,
                        regionData: widget.client.region,
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
