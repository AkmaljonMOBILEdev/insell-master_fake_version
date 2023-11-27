import 'dart:convert';

import 'package:easy_sell/database/table/pos_table.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class MoneySendRightContainers extends StatefulWidget {
  const MoneySendRightContainers({Key? key, required this.callback, required this.allMoneySendsLength, this.myPos})
      : super(key: key);
  final int allMoneySendsLength;
  final Function callback;
  final POSData? myPos;

  @override
  State<MoneySendRightContainers> createState() => _MoneySendRightContainersState();
}

class _MoneySendRightContainersState extends State<MoneySendRightContainers> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();
  bool _showAddMoneySend = false;
  List<POSData> allPos = [];
  POSData? selectedPos;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late UploadFunctions uploadFunctions;
  late MoneyCalculatorService moneyCalculatorService;
  int? myPosServerId;
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
    moneyCalculatorService = MoneyCalculatorService(database: database);
    getAllPos();
    getMyPosServerId();
  }

  void getMyPosServerId() async {
    String? userString = await storage.read('user');
    var user = jsonDecode(userString ?? '{}');
    if (user['pos'] == null) return;
    setState(() {
      myPosServerId = user['pos']['id'];
    });
  }

  void setter(void Function() fn) {}

  void getAllPos() async {
    allPos = await database.posDao.getAllPos();
    PosType? myPosType = widget.myPos?.type;
    PosType filterTermType = myPosType == PosType.SHOP ? PosType.SHOP_MAIN : PosType.MAIN;
    allPos.removeWhere((element) => element.type != (myPosType != null ? filterTermType : null));
    setState(() {});
  }

  Future<void> sync() async {
    try {
      await widget.callback();
      setState(() {
        _showAddMoneySend = false;
      });
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, 'Xatolik yuz berdi $e', 'OK', isError: true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant MoneySendRightContainers oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAllPos();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedContainer(
          height: _showAddMoneySend == true ? 0 : 100,
          width: screenWidth / 3.99,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.appColorBlackBg),
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 40),
                          Text(" Pul o'tkazmalar:", style: TextStyle(color: AppColors.appColorWhite)),
                        ],
                      ),
                      Row(
                        children: [Text(widget.allMoneySendsLength.toString(), style: TextStyle(color: AppColors.appColorWhite))],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: _showAddMoneySend
              ? AnimatedContainer(
                  height: _showAddMoneySend == true ? screenHeight / 1.12 : screenHeight / 1.573,
                  width: screenWidth / 3.99,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.appColorBlackBg),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: Form(
                    key: _formValidation,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _showAddMoneySend = false;
                              });
                            },
                            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text("Pul ot'kazma malumotlarini kiriting",
                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                        ),
                        AppInputUnderline(
                          controller: _amountController,
                          hintText: "To'lov summasi",
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.money_stack,
                          iconSize: 20,
                          keyboardType: TextInputType.number,
                          inputFormatters: [AppTextInputFormatter()],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: AppAutoComplete(
                                getValue: (AutocompleteDataStruct value) {
                                  setState(() {
                                    selectedPos = allPos.firstWhereOrNull(
                                        (element) => element.id == value.uniqueId && element.name == value.value);
                                  });
                                },
                                options: allPos
                                    .map((e) => AutocompleteDataStruct(
                                          value: e.name,
                                          uniqueId: e.id,
                                        ))
                                    .toList(),
                                hintText: 'Oluvchi kassani tanlang',
                                prefixIcon: UniconsLine.money_withdraw,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        AppInputUnderline(
                          hintText: "Izoh",
                          controller: _descriptionController,
                          maxLines: 3,
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.comment_alt,
                          iconSize: 20,
                          iconColor: AppColors.appColorWhite,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                              onTap: () => _clearFields(),
                              height: 40,
                              width: 40,
                              borderRadius: BorderRadius.circular(15),
                              hoverRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Icon(Icons.cleaning_services_rounded, color: AppColors.appColorWhite),
                              ),
                            ),
                            AppButton(
                              tooltip: '',
                              onTap: () async {
                                try {
                                  if (_formValidation.currentState!.validate()) {
                                    if (selectedPos == null) {
                                      throw 'Oluvchi kassani tanlang';
                                    }
                                    double amount = double.parse(_amountController.text.replaceAll(" ", ""));
                                    var request = {
                                      "fromPosId": myPosServerId,
                                      "toPosId": selectedPos?.serverId,
                                      "amount": amount,
                                      "payType": "CASH",
                                      "description": _descriptionController.text,
                                    };
                                    var response = await HttpServices.post('/pos-transfer/create', request);
                                    print(response.body);
                                    if (response.statusCode == 200) {
                                      await sync();
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showAppSnackBar(context, 'Xatolik yuz berdi $e', 'OK', isError: true);
                                  }
                                }
                              },
                              width: 180,
                              height: 40,
                              color: AppColors.appColorGreen400,
                              hoverColor: AppColors.appColorGreen300,
                              colorOnClick: AppColors.appColorGreen700,
                              splashColor: AppColors.appColorGreen700,
                              borderRadius: BorderRadius.circular(15),
                              hoverRadius: BorderRadius.circular(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Saqlash',
                                      style: TextStyle(
                                          color: AppColors.appColorWhite,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 1)),
                                  Icon(UniconsLine.save, color: AppColors.appColorWhite, size: 18)
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                )
              : AppButton(
                  onTap: () {
                    if (widget.myPos?.type != PosType.MAIN) {
                      setState(() {
                        _showAddMoneySend = true;
                      });
                    }
                  },
                  width: screenWidth / 3.99,
                  height: screenHeight / 1.573,
                  borderRadius: BorderRadius.circular(20),
                  hoverRadius: BorderRadius.circular(20),
                  color: (widget.myPos?.type != PosType.MAIN)
                      ? AppColors.appColorBlackBg
                      : AppColors.appColorBlackBg.withOpacity(0.7),
                  child: (widget.myPos?.type != PosType.MAIN)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(UniconsLine.money_bill, color: AppColors.appColorGreen400, size: 40),
                                Icon(Icons.add_rounded, color: AppColors.appColorGreen400, size: 25),
                              ],
                            ),
                            Text("Pul o'tkazmani kiritish", style: TextStyle(color: AppColors.appColorWhite, fontSize: 22))
                          ],
                        )
                      : null),
        ),
      ],
    );
  }

  void _clearFields() {
    _amountController.clear();
    _descriptionController.clear();
  }
}
