import 'dart:convert';

import 'package:easy_sell/database/model/counter_party_dto.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_add_dialog.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_item.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_item_info.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../services/https_services.dart';


class PartnerOrganization extends StatefulWidget {
  const PartnerOrganization({super.key, required this.type, required this.callback});
  final VoidCallback callback;
  final String type;

  @override
  State<PartnerOrganization> createState() => _PartnerOrganizationState();
}

class _PartnerOrganizationState extends State<PartnerOrganization> {
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
                        future: HttpServices.get("/counterparty/organization/all"),
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
                            // if (selectedRegionId != null) {
                            //   clientsList = clientsList.where((element) => element.region?.id == selectedRegionId).toList();
                            // }
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
                                              'Organizatsiyalar ro\'yxati bo\'sh',
                                              style: TextStyle(color: AppColors.appColorWhite),
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: counterPartyDtoList.length,
                                            itemBuilder: (BuildContext context, index) {
                                              return PartnerItem(
                                                counterParty: counterPartyDtoList[index],
                                                type: widget.type,
                                                index: index,
                                                callback: widget.callback,
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
