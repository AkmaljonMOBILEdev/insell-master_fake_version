import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_screen/widget/product_info_dialog.dart';
import 'package:easy_sell/widgets/app_barcode.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_button.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({Key? key, required this.product, required this.callback, required this.index}) : super(key: key);
  final ProductDTO product;
  final VoidCallback callback;
  final int index;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 40,
      hideBorder: true,
      items: [
        AppTableItemStruct(
          flex: 10,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                    color: widget.product.productData.isSynced ? AppColors.appColorGreen700 : Colors.white12,
                    borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                widget.product.productData.name,
                style: TextStyle(color: AppColors.appColorWhite),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        ),
        AppTableItemStruct(
          flex: 8,
          innerWidget:
              Center(child: Text(widget.product.productData.vendorCode ?? "-", style: TextStyle(color: AppColors.appColorWhite))),
        ),
        AppTableItemStruct(
          flex: 8,
          innerWidget:
              Center(child: Text(widget.product.productData.code ?? "-", style: TextStyle(color: AppColors.appColorWhite))),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ProductInfoDialog(
                        product: widget.product,
                        callback: widget.callback,
                      );
                    },
                  );
                },
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(10),
                hoverRadius: BorderRadius.circular(10),
                hoverColor: AppColors.appColorGreen300,
                child: Center(child: Icon(UniconsLine.eye, color: AppColors.appColorWhite, size: 20)),
              ),
              AppButton(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: AppColors.appColorBlackBg,
                      elevation: 0,
                      context: context,
                      builder: (context) {
                        List<BarcodeData> barcodes = widget.product.barcodes;
                        if (widget.product.productData.barcode?.isNotEmpty ?? false) {
                          barcodes = [
                            BarcodeData(
                                id: -1,
                                productId: -1,
                                barcode: widget.product.productData.barcode ?? '',
                                isSynced: false,
                                createdAt: widget.product.productData.createdAt),
                            ...barcodes
                          ];
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.appColorBlackBg,
                            border: Border.all(color: Colors.white24),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text('Barcodes', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                              (barcodes.isEmpty)
                                  ? Center(
                                      child: Text('Barcodelar Mavjud emas', style: TextStyle(color: AppColors.appColorWhite)),
                                    )
                                  : Expanded(
                                      child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              hoverColor: AppColors.appColorGreen300,
                                              style: ListTileStyle.drawer,
                                              leading: CircleAvatar(
                                                backgroundColor: AppColors.appColorGreen300,
                                                child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                                              ),
                                              title:
                                                  Text(barcodes[index].barcode, style: TextStyle(color: AppColors.appColorWhite)),
                                              subtitle: Text(formatDateTime(barcodes[index].createdAt),
                                                  style: TextStyle(color: AppColors.appColorGrey300)),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return PrintBarcode(
                                                      barcode: barcodes[index].barcode,
                                                      vendorCode: widget.product.productData.vendorCode ?? '-',
                                                    );
                                                  },
                                                );
                                              },
                                              trailing: IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return PrintBarcode(
                                                        barcode: barcodes[index].barcode,
                                                        vendorCode: widget.product.productData.vendorCode ?? '-',
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(UniconsLine.arrow_right, color: AppColors.appColorGreen300),
                                              ));
                                        },
                                        itemCount: barcodes.length,
                                        separatorBuilder: (BuildContext context, int index) {
                                          return const Divider(height: 1, color: Colors.white24);
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        );
                      });
                },
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(10),
                hoverRadius: BorderRadius.circular(10),
                child: Center(child: Icon(UniconsLine.print, color: AppColors.appColorGreen300, size: 20)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
