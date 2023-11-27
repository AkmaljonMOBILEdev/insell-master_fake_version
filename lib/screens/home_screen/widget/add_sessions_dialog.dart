import 'dart:convert';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';
import '../../sync_screen/syn_enums.dart';
import '../../sync_screen/upload_functions.dart';
import '../report/report_dialog.dart';

class AddSessionDialog extends StatefulWidget {
  const AddSessionDialog({Key? key, required this.sessionStarted, required this.setSession, required this.employee})
      : super(key: key);
  final bool sessionStarted;
  final Function setSession;
  final EmployeeData? employee;

  @override
  State<AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  Storage storage = Storage();
  late UploadFunctions uploadFunctions;

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
  }

  void setter(void Function() fn) {}

  Future<EmployeeData?> createSession() async {
    EmployeeData? employee = await database.employeeDao.getByCardNumber(_cardNumberController.text);
    int posId = await getPosId();
    if (employee != null) {
      PosSessionCompanion newSession = PosSessionCompanion(
          pos: toValue(posId),
          cashier: toValue(employee.id),
          createdAt: toValue(DateTime.now()),
          updatedAt: toValue(DateTime.now()),
          startTime: toValue(DateTime.now()),
          sessionStartNote: toValue(_commentController.text));
      await database.posSessionDao.createOpenSession(newSession);
      await sessionIntegrate();
      return employee;
    }
    return null;
  }

  void closeSession() async {
    Get.back();
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: ReportWidget(),
        ),
      );
    }
    int posId = await getPosId();
    widget.setSession({
      'sessionStarted': false,
    });
    PosSessionData? session = await database.posSessionDao.getLastSession();
    if (session != null) {
      await database.posSessionDao.updatePosSession(
        PosSessionCompanion(
          id: toValue(session.id),
          pos: toValue(posId),
          cashier: toValue(widget.employee?.id),
          endTime: toValue(DateTime.now()),
          sessionEndNote: toValue(_commentController.text),
          updatedAt: toValue(DateTime.now()),
        ),
      );
    }
    await sessionIntegrate();
  }

  Future<void> sessionIntegrate() async {
    await uploadFunctions.autoUpload(UploadTypes.SESSIONS);
  }

  Future<int> getPosId() async {
    var user = await storage.read('user');
    var userJson = jsonDecode(user ?? '{ "pos": null }');
    if (userJson["pos"] == null) {
      return -1;
    }
    return userJson["pos"]['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        title: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          const SizedBox(height: 10),
          Text('Smena ${widget.sessionStarted ? 'Yopish' : 'Ochish'}',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ]),
        content: SizedBox(
          width: 350,
          height: 180,
          child: Column(
            children: [
              if (!widget.sessionStarted)
                AppInputUnderline(
                  controller: _cardNumberController,
                  hintText: 'Hodim kartasi',
                  prefixIcon: UniconsLine.credit_card,
                ),
              const SizedBox(height: 20),
              AppInputUnderline(
                controller: _commentController,
                maxLines: 3,
                hintText: 'Izoh',
                textInputAction: TextInputAction.newline,
                prefixIcon: UniconsLine.comment_alt,
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            onTap: () async {
              if (widget.sessionStarted) {
                closeSession();
              } else {
                EmployeeData? employee = await createSession();
                if (employee != null) {
                  widget.setSession({'sessionStarted': true, 'employee': employee, 'sessionStartedTime': DateTime.now()});
                  Get.back();
                } else {
                  if (context.mounted) {
                    await showAppAlertDialog(context,
                        title: 'Xatolik', message: 'Hodim topilmadi', buttonLabel: 'ok', cancelLabel: 'Bekor qilish');
                  }
                }
              }
            },
            width: 180,
            height: 40,
            color: AppColors.appColorGreen300.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            hoverRadius: BorderRadius.circular(15),
            hoverColor: AppColors.appColorGreen400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Saqlash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
