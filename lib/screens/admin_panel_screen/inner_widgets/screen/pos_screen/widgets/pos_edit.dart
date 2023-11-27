import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/pos_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class PosEditButton extends StatefulWidget {
  const PosEditButton({super.key, this.pos, required this.reload});

  final PosDto? pos;
  final void Function(VoidCallback fn) reload;

  @override
  State<PosEditButton> createState() => _PosEditButtonState();
}

class _PosEditButtonState extends State<PosEditButton> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedShop = 0;
  PosType? _selectedEmployeeType;

  @override
  void initState() {
    super.initState();
    if (widget.pos != null) {
      _nameController.text = widget.pos!.name;
      _selectedShop = widget.pos!.shop.id;
      _selectedEmployeeType = widget.pos!.type;
    }
  }

  void createOrUpdateShop() async {
    try {
      var request = {
        'name': _nameController.text,
        'shopId': _selectedShop,
        'type': _selectedEmployeeType?.name,
      };
      http.Response response;
      if (widget.pos != null) {
        response = await HttpServices.put('/pos/${widget.pos!.id}', request);
      } else {
        response = await HttpServices.post('/pos/create', request);
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
      title: const Text('Kassani tahrirlash', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            AppInputUnderline(
              hintText: 'Kassa nomi',
              controller: _nameController,
              prefixIcon: (Icons.shopping_bag_outlined),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future: HttpServices.get('/shop/all'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var response = snapshot.data;
                    var json = jsonDecode(response?.body ?? '')['data'];
                    return AppAutoComplete(
                      getValue: (AutocompleteDataStruct selected) {
                        _selectedShop = selected.uniqueId;
                      },
                      options: json
                          .map<AutocompleteDataStruct>((e) => AutocompleteDataStruct(uniqueId: e['id'], value: e['name']))
                          .toList(),
                      hintText: 'Doko\'nni tanlang',
                      prefixIcon: Icons.location_on_outlined,
                      initialValue: widget.pos?.shop.name,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            const SizedBox(height: 10),
            AppDropDown(
              selectedValue: _selectedEmployeeType?.name,
              dropDownItems: PosType.values.map((e) => e.name).toList(),
              onChanged: (value) {
                _selectedEmployeeType = PosType.fromString(value);
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
