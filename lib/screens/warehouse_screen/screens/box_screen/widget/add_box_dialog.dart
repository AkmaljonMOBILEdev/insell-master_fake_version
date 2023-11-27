import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/box_screen/widget/add_box_dialog_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../widgets/app_autocomplete.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_dialog.dart';
import '../../../../../widgets/app_input_underline.dart';
import '../../../../sync_screen/syn_enums.dart';

class AddBoxDialog extends StatefulWidget {
  const AddBoxDialog({super.key, required this.setProductBox});

  final Null Function(ProductDTO product) setProductBox;

  @override
  State<AddBoxDialog> createState() => _AddBoxDialogState();
}

class _AddBoxDialogState extends State<AddBoxDialog> {
  final _formKey = GlobalKey<FormState>();
  MyDatabase database = Get.find<MyDatabase>();
  final boxNameController = TextEditingController();
  final boxDescriptionController = TextEditingController();
  final boxPriceController = TextEditingController();
  final boxBarcodeController = TextEditingController();
  final boxVendorCodeController = TextEditingController();
  final _searchController = TextEditingController();
  List<ProductDTO> _searchList = [];
  final List<BoxItemsStruct> _boxItems = [];
  List<CategoryData> _categories = [];
  CategoryData? selectedCategory;
  late UploadFunctions uploadFunctions;

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, setter: setter, progress: {});
    getCategories();
  }

  Future<double> getLastIncomePrice(int productId) async {
    // double price = await database.productIncomeDao.lastPriceByProductId(productId);
    return 0;
  }

  void setter(Function f) {}

  void getCategories() async {
    _categories = await database.categoryDao.getAllCategories();
    setState(() {
      _categories = _categories;
    });
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
          Text('Set yaratish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            width: 900,
            height: 500,
            child: Column(
              children: [
                Container(
                  width: 850,
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration:
                      BoxDecoration(color: Colors.grey.shade800.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 200,
                            child: AppInputUnderline(
                              hintText: 'Set nomi',
                              textInputAction: TextInputAction.newline,
                              prefixIcon: UniconsLine.box,
                              controller: boxNameController,
                              validator: AppValidator().validate,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: AppInputUnderline(
                              hintText: 'Barcode',
                              textInputAction: TextInputAction.newline,
                              prefixIcon: UniconsLine.qrcode_scan,
                              controller: boxBarcodeController,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.generating_tokens_outlined, color: AppColors.appColorWhite, size: 24),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: AppInputUnderline(
                              hintText: 'Vendorcode',
                              textInputAction: TextInputAction.newline,
                              prefixIcon: UniconsLine.code_branch,
                              controller: boxVendorCodeController,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: AppInputUnderline(
                              maxLines: 1,
                              hintText: 'Sotuv narx',
                              textInputAction: TextInputAction.newline,
                              prefixIcon: UniconsLine.money_insert,
                              iconColor: AppColors.appColorGreen400,
                              controller: boxPriceController,
                              inputFormatters: [AppTextInputFormatter()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 205,
                            child: AppAutoComplete(
                              initialValue: selectedCategory?.name ?? 'Kategoriya',
                              getValue: (AutocompleteDataStruct value) {
                                setState(() {
                                  selectedCategory = _categories
                                      .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId);
                                });
                              },
                              options: _categories
                                  .map(
                                    (e) => AutocompleteDataStruct(
                                      uniqueId: e.id,
                                      value: e.name,
                                    ),
                                  )
                                  .toList(),
                              hintText: 'Kategoriya',
                              prefixIcon: UniconsLine.list_ui_alt,
                            ),
                          ),
                          SizedBox(
                            width: 320,
                            child: AppInputUnderline(
                              maxLines: 1,
                              hintText: 'Izoh',
                              textInputAction: TextInputAction.newline,
                              prefixIcon: UniconsLine.comment_alt,
                              controller: boxDescriptionController,
                            ),
                          ),
                          Container(
                            width: 300,
                            height: 45,
                            padding: const EdgeInsets.all(5),
                            decoration:
                                BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(UniconsLine.money_bill, color: Colors.blue, size: 24),
                                    Text('Tan narx:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                                  ],
                                ),
                                Text(totalSum(), style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 10,
                  child: Container(
                    width: 850,
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(color: Colors.grey.shade800.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                    child: ListView.separated(
                      itemCount: _boxItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AddBoxDialogItem(
                          index: index + 1,
                          item: _boxItems[index],
                          setAmount: (double value) {
                            setState(() {
                              _boxItems[index].amount = value;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _boxItems.removeAt(index);
                            });
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Colors.white24),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                if (_searchController.text.isNotEmpty)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColors.appColorBlackBg,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _searchList
                              .map((product) => Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        _searchController.clear();
                                        double price = await getLastIncomePrice(product.productData.id);
                                        setState(() {
                                          _searchList.clear();
                                          _boxItems.add(BoxItemsStruct(
                                            amount: 1,
                                            product: product,
                                            price: price,
                                          ));
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                                        child:
                                            Text(product.productData.name, style: TextStyle(color: AppColors.appColorGreen400)),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 700,
              child: AppInputUnderline(
                hintText: 'Qidirish',
                prefixIcon: Icons.search,
                onChanged: (value) async {
                  String text = value.toLowerCase();
                  if (text.isEmpty) setState(() => _searchList.clear());
                  if (text.length > 2) {
                    List<ProductDTO> searchProductList =
                        await database.productDao.getAllProductsByLimitOrSearch(search: text, limit: 20);
                    setState(() {
                      _searchList = searchProductList;
                    });
                  }
                },
                controller: _searchController,
              ),
            ),
            AppButton(
              tooltip: '',
              onTap: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    if (_boxItems.isEmpty) {
                      throw "Iltimos, mahsulotlarni tanlang";
                    }
                    ProductDTO box = await database.productDao.createProductTransactionWithCompanionId(
                      ProductCompanion(
                        createdAt: toValue(DateTime.now()),
                        updatedAt: toValue(DateTime.now()),
                        description: toValue(boxDescriptionController.text),
                        name: toValue(boxNameController.text),
                        isKit: toValue(true),
                        unit: toValue('PIECE'),
                        categoryId: toValue(selectedCategory?.id),
                        productsInBox: toValue(_boxItems.length.toString()),
                        vendorCode: toValue(boxVendorCodeController.text),
                        barcode: toValue(boxBarcodeController.text),
                      ),
                      retailPrice: double.parse(boxPriceController.text.replaceAll(" ", "")),
                    );
                    List<ProductKitCompanion> productKitList = [];
                    for (BoxItemsStruct element in _boxItems) {
                      ProductDTO product = element.product;
                      double amount = element.amount;
                      // double price = await database.productIncomeDao.lastPriceByProductId(product.productData.id);
                      double price = 0;
                      productKitList.add(ProductKitCompanion(
                        createdAt: toValue(DateTime.now()),
                        updatedAt: toValue(DateTime.now()),
                        amount: toValue(amount),
                        productId: toValue(product.productData.id),
                        price: toValue(price),
                      ));
                    }
                    await database.productKitDao.batchCreateProductKits(productKitList);
                    await uploadFunctions.autoUpload(UploadTypes.PRODUCTS);
                    box = await database.productDao.getProductWithProductId(box.productData.id);
                    widget.setProductBox(box);
                    Get.back();
                  }
                } catch (e) {
                  showAppAlertDialog(context,
                      title: "XATOLIK:", message: 'Xatolik:${e.toString()}', buttonLabel: "Qaytish", cancelLabel: "Bekor qilish");
                }
              },
              width: 120,
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
                    'Saqlash',
                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  String totalSum() {
    double sum = 0;
    for (var element in _boxItems) {
      sum += element.amount * element.price;
    }
    return formatNumber(sum);
  }
}

class BoxItemsStruct {
  final ProductDTO product;
  double amount;
  double price;

  BoxItemsStruct({required this.product, required this.amount, required this.price});
}
