import 'package:easy_sell/screens/currency_screen/widget/currency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../utils/menu_list_item.dart';
import '../../widgets/app_button.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  Widget innerWidget = Expanded(
    child: Center(
      child: Text(
        'Yon Paneldan Tanlang',
        style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
      ),
    ),
  );
  int? activeIndex;

  @override
  Widget build(BuildContext context) {
    List<MenuListItem> getSettingsItems = [
      MenuListItem(
        icon: Icons.attach_money_rounded,
        title: 'Valyuta yaratish',
        onTap: () {
          setState(() {
            activeIndex = 0;
            innerWidget = CurrencySide();
          });
        },
      ),
    ];
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
        title: Text('Valyuta', style: TextStyle(color: AppColors.appColorWhite)),
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
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0);
                              },
                              padding: const EdgeInsets.all(0),
                              itemCount: getSettingsItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: activeIndex == index ? AppColors.appColorGrey700.withOpacity(0.4) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: getSettingsItems[index],
                                );
                              },
                            ),
                          ),
                          VerticalDivider(color: AppColors.appColorGrey700, thickness: 1, width: 0),
                          Flexible(
                            flex: 4,
                            child: Column(
                              children: [
                                innerWidget,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
