import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/employee_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class EmployeeEditButton extends StatefulWidget {
  const EmployeeEditButton({super.key, this.employee, required this.reload});

  final EmployeeDto? employee;
  final void Function(VoidCallback fn) reload;

  @override
  State<EmployeeEditButton> createState() => _EmployeeEditButtonState();
}

class _EmployeeEditButtonState extends State<EmployeeEditButton> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _phoneNumber2Controller = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  int _selectedShop = 0;
  final TextEditingController _cardNumberController = TextEditingController();
  bool isMale = true;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _firstNameController.text = widget.employee!.firstName;
      _lastNameController.text = widget.employee!.lastName ?? '';
      _phoneNumberController.text = widget.employee!.phoneNumber ?? '';
      _phoneNumber2Controller.text = widget.employee!.phoneNumber2 ?? '';
      _dateOfBirth.text = formatDate(widget.employee!.dateOfBirth, format: 'dd/MM/yyyy');
      _cardNumberController.text = widget.employee!.cardNumber ?? '';
      isMale = widget.employee!.gender.name == 'MALE';
      _address.text = widget.employee!.address ?? '';
    }
  }

  void createOrUpdateShop() async {
    try {
      var request = {
        'address': _address.text,
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "phoneNumber": _phoneNumberController.text,
        "phoneNumber2": _phoneNumber2Controller.text,
        "dateOfBirth": DateFormat('dd/MM/yyyy').parse(_dateOfBirth.text).millisecondsSinceEpoch,
        "shopId": _selectedShop,
        "cardNumber": _cardNumberController.text,
        "gender": isMale ? "MALE" : 'FEMALE'
      };
      http.Response response;
      if (widget.employee != null) {
        response = await HttpServices.put('/employee/${widget.employee!.id}', request);
      } else {
        response = await HttpServices.post('/employee/create', request);
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
      title: const Text('Xodimni tahrirlash', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 300,
        height: 500,
        child: Column(
          children: [
            AppInputUnderline(
              hintText: 'Xodim nomi',
              controller: _firstNameController,
              prefixIcon: (Icons.person_outline),
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Xodim familiyasi',
              controller: _lastNameController,
              prefixIcon: (Icons.person_outline),
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Xodim Manzili',
              controller: _address,
              prefixIcon: (Icons.location_on_outlined),
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Xodim telefon raqami',
              controller: _phoneNumberController,
              prefixIcon: (Icons.phone),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '+998 ## ### ## ##',
                  filter: {"#": RegExp(r'[0-9]')},
                )
              ],
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Xodim 2-telefon raqami',
              controller: _phoneNumber2Controller,
              prefixIcon: (Icons.phone),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '+998 ## ### ## ##',
                  filter: {"#": RegExp(r'[0-9]')},
                )
              ],
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Xodim tug\'ilgan sana',
              controller: _dateOfBirth,
              prefixIcon: (Icons.calendar_month_outlined),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '##/##/####',
                  filter: {"#": RegExp(r'[0-9]')},
                )
              ],
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Xodim kartasi raqami',
              controller: _cardNumberController,
              prefixIcon: (Icons.credit_card_outlined),
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
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            const SizedBox(height: 10),
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
