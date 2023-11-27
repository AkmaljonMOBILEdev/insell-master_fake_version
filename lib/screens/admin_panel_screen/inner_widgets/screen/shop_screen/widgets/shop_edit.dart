import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class ShopEditButton extends StatefulWidget {
  const ShopEditButton({super.key, this.shop, required this.reload});

  final ShopDto? shop;
  final void Function(VoidCallback fn) reload;

  @override
  State<ShopEditButton> createState() => _ShopEditButtonState();
}

class _ShopEditButtonState extends State<ShopEditButton> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  int? _selectedRegion;
  ShopType? _selectedShopType;

  @override
  void initState() {
    super.initState();
    if (widget.shop != null) {
      _nameController.text = widget.shop!.name;
      _addressController.text = widget.shop!.address;
      _selectedRegion = widget.shop!.region.id;
      _selectedShopType = widget.shop!.type;
    }
  }

  void createOrUpdateShop() async {
    try {
      var request = {
        'name': _nameController.text,
        'regionId': _selectedRegion,
        'type': _selectedShopType?.name,
        'address': _addressController.text,
        'organizationId': 1,
      };
      http.Response response;
      if (widget.shop != null) {
        response = await HttpServices.put('/shop/${widget.shop!.id}', request);
      } else {
        response = await HttpServices.post('/shop/create', request);
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.body);
      }
      Get.back();
      widget.reload(() {});
    } catch (e) {
      showAppAlertDialog(context, title: 'Xatolik', message: e.toString(), cancelLabel: 'Ok', buttonLabel: 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: const Text('Do\'konni tahrirlash', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            AppInputUnderline(
              hintText: 'Do\'kon nomi',
              controller: _nameController,
              prefixIcon: (Icons.shopping_bag_outlined),
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Do\'kon Addressi',
              controller: _addressController,
              prefixIcon: (Icons.edit_note_outlined),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: HttpServices.get('/region/all'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var response = snapshot.data;
                  var json = jsonDecode(response?.body ?? '');
                  return AppAutoComplete(
                    getValue: (AutocompleteDataStruct selected) {
                      _selectedRegion = selected.uniqueId;
                    },
                    options: json.map<AutocompleteDataStruct>((e) => AutocompleteDataStruct(uniqueId: e['id'], value: e['name'])).toList(),
                    hintText: 'Regionni tanlang',
                    prefixIcon: Icons.location_on_outlined,
                    initialValue: widget.shop?.region.name,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 10),
            AppDropDown(
              selectedValue: _selectedShopType?.name,
              dropDownItems: ShopType.values.map((e) => e.name).toList(),
              onChanged: (value) {
                _selectedShopType = ShopType.fromStr(value);
              },
            ),
            const Spacer(),
            AppButton(
              onTap: createOrUpdateShop,
              width: 300,
              height: 40,
              color: AppColors.appColorGreen400,
              borderRadius: BorderRadius.circular(10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Saqlash', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
