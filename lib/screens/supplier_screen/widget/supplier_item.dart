import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/supplier_screen/widget/supplier_info_dialog.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';

class SupplierItem extends StatefulWidget {
  const SupplierItem({Key? key, required this.supplier, required this.index, required this.callback}) : super(key: key);
  final SupplierDto supplier;
  final VoidCallback callback;
  final int index;

  @override
  State<SupplierItem> createState() => _SupplierItemState();
}

class _SupplierItemState extends State<SupplierItem> {
  MyDatabase database = Get.find<MyDatabase>();
  late MoneyCalculatorService moneyCalculatorService;
  double supplierDebt = 0;

  @override
  void initState() {
    super.initState();
    moneyCalculatorService = MoneyCalculatorService(database: database);
    _getSupplierDebt();
  }

  _getSupplierDebt() async {
    setState(() {});
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
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(Icons.face, color: Colors.blue, size: 20),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.supplier.supplierCode} ${widget.supplier.name}", style: TextStyle(color: AppColors.appColorWhite)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(widget.supplier.supplierOrganization?.name ?? '-', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 1,
                child: Text(widget.supplier.phoneNumber ?? '-', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SupplierInfoDialog(
                        supplier: widget.supplier,
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
              // AppButton(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return SupplierDebtInfo(
              //           supplier: widget.supplier,
              //           supplierDebt: supplierDebt,
              //         );
              //       },
              //     );
              //   },
              //   width: 30,
              //   height: 30,
              //   borderRadius: BorderRadius.circular(10),
              //   hoverRadius: BorderRadius.circular(10),
              //   hoverColor: AppColors.appColorGrey700,
              //   child: Center(child: Icon(UniconsLine.money_withdrawal, color: AppColors.appColorGreen400, size: 20)),
              // ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white24),
      ],
    );
  }
}
