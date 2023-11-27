import 'dart:convert';
import 'package:easy_sell/screens/money_send_screen/widget/money_send_item.dart';
import 'package:easy_sell/screens/money_send_screen/widget/money_send_item_info.dart';
import 'package:easy_sell/screens/money_send_screen/widget/money_send_right_containers.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/colors.dart';
import '../../database/model/pos_transfer_dto.dart';
import '../../database/my_database.dart';
import '../../widgets/app_autocomplete.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_underline.dart';

class MoneySendScreen extends StatefulWidget {
  const MoneySendScreen({Key? key}) : super(key: key);

  @override
  State<MoneySendScreen> createState() => _MoneySendScreenState();
}

class _MoneySendScreenState extends State<MoneySendScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  bool _isSynced = false;
  bool loading = false;
  int offset = 0;
  int limit = 50;
  bool _sortByName = false;
  List<PosTransferDto> allPosTransfer = [];
  POSData? myPos;
  int myShopId = 0;

  @override
  void initState() {
    super.initState();
    getMyPos();
    getAllPosTransfer();
  }

  void getAllPosTransfer() async {
    setState(() {
      loading = true;
    });
    var res = await HttpServices.get("/pos-transfer/all/pos");
    List<PosTransferDto> allPosTransfer_ = [];
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['data'];
      for (var item in body) {
        allPosTransfer_.add(PosTransferDto.fromJson(item));
      }
    }
    setState(() {
      allPosTransfer = allPosTransfer_;
    });
    setState(() {
      loading = false;
    });
  }

  void getMyPos() async {
    var userString = await storage.read('user');
    Map<String, dynamic> user = userString != null ? await jsonDecode(userString) : {};
    int myPosServerId = user['pos'] == null ? 0 : user['pos']['id'];
    POSData? myPos_ = await database.posDao.getPosByServerId(myPosServerId);
    if (myPos_ != null) {
      setState(() {
        myShopId = user['shop']['id'];
        myPos = myPos_;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        leading: AppButton(
          onTap: () => Get.back(),
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(7),
          color: AppColors.appColorGrey700.withOpacity(0.5),
          hoverColor: AppColors.appColorGreen300,
          colorOnClick: AppColors.appColorGreen700,
          splashColor: AppColors.appColorGreen700,
          borderRadius: BorderRadius.circular(13),
          hoverRadius: BorderRadius.circular(13),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.appColorWhite),
        ),
        title: Text("Pul o'tkazish", style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          // if (myPos?.type == PosType.MAIN)
          //   AppButton(
          //     onTap: () {
          //       showDialog(
          //           context: context,
          //           builder: (context) => GetPosTransfer(
          //                 callback: getAllPosTransfer,
          //                 myPos: myPos,
          //               ));
          //     },
          //     width: 140,
          //     height: 40,
          //     margin: const EdgeInsets.all(7),
          //     color: AppColors.appColorGreen400,
          //     hoverColor: AppColors.appColorGreen300,
          //     colorOnClick: AppColors.appColorGreen700,
          //     splashColor: AppColors.appColorGreen700,
          //     borderRadius: BorderRadius.circular(15),
          //     hoverRadius: BorderRadius.circular(15),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(UniconsLine.invoice, color: AppColors.appColorWhite, size: 23),
          //         const SizedBox(width: 5),
          //         Text('Pul olish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
          //       ],
          //     ),
          //   ),
          AppButton(
            onTap: () {
              setState(() {
                _isSynced = !_isSynced;
              });
            },
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(7),
            color: AppColors.appColorGrey700.withOpacity(0.5),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(30),
            hoverRadius: BorderRadius.circular(30),
            child: Icon(Icons.cloud_upload_outlined, color: AppColors.appColorWhite, size: 21),
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF26525f), Color(0xFF0f2228)],
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              MoneySendItemInfo(
                sortByName: () {}, // sortByName,
                sorted: _sortByName,
              ),
              Expanded(
                child: Container(
                  width: screenWidth / 1.38,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.only(), color: AppColors.appColorBlackBg),
                  child: loading
                      ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                      : allPosTransfer.isEmpty
                          ? Center(
                              child: Text('Pul o\'tkazmalar ro\'yxati bo\'sh', style: TextStyle(color: AppColors.appColorWhite)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: allPosTransfer.length,
                              itemBuilder: (BuildContext context, index) {
                                return MoneySendItem(
                                  item: allPosTransfer[index],
                                  index: index,
                                  myPos: myPos,
                                  sync: getAllPosTransfer,
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
          MoneySendRightContainers(
            allMoneySendsLength: allPosTransfer.length,
            callback: getAllPosTransfer,
            myPos: myPos,
          )
        ]),
      ),
    );
  }
}

class GetPosTransfer extends StatefulWidget {
  const GetPosTransfer({super.key, required this.callback, this.myPos});

  final Function callback;
  final POSData? myPos;

  @override
  State<GetPosTransfer> createState() => _GetPosTransferState();
}

class _GetPosTransferState extends State<GetPosTransfer> {
  MyDatabase database = Get.find<MyDatabase>();
  List<POSData> allPos = [];
  late UploadFunctions uploadFunctions;
  POSData? selectedPos;

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: (fn) {});
    getAllPos();
  }

  void getAllPos() async {
    allPos = await database.posDao.getAllPos();
    setState(() {});
  }

  Future<void> sync() async {
    try {
      await widget.callback();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> dropDownItems = [PayType.TRANSFER.name, PayType.CARD.name];
  String selectedValue = PayType.CARD.name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pul olish', style: TextStyle(color: AppColors.appColorWhite)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.appColorBlackBg,
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            AppInputUnderline(
              controller: _amountController,
              hintText: "Summa",
              hintTextColor: AppColors.appColorGrey400,
              prefixIcon: UniconsLine.money_stack,
              iconSize: 20,
              keyboardType: TextInputType.number,
              inputFormatters: [AppTextInputFormatter()],
            ),
            const SizedBox(height: 10),
            AppDropDown(
                dropDownItems: dropDownItems,
                selectedValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                }),
            const SizedBox(height: 10),
            AppAutoComplete(
              getValue: (AutocompleteDataStruct value) {
                setState(() {
                  selectedPos = allPos.firstWhereOrNull((element) => element.id == value.uniqueId && element.name == value.value);
                });
              },
              options: allPos
                  .map((e) => AutocompleteDataStruct(
                        value: e.name,
                        uniqueId: e.id,
                      ))
                  .toList(),
              hintText: 'Kassani tanlang',
              prefixIcon: UniconsLine.money_withdraw,
            ),
            if (selectedPos != null)
              FutureBuilder(
                  future: HttpServices.get("/pos-report/balance-type/pos/${selectedPos?.serverId ?? -1}?type=$selectedValue"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data?.statusCode == 200) {
                        return Text(
                          'Balans: ${formatNumber(snapshot.data?.body ?? 0)} so\'m',
                          style: TextStyle(color: AppColors.appColorWhite),
                        );
                      } else {
                        return Text(
                          'Xatolik yuz berdi: ${snapshot.data?.statusCode}',
                          style: TextStyle(color: AppColors.appColorWhite),
                        );
                      }
                    } else {
                      return Text(
                        'Hisoblanmoqda...',
                        style: TextStyle(color: AppColors.appColorWhite),
                      );
                    }
                  }),
            const SizedBox(height: 10),
            AppInputUnderline(
              controller: _descriptionController,
              hintText: "Izoh",
              hintTextColor: AppColors.appColorGrey400,
              prefixIcon: UniconsLine.comment_alt_message,
              iconSize: 20,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            const Spacer(),
            AppButton(
              tooltip: '',
              onTap: () async {
                try {
                  if (selectedPos == null) {
                    throw 'Oluvchi kassa tanlanmagan. Oluvchi kassani tanlang';
                  }
                  if (_amountController.text.isEmpty) {
                    throw 'Olish summasi kiritilmadi. Summani kiriting';
                  }
                  var res =
                      await HttpServices.get("/pos-report/balance-type/pos/${selectedPos?.serverId ?? -1}?type=$selectedValue");
                  double balance = double.tryParse(res.body) ?? 0;
                  double amount = double.parse(_amountController.text.replaceAll(" ", ""));
                  if (balance < amount) {
                    throw 'Oluvchi kassa balansida yetarli mablag\' mavjud emas';
                  }
                  // PosTransferCompanion newPosTransfer = PosTransferCompanion(
                  //   amount: toValue(amount),
                  //   createdAt: toValue(DateTime.now()),
                  //   updatedAt: toValue(DateTime.now()),
                  //   description: toValue(_descriptionController.text),
                  //   toPosId: toValue(widget.myPos!.id),
                  //   fromPosId: toValue(selectedPos!.id),
                  //   payType: toValue(PosTransferPayType.fromString(selectedValue)),
                  // );
                  // await database.posTransferDao.createPosTransfer(newPosTransfer);
                  await sync();
                } catch (e) {
                  if (context.mounted) {
                    showAppAlertDialog(context, title: 'Xatolik yuz berdi', message: e.toString(), cancelLabel: 'OK');
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
                      style:
                          TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                  Icon(UniconsLine.save, color: AppColors.appColorWhite, size: 18)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
