import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../database/my_database.dart';
import '../constants/colors.dart';

class AppCalendarDialog extends StatefulWidget {
  const AppCalendarDialog({Key? key, required this.callback}) : super(key: key);
  final void Function(DateTime startDate, DateTime? endDate) callback;

  @override
  State<AppCalendarDialog> createState() => _AppCalendarDialogState();
}

class _AppCalendarDialogState extends State<AppCalendarDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  String get lang => 'uz';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: AlertDialog(
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 30),
                ),
              ),
            ],
          ),
        ),
        content: SizedBox(
          height: 300,
          width: 480,
          child: Column(
            children: [
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    _startDate = args.value.startDate;
                    _endDate = args.value.endDate;
                    print(_startDate);
                    print(_endDate);
                  }
                },
                headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(color: AppColors.appColorWhite),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: TextStyle(color: AppColors.appColorWhite),
                  weekendTextStyle: TextStyle(color: AppColors.appColorWhite),
                  todayTextStyle: TextStyle(color: AppColors.appColorWhite),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                yearCellStyle: DateRangePickerYearCellStyle(
                  textStyle: TextStyle(color: AppColors.appColorWhite),
                ),
                // initialSelectedRange: PickerDateRange(
                //   DateTime.now().subtract(const Duration(days: 4)),
                //   DateTime.now().add(const Duration(days: 3)),
                // ),
                view: DateRangePickerView.month,
                headerHeight: 30,
                backgroundColor: Colors.grey.shade900,
                todayHighlightColor: AppColors.appColorGreen400,
                selectionColor: Colors.green,
                selectionRadius: 15,
                showActionButtons: false,
                showNavigationArrow: true,
                toggleDaySelection: false,
                enableMultiView: false,
                selectionTextStyle: TextStyle(color: AppColors.appColorGreen400),
                rangeTextStyle: const TextStyle(color: Colors.black),
                startRangeSelectionColor: Colors.green.shade900,
                endRangeSelectionColor: Colors.green.shade900,
                rangeSelectionColor: Colors.green.shade300, // Range background color
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      onTap: () async {
                        widget.callback(_startDate, _endDate);
                        Navigator.of(context).pop();
                      },
                      width: 200,
                      height: 35,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      elevation: 1,
                      borderRadius: BorderRadius.circular(15),
                      hoverRadius: BorderRadius.circular(15),
                      splashColor: Colors.blue.shade700,
                      color: AppColors.appColorGreen400,
                      child: const Center(
                        child: Text(
                          'Saqlash',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
