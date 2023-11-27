import 'package:easy_sell/screens/warehouse_screen/screens/product_expenses/widget/product_expenses_item.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_expenses/widget/product_expenses_item_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/app_button.dart';

class ProductExpensesScreen extends StatefulWidget {
  const ProductExpensesScreen({super.key});

  @override
  State<ProductExpensesScreen> createState() => _ProductExpensesScreenState();
}

class _ProductExpensesScreenState extends State<ProductExpensesScreen> {
  @override
  Widget build(BuildContext context) {
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
        title: Text('Maxsulot chiqimlari', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
      ),
      body: Container(
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
            const ProductExpensesItemInfo(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.appColorBlackBg),
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductExpensesItem(
                      index: index,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
