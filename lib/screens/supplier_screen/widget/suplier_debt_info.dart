import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../database/model/product_income_document.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';

class SupplierDebtInfo extends StatefulWidget {
  const SupplierDebtInfo({super.key, required this.supplier, required this.supplierDebt});

  final SupplierDto supplier;
  final double supplierDebt;

  @override
  State<SupplierDebtInfo> createState() => _SupplierDebtInfoState();
}

class _SupplierDebtInfoState extends State<SupplierDebtInfo> {
  MyDatabase database = Get.find<MyDatabase>();
  List<ProductIncomeDocumentDto> productIncomeDocumentDto = [];
  int payedIndex = 0;

  @override
  void initState() {
    super.initState();
    getSupplierDebt();
  }

  Future<void> getSupplierDebt() async {
    List<ProductIncomeDocumentDto> productIncomeDocumentDto_ = [];
    await findPayedIndex(productIncomeDocumentDto_);
    setState(() {
      productIncomeDocumentDto = productIncomeDocumentDto_;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ta\'minotchi malumotlari', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.supplier.name}ning hisobi', style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                  Text(formatNumber(widget.supplierDebt), style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                ],
              ),
            ),
          ],
        ),
      ]),
      content: SizedBox(
        height: 300,
        width: 600,
        child: ListView.separated(
            itemBuilder: (context, index) {
              ProductIncomeDocumentDto item = productIncomeDocumentDto[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: payedIndex == -1
                      ? AppColors.appColorRed400.withOpacity(0.5)
                      : index <= payedIndex
                          ? AppColors.appColorRed400.withOpacity(0.5)
                          : AppColors.appColorGreen400.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${index + 1}. ', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    FutureBuilder(
                      future: calculateTotal(item),
                      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                        if (snapshot.hasData) {
                          return Text(formatNumber(snapshot.data ?? 0), style: TextStyle(color: AppColors.appColorWhite));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Muddat: ${item.expiredDebtDate == null ? '<Kirilmagan>' : formatDate(item.expiredDebtDate)} ',
                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                        Text('${item.createdAt == null ? '<Kirilmagan>' : formatDate(item.createdTime)} ',
                            style: TextStyle(color: AppColors.appColorGrey300, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(color: AppColors.appColorWhite, height: 0, thickness: 0.5),
            itemCount: productIncomeDocumentDto.length),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(
              tooltip: '',
              onTap: () {
                Get.back();
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
                    'OK',
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

  Future<double> calculateTotal(ProductIncomeDocumentDto productIncomeDocumentDto) async {
    double total = 0;
    // for (ProductIncomeDto productIncome in productIncomeDocumentDto.productIncomes) {
    //   // ExchangeRateData? exchangeRateData =
    //   //     await database.exchangeRateDao.getExchangeRateByCreatedAtSmallThan(productIncome.createdAt);
    //   bool productIncomeCurrency = productIncome.currency == ProductIncomeCurrency.USD;
    //   if (currency) {
    //     if (productIncomeCurrency) {
    //       total += productIncome.price * productIncome.amount;
    //     } else {
    //       total += productIncome.price * productIncome.amount / (1);
    //     }
    //   } else {
    //     if (productIncomeCurrency) {
    //       total += productIncome.price * productIncome.amount * (1);
    //     } else {
    //       total += productIncome.price * productIncome.amount;
    //     }
    //   }
    // }
    return total;
  }

  Future<void> findPayedIndex(List<ProductIncomeDocumentDto> productIncomeDocumentDtos) async {
    int payedUntilIndex = -1;
    double totalDebt = widget.supplierDebt;
    for (int i = 0; i < productIncomeDocumentDtos.length; i++) {
      double total = await calculateTotal(productIncomeDocumentDtos[i]);
      totalDebt -= total;
      if (totalDebt < 0) {
        payedUntilIndex = i;
        break;
      }
    }
    setState(() {
      payedIndex = payedUntilIndex;
    });
  }
}
