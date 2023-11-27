import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/category_screen/widget/add_barcode_dialog.dart';
import 'package:easy_sell/screens/category_screen/widget/category_side.dart';
import 'package:easy_sell/utils/translator.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_dropdown.dart';
import '../../../../../widgets/app_input_underline.dart';

class ProductInfoDialog extends StatefulWidget {
  const ProductInfoDialog({Key? key, this.product, required this.callback, this.onProductCreated, this.hideCategory})
      : super(key: key);
  final ProductDTO? product;
  final Function() callback;
  final Function(ProductData)? onProductCreated;
  final bool? hideCategory;

  @override
  State<ProductInfoDialog> createState() => _ProductInfoDialogState();
}

class _ProductInfoDialogState extends State<ProductInfoDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController mainVendorCode = TextEditingController();
  final TextEditingController supplierVendorCode = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();

  final TextEditingController _productInBoxController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController valueAddedTaxController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  CategoryData? selectedCategory;

  List<SeasonData> seasons = [];
  List<SeasonData> selectedSeasons = [];
  bool loading = false;
  List<BarcodeData> barcodes = [];

  String selectedUnit = 'PIECE';
  List<String> dropdownItems = [
    'PIECE',
    'METRE',
    'KG',
    'LITRE',
  ];

  @override
  void initState() {
    super.initState();
    initProduct();
    setCategory();
    getSeasons();
    setState(() {
      selectedSeasons = widget.product?.seasons ?? [];
    });
  }

  Future<void> getSeasons() async {
    setState(() {
      loading = true;
    });
    seasons = await database.seasonDao.getAllSeasons();
    setState(() {
      loading = false;
    });
  }

  void initProduct() async {
    if (widget.product != null) {
      setState(() {
        _nameController.text = widget.product!.productData.name;
        mainVendorCode.text = widget.product!.productData.code ?? '';
        supplierVendorCode.text = widget.product!.productData.vendorCode ?? '';
        valueAddedTaxController.text = widget.product!.productData.valueAddedTax.toString();
        selectedUnit = widget.product!.productData.unit;
        _descriptionController.text = widget.product!.productData.description ?? '';
        barcodes = widget.product?.barcodes ?? [];
      });
    }
  }

  void setCategory() async {
    if (widget.product != null) {
      CategoryData? category = await database.categoryDao.getById(widget.product!.productData.categoryId ?? -1);
      setState(() {
        selectedCategory = category;
      });
    }
  }

  void createNewProduct() async {
    if (!_formValidation.currentState!.validate()) return;
    try {
      if (selectedCategory == null) return showAppSnackBar(context, "Kategoriya tanlanmagan", "OK", isError: true);

      if (widget.product == null) {
        bool checkFromDatabase = await database.productDao.checkProductExist(mainVendorCode.text);
        if (checkFromDatabase) {
          throw 'Bunday maxsulot mavjud';
        }
        ProductCompanion newProduct = ProductCompanion(
          name: toValue(_nameController.text),
          createdAt: toValue(DateTime.now()),
          updatedAt: toValue(DateTime.now()),
          description: toValue(_descriptionController.text),
          categoryId: toValue(selectedCategory?.id),
          code: toValue(mainVendorCode.text),
          vendorCode: toValue(supplierVendorCode.text),
          isKit: toValue(false),
          unit: toValue(selectedUnit),
          valueAddedTax: toValue(double.tryParse(valueAddedTaxController.text) ?? 0),
          isSynced: toValue(false),
          barcode: barcodes.isNotEmpty ? toValue(barcodes[0].barcode) : toValue(""),
        );
        ProductData? newProductData = await database.productDao.createWithCompanion(newProduct);
        for (SeasonData season in selectedSeasons) {
          await database.productWithSeasonDao.createProductWithSeason(ProductWithSeasonCompanion(
            productId: toValue(newProductData.id),
            seasonId: toValue(season.id),
          ));
        }
        // update barcodes
        for (BarcodeData barcode in barcodes) {
          await database.barcodeDao.updateBarcode(barcode.copyWith(productId: newProductData.id));
        }
        widget.onProductCreated?.call(newProductData);
      } else {
        ProductData? updated = widget.product?.productData.copyWith(
          valueAddedTax: toValue(double.tryParse(valueAddedTaxController.text.replaceAll(" ", "")) ?? 0),
          unit: selectedUnit,
          vendorCode: toValue(supplierVendorCode.text),
          code: toValue(mainVendorCode.text),
          categoryId: toValue(selectedCategory?.id),
          description: toValue(_descriptionController.text),
          updatedAt: (DateTime.now()),
          isSynced: false,
          name: (_nameController.text),
        );
        for (BarcodeData barcode in barcodes) {
          await database.barcodeDao.updateBarcode(barcode.copyWith(productId: updated?.id));
        }
        if (selectedSeasons.isEmpty) {
          await database.productWithSeasonDao.deleteByProductId(updated?.id ?? -1);
        }

        for (SeasonData season in selectedSeasons) {
          await database.productWithSeasonDao.updateWithProductId(ProductWithSeasonCompanion(
            productId: toValue(updated?.id),
            seasonId: toValue(season.id),
          ));
        }

        await database.productDao.updateWithReplaceByData(updated!);
        widget.onProductCreated?.call(updated);
      }
      widget.callback();
      Get.back();
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi: $e", "OK", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
          ),
        ),
        Text(widget.product != null ? 'Maxsulot malumotlari' : 'Maxsulot yaratish',
            style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      ]),
      content: SizedBox(
        height: 500,
        width: 350,
        child: Form(
            key: _formValidation,
            child: SingleChildScrollView(
              child: Column(children: [
                AppInputUnderline(
                  hintText: 'Maxsulot nomi',
                  controller: _nameController,
                  prefixIcon: UniconsLine.box,
                  validator: AppValidator().nameValidate,
                ),
                AppInputUnderline(
                  hintText: 'Taminotchi artikuli',
                  controller: supplierVendorCode,
                  prefixIcon: UniconsLine.code_branch,
                ),
                AppInputUnderline(
                  hintText: 'Artikuli',
                  controller: mainVendorCode,
                  prefixIcon: UniconsLine.bars,
                  validator: AppValidator().validate,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  subtitle: Text(
                    barcodes.map((e) => e.barcode).join(", "),
                    style: TextStyle(
                      color: AppColors.appColorGrey400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  title: Text("Shtrix Kodi", style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  trailing: Badge(
                      label: Text(
                        barcodes.length.toString(),
                        style: TextStyle(color: AppColors.appColorWhite),
                      ),
                      child: Icon(Icons.keyboard_arrow_right_outlined, color: AppColors.appColorWhite)),
                  leading: Icon(UniconsLine.qrcode_scan, color: AppColors.appColorWhite),
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: AppColors.appColorBlackBg,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return AddBarcodeDialog(
                            initialBarcodes: barcodes,
                            product: widget.product,
                            callback: widget.callback,
                            getBarcodes: (List<BarcodeData> generatedBarcodes) {
                              setState(() {
                                barcodes = generatedBarcodes;
                              });
                            },
                          );
                        });
                  },
                ),
                Divider(color: AppColors.appColorGrey300, height: 0, thickness: 0.5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  subtitle: Text('Kategoriyasi', style: TextStyle(color: AppColors.appColorGrey400)),
                  title: Text(selectedCategory?.name ?? '<tanlanmagan>',
                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined, color: AppColors.appColorWhite),
                  leading: Icon(UniconsLine.list_ui_alt, color: AppColors.appColorWhite),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black.withOpacity(0.9),
                        title: Text('Kategoriyani tanlang', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                        content: SizedBox(
                          width: Get.width / 3,
                          height: Get.height / 1.5,
                          child: Column(
                            children: [
                              CategorySide(
                                hideToolBar: false,
                                getProducts: (int id) {},
                                loadingCategory: false,
                                syncCategory: () async {},
                                setSelectCategory: (CategoryData? category) {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          AppButton(
                            onTap: () {
                              setState(() {
                                selectedCategory = null;
                              });
                              Get.back();
                            },
                            width: 100,
                            height: 40,
                            color: AppColors.appColorRed400,
                            hoverColor: AppColors.appColorRed300,
                            colorOnClick: AppColors.appColorRed400,
                            splashColor: AppColors.appColorRed400,
                            borderRadius: BorderRadius.circular(12),
                            hoverRadius: BorderRadius.circular(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bekor qilish',
                                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          AppButton(
                            onTap: () {
                              Get.back();
                            },
                            width: 100,
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
                                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(color: AppColors.appColorGrey300, height: 0, thickness: 0.5),
                ExpansionTile(
                  title: Text('Qo\'shimcha', style: TextStyle(color: AppColors.appColorWhite)),
                  tilePadding: const EdgeInsets.all(0),
                  trailing: Icon(Icons.arrow_drop_down_rounded, color: AppColors.appColorWhite),
                  children: [
                    const SizedBox(height: 10),
                    AppInputUnderline(
                      controller: valueAddedTaxController,
                      hintText: "Qo'shimcha Qiymat Solig'i (qqs)",
                      prefixIcon: UniconsLine.percentage,
                    ),
                    const SizedBox(height: 10),
                    AppDropDown(
                      selectedValue: selectedUnit.isNotEmpty ? selectedUnit : dropdownItems[0],
                      dropDownItems: dropdownItems,
                      onChanged: (value) {
                        selectedUnit = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    AppDropDown(
                      selectedValue: seasons.isNotEmpty ? seasons[0].name : "",
                      dropDownItems: seasons.map((e) => e.name).toList(),
                      onChanged: (value) {
                        SeasonData season = seasons.firstWhere((element) => element.name == value);
                        bool isExist = selectedSeasons.any((element) => element.id == season.id);
                        if (!isExist) {
                          setState(() {
                            selectedSeasons.add(season);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      children: selectedSeasons
                          .map(
                            (e) => Chip(
                              backgroundColor: AppColors.appColorGreen400,
                              elevation: 0,
                              deleteIconColor: AppColors.appColorWhite,
                              side: const BorderSide(color: Colors.transparent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              label: Text(translate(e.name), style: TextStyle(color: AppColors.appColorWhite)),
                              onDeleted: () async {
                                setState(() {
                                  selectedSeasons.remove(e);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    AppInputUnderline(
                      hintText: "Izoh",
                      maxLines: 2,
                      controller: _descriptionController,
                      prefixIcon: UniconsLine.comment_alt,
                    ),
                  ],
                ),
              ]),
            )),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.product == null)
              AppButton(
                onTap: () => _clearFields(),
                height: 40,
                width: 40,
                borderRadius: BorderRadius.circular(15),
                hoverRadius: BorderRadius.circular(15),
                child: Center(
                  child: Icon(Icons.cleaning_services_rounded, color: AppColors.appColorWhite),
                ),
              ),
            AppButton(
              tooltip: '',
              onTap: createNewProduct,
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
                    widget.product != null ? 'Saqlash' : 'Yaratish',
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

  void _clearFields() {
    _nameController.clear();
    mainVendorCode.clear();
    _qrCodeController.clear();
    _descriptionController.clear();
    _productInBoxController.clear();
    _volumeController.clear();
    _weightController.clear();
  }
}
