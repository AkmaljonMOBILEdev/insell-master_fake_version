import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/constants/user_role.dart';
import 'package:easy_sell/database/model/user_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class UserEditButton extends StatefulWidget {
  const UserEditButton({super.key, this.user, required this.reload});

  final UserDto? user;
  final void Function(VoidCallback fn) reload;

  @override
  State<UserEditButton> createState() => _UserEditButtonState();
}

class _UserEditButtonState extends State<UserEditButton> {
  UserRequestDto userRequestDto = UserRequestDto();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      userRequestDto = UserRequestDto(
        name: widget.user?.name,
        username: widget.user?.username,
        phoneNumber: widget.user?.phoneNumber,
        phoneNumber2: widget.user?.phoneNumber2,
        shopId: widget.user?.shop?.id,
        posId: widget.user?.pos?.id,
        roles: widget.user?.roles.map((e) => e.name).toList() ?? [],
        organizationId: widget.user?.organization?.id,
      );
    }
  }

  void createOrUpdateShop() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      http.Response response;
      if (widget.user != null) {
        response = await HttpServices.put('/user/update', userRequestDto.toJson());
      } else {
        response = await HttpServices.post('/user/register', userRequestDto.toJson());
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.body);
      }
      Get.back();
      widget.reload(() {});
    } catch (e) {
      if (mounted) {
        showAppAlertDialog(context, title: 'Xatolik', message: e.toString(), cancelLabel: 'Ok', buttonLabel: 'OK');
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: const Text('Xodimni tahrirlash', style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          height: 600,
          child: Column(
            children: [
              AppInputUnderline(
                defaultValue: widget.user?.username ?? '',
                hintText: 'Username*',
                prefixIcon: (Icons.person_outline),
                onSaved: (value) {
                  userRequestDto.username = value;
                },
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                defaultValue: widget.user?.name ?? '',
                hintText: 'Ismi*',
                prefixIcon: (Icons.person_outline),
                onSaved: (value) {
                  userRequestDto.name = value;
                },
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                defaultValue: widget.user?.phoneNumber ?? '',
                hintText: 'Telefon raqami',
                prefixIcon: (Icons.phone),
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '+998 ## ### ## ##',
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                onSaved: (value) {
                  userRequestDto.phoneNumber = value;
                },
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                defaultValue: widget.user?.phoneNumber2 ?? '',
                hintText: '2-telefon raqami',
                prefixIcon: (Icons.phone),
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '+998 ## ### ## ##',
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                onSaved: (value) {
                  userRequestDto.phoneNumber2 = value;
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                  future: HttpServices.get('/shop/all'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var response = snapshot.data;
                      var json = jsonDecode(response?.body ?? '')['data'];
                      return AppAutoComplete(
                        initialValue: widget.user?.shop?.name ?? '',
                        getValue: (AutocompleteDataStruct selected) {
                          userRequestDto.shopId = selected.uniqueId;
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
              FutureBuilder(
                  future: HttpServices.get('/pos/all'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var response = snapshot.data;
                      var json = jsonDecode(response?.body ?? '')['data'];
                      return AppAutoComplete(
                        initialValue: widget.user?.pos?.name ?? '',
                        getValue: (AutocompleteDataStruct selected) {
                          userRequestDto.posId = selected.uniqueId;
                        },
                        options: json
                            .map<AutocompleteDataStruct>((e) => AutocompleteDataStruct(uniqueId: e['id'], value: e['name']))
                            .toList(),
                        hintText: 'Kassani tanlang',
                        prefixIcon: UniconsLine.postcard,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              const SizedBox(height: 10),
              FutureBuilder(
                  future: HttpServices.get('/organization/all'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var response = snapshot.data;
                      var json = jsonDecode(response?.body ?? '')['data'];
                      return AppAutoComplete(
                        initialValue: widget.user?.organization?.name ?? '',
                        getValue: (AutocompleteDataStruct selected) {
                          userRequestDto.organizationId = selected.uniqueId;
                        },
                        options: json
                            .map<AutocompleteDataStruct>((e) => AutocompleteDataStruct(uniqueId: e['id'], value: e['name']))
                            .toList(),
                        hintText: 'Organizatsiyani tanlang',
                        prefixIcon: UniconsLine.building,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              const SizedBox(height: 10),
              AppInputUnderline(
                hintText: 'Parol*',
                prefixIcon: (Icons.lock_outline),
                onSaved: (value) {
                  userRequestDto.password = value;
                },
              ),
              const SizedBox(height: 10),
              AppDropDown(
                  dropDownItems: UserRole.values.map((e) => e.name).toList(),
                  onChanged: (value) {
                    if (userRequestDto.roles.contains(value)) {
                      return;
                    }
                    setState(() {
                      userRequestDto.roles = [...userRequestDto.roles, value];
                    });
                  }),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: userRequestDto.roles
                        .map((e) => InkWell(
                              onTap: () {
                                setState(() {
                                  userRequestDto.roles.remove(e);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.appColorGreen400,
                                ),
                                child: Text(e, style: const TextStyle(color: Colors.white)),
                              ),
                            ))
                        .toList()),
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
      ),
    );
  }
}

class UserRequestDto {
  String? phoneNumber;
  String? phoneNumber2;
  String? name;
  String? data;
  String? username;
  String? password;
  int? shopId;
  int? posId;
  List<String> roles = [];
  int? organizationId;

  UserRequestDto({
    this.phoneNumber,
    this.phoneNumber2,
    this.name,
    this.data,
    this.username,
    this.password,
    this.shopId,
    this.posId,
    this.roles = const [],
    this.organizationId,
  });

  UserRequestDto.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    phoneNumber2 = json['phoneNumber2'];
    name = json['name'];
    data = json['data'];
    username = json['username'];
    password = json['password'];
    shopId = json['shopId'];
    posId = json['posId'];
    roles = json['roles'].cast<String>();
    organizationId = json['organizationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['phoneNumber2'] = phoneNumber2;
    data['name'] = name;
    data['data'] = '';
    data['username'] = username;
    data['password'] = password;
    data['shopId'] = shopId;
    data['posId'] = posId;
    data['roles'] = roles;
    data['organizationId'] = organizationId;
    return data;
  }
}
