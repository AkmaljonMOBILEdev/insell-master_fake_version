import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';
import '../../prices_screen/screens/price_settings_screen/widget/add_price_rounding_dialog.dart';

class CashbackWidget extends StatefulWidget {
  const CashbackWidget({super.key});

  @override
  State<CashbackWidget> createState() => _CashbackWidgetState();
}

class _CashbackWidgetState extends State<CashbackWidget> {
  List<RoundingRole> roundingRoles = [RoundingRole()];
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: AppButton(
                onTap: () {
                  setState(() {
                    roundingRoles.insert(0, RoundingRole());
                  });
                },
                width: 200,
                height: 50,
                hoverRadius: BorderRadius.circular(10),
                color: AppColors.appColorGreen400,
                borderRadius: BorderRadius.circular(10),
                hoverColor: AppColors.appColorGreen400.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: AppColors.appColorWhite, size: 25),
                    const SizedBox(width: 10),
                    Text('Qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  ],
                ),
              )),
          Expanded(
            flex: 19,
            child: ListView.builder(
              itemCount: roundingRoles.length,
              itemBuilder: (BuildContext context, index) {
                final randomColor = randomColors[index % randomColors.length];
                final roundingRole = roundingRoles[index];
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
                                    decoration: BoxDecoration(color: randomColor, borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style:
                                            TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  AppButton(
                                    onTap: () {
                                      setState(() {
                                        roundingRoles.removeAt(index);
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
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 290,
                                child: AppInputUnderline(
                                  hintText: 'Cashback %',
                                  controller: roundingRole.stepController,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.percent_outlined,
                                  validator: AppValidator().sumValidate,
                                  inputFormatters: [AppTextInputFormatter()],
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     const SizedBox(width: 10),
                          //     // SizedBox(
                          //     //   width: 290,
                          //     //   child: AppInputUnderline(
                          //     //     hintText: 'Minuslash',
                          //     //     controller: roundingRole.decreaseController,
                          //     //     keyboardType: TextInputType.number,
                          //     //     prefixIcon: UniconsLine.arrow_random,
                          //     //     inputFormatters: [AppTextInputFormatter()],
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 290,
                          //       child: Row(
                          //         children: [
                          //           Text('Avtomatik yaxlidlash', style: TextStyle(color: AppColors.appColorWhite)),
                          //           Transform.scale(
                          //             scale: 0.8,
                          //             child: Switch(
                          //               value: roundingRole.roundUp,
                          //               activeColor: AppColors.appColorGreen400,
                          //               onChanged: (bool value) {
                          //                 setState(() {
                          //                   roundingRole.roundUp = value;
                          //                 });
                          //               },
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     roundingRole.roundUp
                          //         ? const SizedBox()
                          //         : SizedBox(
                          //             width: 290,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Text('Yaxlidlash', style: TextStyle(color: AppColors.appColorWhite)),
                          //                 Row(
                          //                   children: [
                          //                     Transform.scale(
                          //                       scale: 0.8,
                          //                       child: Switch(
                          //                         value: roundingRole.rounding,
                          //                         activeColor: AppColors.appColorGreen400,
                          //                         onChanged: (bool value) {
                          //                           setState(() {
                          //                             roundingRole.rounding = value;
                          //                           });
                          //                         },
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                       height: 25,
                          //                       padding: const EdgeInsets.symmetric(horizontal: 10),
                          //                       decoration: BoxDecoration(
                          //                         color: roundingRole.rounding
                          //                             ? AppColors.appColorGreen400
                          //                             : AppColors.appColorRed400,
                          //                         borderRadius: BorderRadius.circular(10),
                          //                       ),
                          //                       child: Center(
                          //                         child: Text(
                          //                           roundingRole.rounding ? 'Foyda' : 'Zarar',
                          //                           style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                          //                         ),
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //   ],
                          // ),
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
    );
  }
}
