import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/category_screen/widget/category_side.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_screen/widget/product_item.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../database/model/product_dto.dart';
import '../../utils/routes.dart';
import '../../widgets/app_button.dart';
import '../sync_screen/syn_enums.dart';
import '../warehouse_screen/screens/product_screen/widget/product_info_dialog.dart';

class CategoryTestScreen extends StatefulWidget {
  const CategoryTestScreen({super.key});

  @override
  State<CategoryTestScreen> createState() => _CategoryTestScreenState();
}

class _CategoryTestScreenState extends State<CategoryTestScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  bool loadingProducts = false;
  bool loadingCategory = false;
  late UploadFunctions uploadFunctions;
  late DownloadFunctions downloadFunctions;

  Future<void> syncCategory() async {
    try {
      setState(() {
        loadingCategory = true;
      });
      await uploadFunctions.uploadCategories("");
      await downloadFunctions.getCategories("");
      setState(() {
        loadingCategory = false;
      });
    } catch (e) {
      setState(() {
        loadingCategory = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
    downloadFunctions = DownloadFunctions(database: database, progress: {}, setter: setter);
  }

  void setter(void Function() fn) {}

  List<ProductDTO> products = [];

  void getProducts(
    int categoryId, {
    String search = '',
  }) async {
    setState(() {
      loadingProducts = true;
    });
    List<ProductDTO> products_ = await database.productDao.getProductsByCategoryId(categoryId, search: search);
    setState(() {
      products = products_;
      loadingProducts = false;
    });
  }

  void searchProducts({
    String search = '',
  }) async {
    setState(() {
      loadingProducts = true;
    });
    List<ProductDTO> products_ = await database.productDao.getAllProductsByLimitOrSearch(search: search);
    setState(() {
      products = products_;
      loadingProducts = false;
    });
  }

  bool isOpen = true;
  bool isExpandAll = false;
  CategoryData? selectedCategory;

  void createNewProduct() async {
    try {
      showDialog(
          context: context,
          builder: (context) => ProductInfoDialog(
                callback: () {},
                hideCategory: true,
                onProductCreated: _handleCreatedProduct,
              ));
    } catch (e) {
      showAppSnackBar(context, 'Xatolik yuz berdi: $e', 'OK', isError: true);
    }
  }

  void _handleCreatedProduct(ProductData data) async {
    try {
      await uploadFunctions.autoUpload(UploadTypes.PRODUCTS);
      await downloadFunctions.getProducts('');
      await downloadFunctions.getBarcodes('');
      getProducts(selectedCategory?.id ?? -1);
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
      }
    }
  }

  void syncProducts() async {
    try {
      await uploadFunctions.autoUpload(UploadTypes.PRODUCTS);
      await downloadFunctions.getProducts('');
      await downloadFunctions.getBarcodes('');
      getProducts(selectedCategory?.id ?? -1);
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
        title: Text('Kategoriya', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          AppButton(
            onTap: () async {
              await Get.toNamed(Routes.SEASON);
              // _getAllProductIncome();
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: 150,
            height: 40,
            margin: const EdgeInsets.all(7),
            color: Colors.transparent,
            hoverColor: Colors.green,
            colorOnClick: Colors.teal,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(15),
            hoverRadius: BorderRadius.circular(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sunny_snowing, color: AppColors.appColorWhite, size: 22),
                const SizedBox(width: 5),
                Text('Mavsumlar', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          AppButton(
            onTap: () async {
              await Get.toNamed(Routes.WAREHOUSE_BOX_ADD);
              // _getAllProductIncome();
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Colors.pink, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: 100,
            height: 40,
            margin: const EdgeInsets.all(7),
            color: Colors.transparent,
            hoverColor: Colors.pinkAccent,
            colorOnClick: Colors.pink,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(15),
            hoverRadius: BorderRadius.circular(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(UniconsLine.gift, color: AppColors.appColorWhite, size: 22),
                const SizedBox(width: 5),
                Text('Set', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          AppButton(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(7),
            color: AppColors.appColorGrey700.withOpacity(0.5),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(13),
            hoverRadius: BorderRadius.circular(13),
            child: Icon(Icons.menu_rounded, color: AppColors.appColorWhite),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      border: Border(right: BorderSide(color: Colors.white.withOpacity(0.2))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          onTap: createNewProduct,
                          width: 150,
                          height: 60,
                          color: AppColors.appColorGreen400,
                          borderRadius: BorderRadius.circular(10),
                          hoverRadius: BorderRadius.circular(10),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('Mahsulot Qo\'shish', style: TextStyle(color: Colors.white)),
                          ]),
                        ),
                        Text(
                          'Kategoriya: ${selectedCategory?.name ?? '<Tanlanmagan>'}',
                          style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors.appColorBlackBgHover,
                      border: Border(right: BorderSide(color: Colors.white.withOpacity(0.2))),
                    ),
                    child: loadingProducts
                        ? Center(child: CircularProgressIndicator(color: AppColors.appColorWhite))
                        : products.isEmpty
                            ? Center(child: Text('Mahsulotlar mavjud emas', style: TextStyle(color: AppColors.appColorWhite)))
                            : ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return LongPressDraggable<ProductDTO>(
                                    data: products[index],
                                    dragAnchorStrategy: childDragAnchorStrategy,
                                    feedback: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.shopping_bag_rounded, color: Colors.orangeAccent, size: 40),
                                    ),
                                    child: Column(
                                      children: [
                                        ProductItem(
                                          product: products[index],
                                          index: index,
                                          callback: syncProducts,
                                        ),
                                        const Divider(color: Colors.white, height: 0, thickness: 0.5),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      onChanged: (value) {
                        searchProducts(search: value);
                      },
                      style: TextStyle(color: AppColors.appColorWhite),
                      decoration: InputDecoration(
                        hintText: 'Mahsulot qidirish',
                        hintStyle: TextStyle(color: AppColors.appColorWhite.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.appColorWhite.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isOpen)
            CategorySide(
              syncCategory: syncCategory,
              loadingCategory: loadingCategory,
              getProducts: getProducts,
              setSelectCategory: (CategoryData? category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
        ],
      ),
    );
  }
}
