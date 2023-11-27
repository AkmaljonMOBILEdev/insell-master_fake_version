import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/finance_screen/incomes_screen/widget/income_screens/wrapper_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/app_button.dart';
import '../../utils/routes.dart';
import '../../widgets/app_dropdown.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_bank_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_client_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_counterparty_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_credit_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_employee_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_other_cash_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_other_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_from_other_org_dialog.dart';
import 'incomes_screen/widget/incomes_dialogs/come_return_from_supplier_dialog.dart';
import 'outgoings_screen/widgets/outgoings_dialogs/pay_give_to_counterparty_dialog.dart';
import 'outgoings_screen/widgets/outgoings_dialogs/pay_other_expense_dialog.dart';
import 'outgoings_screen/widgets/outgoings_dialogs/pay_send_to_another_cash_dialog.dart';
import 'outgoings_screen/widgets/outgoings_dialogs/pay_to_other_org_dialog.dart';
import 'outgoings_screen/widgets/outgoings_dialogs/pay_to_supplier_dialog.dart';

Map<String, String> expenseType = {
  "PAY_TO_SUPPLIER": "Оплата поставщику",
  "PAY_TO_OTHER_ORG": "Оплата другой организации",
  "ISSUANCE_TO_ANOTHER_CASH": "Выдача в другую кассу",
  "ISSUANCE_TO_COUNTERPARTY": "Выдача займа контрагенту",
  "OTHER_EXPENSE": "Прочий расход",
  // "PAY_SALARY_DISTRIBUTOR": "Выплата зарплаты дистрибьютору",
  // "PAY_SALARY_EMPLOYEE": "Выплата зарплаты сотруднику",
  // "PAY_TO_BANK": "Сдача в банк",
  // "PAY_TO_BANK_COLLECTION": "Инкассация в банк",
  // "PAY_TO_DEBTS_AND_CREDITS": "Оплата по кредитам и займам полученным",
  // "PAY_GIVE_DEBT_TO_EMPLOYEE": "Выдача займа сотруднику",
};

Map<String, String> incomeType = {
  "PAY_FROM_CLIENT": "Поступление оплаты от клиента",
  "PAY_FROM_OTHER_ORG": "Поступление от другой организации",
  "PAY_FROM_OTHER_CASH": "Поступление из дургой кассы",
  "PAY_FROM_BANK": "Поступление из банка",
  "PAY_FROM_CREDIT": "Поступление по кредитам",
  "PAY_FROM_COUNTERPARTY": "Погашение займа контрагентом",
  "PAY_FROM_EMPLOYEE": "Погашение займа сотрудником",
  "PAY_OTHER": "Прочие поступление",
  "RETURN_FROM_SUPPLIER": "Возврат от поставщика",
  // "RETURN_FROM_ACCOUNTABLE": "Возврат от подотчетника",
};

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _PriceSettingsScreenState();
}

class _PriceSettingsScreenState extends State<FinanceScreen> {
  MyDatabase database = Get.find<MyDatabase>();

  // String? _selectedExpenseType;
  // String? _selectedIncomeType;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
        title: Text('Moliya', style: TextStyle(color: AppColors.appColorWhite)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: 'Xarajat kassa orderi',
                      child: Icon(Icons.upload, color: AppColors.appColorWhite, size: 25),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 300,
                      child: AppDropDown(
                        selectedValue: null,
                        onChanged: (value) {
                          setState(() {
                            // _selectedExpenseType = value;
                            _showExpenseDialog(value);
                          });
                        },
                        dropDownItems: expenseType.keys.toList(),
                        icon: Icon(Icons.add_rounded, color: AppColors.appColorGreen400),
                        iconSize: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Kirim kassa orderi',
                      child: Icon(Icons.download, color: AppColors.appColorWhite, size: 25),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 300,
                      child: AppDropDown(
                        selectedValue: null,
                        onChanged: (value) {
                          setState(() {
                            // _selectedIncomeType = value;
                            _showIncomeDialog(value);
                          });
                        },
                        dropDownItems: incomeType.keys.toList(),
                        icon: Icon(Icons.add_rounded, color: AppColors.appColorGreen400),
                        iconSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: height - 133,
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.appColorBlackBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Card(
                                  color: Colors.grey.shade800,
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.PAY_TO_SUPPLIER);
                                    },
                                    leading: Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite),
                                    title: Text('Taminotchiga to\'lov', style: TextStyle(color: AppColors.appColorWhite)),
                                    subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                  ),
                                ),
                                Card(
                                  color: Colors.grey.shade800,
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.PAY_TO_ORGANIZATION);
                                    },
                                    leading: Icon(UniconsLine.building, color: AppColors.appColorWhite),
                                    title: Text('Boshqa organizatsiya to\'lov', style: TextStyle(color: AppColors.appColorWhite)),
                                    subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                  ),
                                ),
                                Card(
                                  color: Colors.grey.shade800,
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.PAY_TO_ANOTHER_CASH);
                                    },
                                    leading: Icon(Icons.point_of_sale_rounded, color: AppColors.appColorWhite),
                                    title: Text('Boshqa kassaga chiqarish', style: TextStyle(color: AppColors.appColorWhite)),
                                    subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                  ),
                                ),
                                Card(
                                  color: Colors.grey.shade800,
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.PAY_GIVE_TO_COUNTERPARTY_DEBT);
                                    },
                                    leading: Icon(UniconsLine.user_md, color: AppColors.appColorWhite),
                                    title: Text('Kontragentga zaym berish', style: TextStyle(color: AppColors.appColorWhite)),
                                    subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                  ),
                                ),
                                Card(
                                  color: Colors.grey.shade800,
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.PAY_TO_OTHER_CONSUMPTION);
                                    },
                                    leading: Icon(Icons.analytics_outlined, color: AppColors.appColorWhite),
                                    title: Text('Boshqa xarajat', style: TextStyle(color: AppColors.appColorWhite)),
                                    subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: height - 133,
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.appColorBlackBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_CLIENT,
                                            route: "/income/client-income/all",
                                            screenName: "Mijozdan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(UniconsLine.user, color: AppColors.appColorWhite),
                                      title: Text('Mijozdan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_OTHER_ORG,
                                            route: "/income/organization-income/all",
                                            screenName: "Kontragentdan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(UniconsLine.building, color: AppColors.appColorWhite),
                                      title:
                                          Text('Boshqa organizatsiyadan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_OTHER_CASH,
                                            route: "/income/pos-income/all",
                                            screenName: "Kassadan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.point_of_sale_rounded, color: AppColors.appColorWhite),
                                      title: Text('Boshqa kassadan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_BANK,
                                            route: "/income/bank-income/all",
                                            screenName: "Bankdan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.other_houses_sharp, color: AppColors.appColorWhite),
                                      title: Text('Bankdan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_CREDIT,
                                            route: "/income/credit-loan-income/all",
                                            screenName: "Kreditdan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.arrow_circle_down, color: AppColors.appColorWhite),
                                      title: Text('Kreditdan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_COUNTERPARTY,
                                            route: "/income/counterparty-income/all",
                                            screenName: "Kontragentdan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(UniconsLine.user_md, color: AppColors.appColorWhite),
                                      title: Text('Kontragentdan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_FROM_EMPLOYEE,
                                            route: "/income/employee-loan-income/all",
                                            screenName: "Hodimdan kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite),
                                      title: Text('Hodimdan kirim', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.RETURN_FROM_SUPPLIER,
                                            route: "/income/supplier-return-income/all",
                                            screenName: "Taminotchidan qaytganlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.arrow_upward_sharp, color: AppColors.appColorWhite),
                                      title: Text('Taminotchidan qaytarish', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey.shade800,
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => const IncomeWrapperScreen(
                                            itemType: IncomeWrapperScreenType.PAY_OTHER,
                                            route: "/income/other-income/all",
                                            screenName: "Boshqa kirimlar",
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.arrow_downward_sharp, color: AppColors.appColorWhite),
                                      title: Text('Boshqa kirimlar', style: TextStyle(color: AppColors.appColorWhite)),
                                      subtitle: Text('...', style: TextStyle(color: AppColors.appColorWhite)),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showExpenseDialog(String selectedValue) {
    switch (selectedValue) {
      case "PAY_TO_SUPPLIER":
        showDialog(
            context: context,
            builder: (context) {
              return const PayToSupplierDialog();
            });
        break;
      case "PAY_TO_OTHER_ORG":
        showDialog(
            context: context,
            builder: (context) {
              return const PayToOtherOrgDialog();
            });
        break;
      case "ISSUANCE_TO_ANOTHER_CASH":
        showDialog(
            context: context,
            builder: (context) {
              return const PaySendToAnotherCashDialog();
            });
        break;
      case "ISSUANCE_TO_COUNTERPARTY":
        showDialog(
            context: context,
            builder: (context) {
              return const PayGiveToCounterpartyDialog();
            });
        break;
      case "OTHER_EXPENSE":
        showDialog(
            context: context,
            builder: (context) {
              return const PayOtherExpenseDialog();
            });
        break;
      default:
        break;
    }
  }

  void _showIncomeDialog(String selectedValue) {
    switch (selectedValue) {
      case "PAY_FROM_CLIENT":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromClientDialog();
            });
        break;
      case "PAY_FROM_OTHER_ORG":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromOtherOrgDialog();
            });
        break;
      case "PAY_FROM_OTHER_CASH":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromOtherCashDialog();
            });
        break;
      case "PAY_FROM_BANK":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromBankDialog();
            });
        break;
      case "PAY_FROM_CREDIT":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromCreditDialog();
            });
        break;
      case "PAY_FROM_COUNTERPARTY":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromCounterpartyDialog();
            });
        break;
      case "PAY_FROM_EMPLOYEE":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromEmployeeDialog();
            });
        break;
      case "PAY_OTHER":
        showDialog(
            context: context,
            builder: (context) {
              return const ComeFromOtherDialog();
            });
        break;
      case 'RETURN_FROM_SUPPLIER':
        showDialog(
            context: context,
            builder: (context) {
              return const ReturnFromSupplier();
            });
        break;
      default:
        break;
    }
  }
}

enum IncomeWrapperScreenType {
  PAY_FROM_CLIENT,
  PAY_FROM_OTHER_ORG,
  PAY_FROM_OTHER_CASH,
  PAY_FROM_BANK,
  PAY_FROM_CREDIT,
  PAY_FROM_COUNTERPARTY,
  PAY_FROM_EMPLOYEE,
  PAY_OTHER,
  RETURN_FROM_SUPPLIER;
}
