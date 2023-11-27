import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/validator.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/model/price_rounded_dto.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;

class RoundingRole {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController stepController = TextEditingController();
  TextEditingController decreaseController = TextEditingController();
  bool roundUp = true;
  bool rounding = true;
  Color cardColor = Colors.grey.shade800;

  RoundingRole();

  void updateCardColor(Color newColor) {
    cardColor = newColor;
  }

  RoundingRole.fromMap(Map<String, dynamic> map) {
    fromController.text = map['from'].toString();
    toController.text = map['to'].toString();
    stepController.text = map['step'].toString();
    decreaseController.text = map['decrease'].toString();
    roundUp = map['roundUp'];
    rounding = map['rounding'];
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'from': fromController.text,
      'to': toController.text,
      'step': stepController.text,
      'decrease': decreaseController.text,
      'roundUp': roundUp,
      'rounding': rounding,
    };
  }

  @override
  String toString() {
    return 'RoundingRole{fromController: $fromController, toController: $toController, stepController: $stepController, decreaseController: $decreaseController, roundUp: $roundUp, rounding: $rounding}';
  }
}

class AddPriceRoundingDialog extends StatefulWidget {
  const AddPriceRoundingDialog({Key? key, required this.callback, this.roundedDto}) : super(key: key);
  final PriceRoundedDto? roundedDto;
  final VoidCallback callback;

  @override
  State<AddPriceRoundingDialog> createState() => _AddPriceRoundingDialogState();
}

class _AddPriceRoundingDialogState extends State<AddPriceRoundingDialog> {
  final _formValidation = GlobalKey<FormState>();
  List<RoundingRole> _roundingRoles = [
    RoundingRole(),
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  double _result = 0.0;
  int selectedIndex = -1;
  bool _isFind = false;

  @override
  void initState() {
    super.initState();
    if (widget.roundedDto != null) {
      _nameController.text = widget.roundedDto?.name ?? '';
      _descriptionController.text = widget.roundedDto?.description ?? '';
      addRoundingRoles(widget.roundedDto?.roundingRoles ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          Text('Narx yaxlitlash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 500,
        width: 950,
        child: Form(
          key: _formValidation,
          child: Row(
            children: [
              SizedBox(
                height: 500,
                width: 290,
                child: Card(
                  color: Colors.grey.shade800,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 227,
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black54),
                              child: AppInputUnderline(
                                hintText: 'Summa kiriting...',
                                controller: _inputController,
                                prefixIcon: Icons.view_headline,
                                inputFormatters: [AppTextInputFormatter()],
                              ),
                            ),
                            AppButton(
                              onTap: () => calculate(),
                              width: 40,
                              height: 40,
                              color: AppColors.appColorGreen400,
                              borderRadius: BorderRadius.circular(10),
                              hoverRadius: BorderRadius.circular(10),
                              child: Icon(Icons.calculate, color: AppColors.appColorWhite, size: 24),
                            )
                          ],
                        ),
                        Container(
                          height: 125,
                          width: 290,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Natija:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                                  Text(formatNumber(_result), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                                ],
                              ),
                              const Divider(height: 2),
                              Text(
                                _isFind
                                    ? 'Siz kiritgan summa "${selectedIndex + 1}" chi yaxlitlash shartiga to\'g\'ri keladi.'
                                    : 'Siz kiritgan summa xech qaysi yaxlitlash shartlariga to\'g\'ri kelmaydi.',
                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 650,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 320,
                          child: AppInputUnderline(
                            controller: _nameController,
                            hintText: 'Nomi',
                            validator: AppValidator().namedValidate,
                            prefixIcon: Icons.view_headline,
                            numberFormat: false,
                          ),
                        ),
                        SizedBox(
                          width: 320,
                          child: AppInputUnderline(
                            controller: _descriptionController,
                            hintText: 'Izoh',
                            textInputAction: TextInputAction.newline,
                            prefixIcon: UniconsLine.comment_alt,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _roundingRoles.length,
                        itemBuilder: (BuildContext context, index) {
                          final randomColor = randomColors[index % randomColors.length];
                          final roundingRole = _roundingRoles[index];
                          final isSelected = index == selectedIndex;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                            child: Card(
                              color: isSelected ? Colors.blue.shade600.withOpacity(0.3) : Colors.grey.shade800,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              height: 25,
                                              decoration:
                                                  BoxDecoration(color: randomColor, borderRadius: BorderRadius.circular(10)),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                      color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'chi yaxlitlash',
                                              style: TextStyle(
                                                  color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            AppButton(
                                              onTap: () {
                                                setState(() {
                                                  _roundingRoles.removeAt(index);
                                                });
                                              },
                                              width: 30,
                                              height: 30,
                                              hoverRadius: BorderRadius.circular(10),
                                              child: Icon(Icons.close_rounded, color: AppColors.appColorWhite, size: 25),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 290,
                                          child: AppInputUnderline(
                                            hintText: 'Dan',
                                            onChanged: (value) {},
                                            controller: roundingRole.fromController,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: UniconsLine.arrow_from_right,
                                            validator: AppValidator().sumValidate,
                                            inputFormatters: [AppTextInputFormatter()],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 290,
                                          child: AppInputUnderline(
                                            hintText: 'Gacha',
                                            controller: roundingRole.toController,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: UniconsLine.arrow_to_right,
                                            inputFormatters: [AppTextInputFormatter()],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 290,
                                          child: AppInputUnderline(
                                            hintText: 'Yaxlidlash xisobi',
                                            controller: roundingRole.stepController,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: Icons.control_point_duplicate_rounded,
                                            validator: AppValidator().sumValidate,
                                            inputFormatters: [AppTextInputFormatter()],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 290,
                                          child: AppInputUnderline(
                                            hintText: 'Minuslash',
                                            controller: roundingRole.decreaseController,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: UniconsLine.arrow_random,
                                            inputFormatters: [AppTextInputFormatter()],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 290,
                                          child: Row(
                                            children: [
                                              Text('Avtomatik yaxlidlash', style: TextStyle(color: AppColors.appColorWhite)),
                                              Transform.scale(
                                                scale: 0.8,
                                                child: Switch(
                                                  value: roundingRole.rounding,
                                                  activeColor: AppColors.appColorGreen400,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      roundingRole.rounding = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        roundingRole.rounding
                                            ? const SizedBox()
                                            : SizedBox(
                                                width: 290,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Yaxlidlash', style: TextStyle(color: AppColors.appColorWhite)),
                                                    Row(
                                                      children: [
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: Switch(
                                                            value: roundingRole.roundUp,
                                                            activeColor: AppColors.appColorGreen400,
                                                            onChanged: (bool value) {
                                                              setState(() {
                                                                roundingRole.roundUp = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 25,
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          decoration: BoxDecoration(
                                                            color: roundingRole.roundUp
                                                                ? AppColors.appColorGreen400
                                                                : AppColors.appColorRed400,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              roundingRole.roundUp ? 'Foyda' : 'Zarar',
                                                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              onTap: () {
                setState(() {
                  _roundingRoles.add(RoundingRole());
                });
              },
              height: 40,
              width: 40,
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Center(
                child: Icon(Icons.add, color: AppColors.appColorWhite),
              ),
            ),
            const SizedBox(width: 10),
            AppButton(
              tooltip: '',
              onTap: () {
                if (_formValidation.currentState!.validate()) {
                  createOrUpdatePriceRounding();
                  widget.callback();
                }
              },
              width: 250,
              height: 40,
              color: AppColors.appColorGreen400,
              hoverColor: AppColors.appColorGreen300,
              colorOnClick: AppColors.appColorGreen700,
              splashColor: AppColors.appColorGreen700,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.roundedDto != null ? 'Yangilash' : 'Saqlash',
                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  double rounding(double value, double step, double decrease) {
    double calc = ((value + decrease) / step).round() * step - decrease;
    setState(() {
      _result = calc;
    });
    return _result;
  }

  double ceiling(double value, double step, double decrease) {
    double calc = ((value + decrease) / step).ceil() * step - decrease;
    setState(() {
      _result = calc;
    });
    return _result;
  }

  double flooring(double value, double step, double decrease) {
    double calc = ((value + decrease) / step).floor() * step - decrease;
    setState(() {
      _result = calc;
    });
    return _result;
  }

  void calculate() {
    double inputValue = double.tryParse(_inputController.text.replaceAll(' ', '')) ?? 0;

    RoundingRole? currentRole;

    for (var roundingRole in _roundingRoles) {
      double from = double.tryParse(roundingRole.fromController.text.replaceAll(' ', '')) ?? 0;
      double? to = double.tryParse(roundingRole.toController.text.replaceAll(' ', ''));
      if (to == null) {
        if (inputValue >= from) {
          currentRole = roundingRole;
        }
      } else {
        if (inputValue >= from && inputValue <= to) {
          currentRole = roundingRole;
        }
      }
    }

    // Получение индекса для изменения цвета
    if (currentRole != null) {
      int index = _roundingRoles.indexOf(currentRole);
      setState(() {
        selectedIndex = index;
        _isFind = true;
      });
    } else {
      setState(() {
        selectedIndex = -1;
        _isFind = false;
      });
    }

    double step = double.tryParse(currentRole?.stepController.text.replaceAll(' ', '') ?? "") ?? 0;
    double decrease = double.tryParse(currentRole?.decreaseController.text.replaceAll(' ', '') ?? "") ?? 0;

    double result = 0.0;
    if (currentRole != null) {
      if (currentRole.rounding) {
        result = rounding(inputValue, step, decrease);
      } else if (currentRole.rounding == false && currentRole.roundUp == true) {
        result = ceiling(inputValue, step, decrease);
      } else if (currentRole.rounding == false && currentRole.roundUp == false) {
        result = flooring(inputValue, step, decrease);
      } else {
        setState(() {
          _result = inputValue;
        });
      }
    } else {
      setState(() {
        _result = inputValue;
      });
    }
  }

  void createOrUpdatePriceRounding() async {
    try {
      var req = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        'roundingRoles': _roundingRoles.map((e) {
          double? from = double.tryParse(e.fromController.text.replaceAll(' ', '')) ?? 0.0;
          double? to = double.tryParse(e.toController.text.replaceAll(' ', '')) ?? 0.0;
          double? step = double.tryParse(e.stepController.text.replaceAll(' ', '')) ?? 0.0;
          double? decrease = double.tryParse(e.decreaseController.text.replaceAll(' ', '')) ?? 0.0;
          RoundingRole newRole = RoundingRole()
            ..fromController.text = from.toString()
            ..toController.text = to.toString()
            ..stepController.text = step.toString()
            ..decreaseController.text = decrease.toString()
            ..roundUp = e.roundUp
            ..rounding = e.rounding;
          return newRole.toJson();
        }).toList(),
      };
      http.Response response;

      if (widget.roundedDto != null) {
        response = await HttpServices.put("/settings/rounding/${widget.roundedDto?.id}", req);
        Get.back();
        showAppSnackBar(context, "Narx yaxlidliklari muvofaqiyatli yangilandi", "OK");
      } else {
        response = await HttpServices.post("/settings/rounding/create", req);
        Get.back();
        showAppSnackBar(context, "Narx yaxlidliklari muvofaqiyatli qo'shildi", "OK");
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi: $e", "OK", isError: true);
        print('$e');
      }
    }
  }

  void addRoundingRoles(List<RoundingRoleDto> roundings) {
    _roundingRoles.clear();
    for (var rounding in roundings) {
      RoundingRole roundingRole = RoundingRole();
      roundingRole.fromController.text = rounding.from.toString();
      if (rounding.to != double.maxFinite) {
        roundingRole.toController.text = rounding.to.toString();
      }
      roundingRole.stepController.text = rounding.step.toString();
      roundingRole.decreaseController.text = rounding.decrease.toString();
      roundingRole.roundUp = rounding.roundUp;
      roundingRole.rounding = rounding.rounding;
      _roundingRoles.add(roundingRole);
    }
  }
}
