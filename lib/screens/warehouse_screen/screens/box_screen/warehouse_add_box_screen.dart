import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/box_screen/widget/add_box_dialog.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/box_screen/widget/add_box_item_info.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/box_screen/widget/add_box_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../database/model/product_dto.dart';
import '../../../../widgets/app_button.dart';

class WarehouseAddBoxScreen extends StatefulWidget {
  const WarehouseAddBoxScreen({Key? key}) : super(key: key);

  @override
  State<WarehouseAddBoxScreen> createState() => _WarehouseAddBoxScreenState();
}

class _WarehouseAddBoxScreenState extends State<WarehouseAddBoxScreen> {
  List<ProductDTO> productBox = [];
  MyDatabase database = Get.find<MyDatabase>();

  @override
  void initState() {
    super.initState();
    getProductBox();
  }

  void getProductBox() async {
    productBox = await database.productDao.getAllProductsBoxByLimitOrSearch();
    setState(() {});
  }

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
        title: Text('Setlar', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          AppButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddBoxDialog(
                    setProductBox: (ProductDTO product) {
                      productBox.add(product);
                      setState(() {});
                    },
                  );
                },
              );
            },
            width: 100,
            height: 40,
            margin: const EdgeInsets.all(7),
            color: AppColors.appColorGreen400,
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(15),
            hoverRadius: BorderRadius.circular(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(UniconsLine.box, color: AppColors.appColorWhite, size: 22),
                const SizedBox(width: 5),
                Text('Set', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
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
        child: Column(
          children: [
            const AddBoxItemInfo(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.appColorBlackBg,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                ),
                child: productBox.isEmpty
                    ? Center(
                        child: Text('Setlar mavjud emas',
                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 18, fontWeight: FontWeight.w500)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemCount: productBox.length,
                        itemBuilder: (BuildContext context, index) {
                          return AddBoxItems(
                            productBox: productBox[index],
                            index: index,
                          );
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const Divider(height: 1, color: Colors.white24);
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
