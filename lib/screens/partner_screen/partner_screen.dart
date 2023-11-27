import 'package:easy_sell/screens/partner_screen/widget/partner_bank.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_counterparty.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_organization.dart';
import 'package:easy_sell/screens/partner_screen/widget/partner_right_containers.dart';
import 'package:easy_sell/screens/partner_screen/widget/partners.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../widgets/app_button.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({Key? key}) : super(key: key);

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

enum PartnerType {
  PARTNER,
  ORGANIZATION,
  BANK,
}

class _PartnerScreenState extends State<PartnerScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  bool loading = false;
  String? _selectedPartner;

  @override
  void initState() {
    super.initState();
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
        title: Text("Xamkorlar", style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _selectedPartner == PartnerType.ORGANIZATION.name
                ? PartnerOrganization(type: PartnerType.ORGANIZATION.name, callback: () => setState(() {}))
                : _selectedPartner == PartnerType.PARTNER.name
                    ? PartnerCounterparty(type: PartnerType.PARTNER.name, callback: () => setState(() {}))
                    : _selectedPartner == PartnerType.BANK.name
                        ? PartnerBank(type: PartnerType.BANK.name, callback: () => setState(() {}))
                        : const Partners(),
            PartnerRightContainers(
              getByPartner: (partner) {
                setState(() {
                  _selectedPartner = partner;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
