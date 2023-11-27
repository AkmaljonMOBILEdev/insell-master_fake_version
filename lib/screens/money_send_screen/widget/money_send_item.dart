import 'package:easy_sell/database/model/pos_transfer_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import "package:http/http.dart" as http;

class MoneySendItem extends StatefulWidget {
  const MoneySendItem({Key? key, required this.item, required this.index, this.myPos, required this.sync}) : super(key: key);
  final PosTransferDto item;
  final int index;
  final POSData? myPos;
  final Function sync;

  @override
  State<MoneySendItem> createState() => _MoneySendItemState();
}

class _MoneySendItemState extends State<MoneySendItem> {
  MyDatabase database = Get.find<MyDatabase>();
  late MoneyCalculatorService moneyCalculatorService;
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    moneyCalculatorService = MoneyCalculatorService(database: database);
  }

  void accept(bool isAccept) async {
    try {
      http.Response res = await HttpServices.patch(
          "/pos-transfer/change-status/${widget.item.id}?status=${isAccept ? PosTransferStatus.CONFIRMED.name : PosTransferStatus.CANCELED.name}",
          {});
      if (res.statusCode == 200) {
        await widget.sync();
        Get.back();
      }
      if (mounted) {
        showAppSnackBar(context, "Pul o'tkazmasi ${isAccept ? 'qabul' : 'rad'} qilindi", "OK");
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, "Xatolik: $e", "OK", isError: true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                  child: Text(widget.item.fromPos?.name ?? '<Nomalum>', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text('${widget.item.toPos?.name}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(formatDateTime(widget.item.createdAt), style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    child: Text(formatNumber(widget.item.amount), style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Tooltip(
                  message: widget.item.status == PosTransferStatus.CREATED
                      ? "Pul o'tkazmasi jarayonda..."
                      : widget.item.status == PosTransferStatus.CANCELED
                          ? "Pul o'tkazmasi rad qilindi"
                          : "Pul o'tkazmasi qabul qilindi",
                  child: widget.item.status == PosTransferStatus.CREATED
                      ? IconButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
                            backgroundColor: (widget.myPos?.id == widget.item.fromPos?.id)
                                ? MaterialStateProperty.all(Colors.transparent)
                                : MaterialStateProperty.all(AppColors.appColorGrey700.withOpacity(0.4)),
                          ),
                          hoverColor: AppColors.appColorGrey700,
                          icon: const Icon(Icons.schedule, color: Colors.deepOrangeAccent, size: 21),
                          onPressed: (widget.myPos?.id == widget.item.fromPos?.id)
                              ? null
                              : () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor: AppColors.appColorBlackBg,
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text('Diqqat!', style: TextStyle(color: Colors.redAccent)),
                                                const SizedBox(width: 5),
                                                IconButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    icon: const Icon(
                                                      UniconsLine.times_circle,
                                                      color: Colors.redAccent,
                                                    ))
                                              ],
                                            ),
                                            content: const Text(
                                              'Pul o\'tkazmasini qabul qilasizmi?',
                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                            ),
                                            actions: [
                                              AppButton(
                                                onTap: () async {
                                                  accept(false);
                                                },
                                                width: 100,
                                                height: 35,
                                                color: AppColors.appColorRed400,
                                                hoverColor: AppColors.appColorRed300,
                                                colorOnClick: AppColors.appColorGreen400.withOpacity(0.5),
                                                splashColor: AppColors.appColorGreen400.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(15),
                                                hoverRadius: BorderRadius.circular(15),
                                                child: Center(
                                                    child: Text('Rad etish', style: TextStyle(color: AppColors.appColorWhite))),
                                              ),
                                              AppButton(
                                                onTap: () async {
                                                  accept(true);
                                                },
                                                width: 100,
                                                height: 35,
                                                color: AppColors.appColorGreen400,
                                                hoverColor: AppColors.appColorGreen300,
                                                colorOnClick: AppColors.appColorGreen700,
                                                splashColor: AppColors.appColorGreen700,
                                                borderRadius: BorderRadius.circular(15),
                                                hoverRadius: BorderRadius.circular(15),
                                                child: Center(
                                                    child:
                                                        Text('Qabul qilish', style: TextStyle(color: AppColors.appColorWhite))),
                                              ),
                                            ],
                                          ));
                                },
                        )
                      : IconButton(
                          onPressed: null,
                          icon: widget.item.status == PosTransferStatus.CANCELED
                              ? const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 21)
                              : const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 21),
                        ),
                ),
              )
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.white24,
        ),
      ],
    );
  }
}
