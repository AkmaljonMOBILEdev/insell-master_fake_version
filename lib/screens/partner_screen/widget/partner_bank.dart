import 'dart:convert';

import 'package:easy_sell/screens/partner_screen/widget/partner_add_dialog.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_item.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_item_info.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../database/model/counter_party_dto.dart';
import '../../../services/https_services.dart';
import '../../../widgets/app_button.dart';

class PartnerBank extends StatefulWidget {
  const PartnerBank({super.key, required this.type, required this.callback});

  final String type;
  final VoidCallback callback;

  @override
  State<PartnerBank> createState() => _PartnerBankState();
}

class _PartnerBankState extends State<PartnerBank> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const PartnerItemInfo(),
        Expanded(
          child: Container(
            width: screenWidth / 1.38,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: const BorderRadius.only(), color: AppColors.appColorBlackBg),
            child: loading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.appColorGreen400),
                  )
                // : allPosTransfer.isEmpty
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return PartnerAddDialog(
                                    type: widget.type,
                                    callback: widget.callback,
                                  );
                                },
                              );
                            },
                            color: AppColors.appColorGreen400,
                            borderRadius: BorderRadius.circular(10),
                            hoverRadius: BorderRadius.circular(10),
                            child: Icon(Icons.add, color: AppColors.appColorWhite),
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: HttpServices.get("/counterparty/bank/all"),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            var snapshotData = snapshot.data;
                            var responseJson = jsonDecode(snapshotData.body);
                            List<CounterPartyDto> counterPartyDtoList = [];
                            int counterPartyDtoListCount = 0;
                            if (responseJson != null) {
                              counterPartyDtoListCount = responseJson['totalElements'];
                              for (var counterParty in responseJson['data']) {
                                counterPartyDtoList.add(CounterPartyDto.fromJson(counterParty));
                              }
                            }
                            return Expanded(
                              child: Container(
                                width: screenWidth / 1.38,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(borderRadius: BorderRadius.only()),
                                child: loading
                                    ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                                    : counterPartyDtoList.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Kontragentlar ro\'yxati bo\'sh',
                                              style: TextStyle(color: AppColors.appColorWhite),
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: counterPartyDtoList.length,
                                            itemBuilder: (BuildContext context, index) {
                                              return PartnerItem(
                                                type: widget.type,
                                                counterParty: counterPartyDtoList[index],
                                                index: index,
                                                callback: () {},
                                              );
                                            },
                                          ),
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator(color: AppColors.appColorWhite));
                          }
                        },
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
