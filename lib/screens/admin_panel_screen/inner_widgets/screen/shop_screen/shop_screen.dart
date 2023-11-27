import 'dart:convert';

import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/shop_screen/widgets/shop_edit.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/shop_screen/widgets/shop_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../widgets/app_button.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppButton(
              onTap: () async {
                showDialog(context: context, builder: (context) => ShopEditButton(reload: setState));
              },
              width: 150,
              height: 40,
              color: AppColors.appColorGreen400,
              borderRadius: BorderRadius.circular(10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(UniconsLine.plus, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Qo\'shish', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: HttpServices.get("/shop/all"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var response = snapshot.data;
                    var json = jsonDecode(response?.body ?? '')['data'];
                    List<ShopDto> shops = [];
                    for (var item in json) {
                      shops.add(ShopDto.fromJson(item));
                    }
                    return ListView.builder(
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        ShopDto shop = shops[index];
                        return ShopItem(
                          shop: shop,
                          reload: setState,
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
