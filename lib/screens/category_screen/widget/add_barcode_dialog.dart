import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_barcode.dart';
import 'add_barcode.dart';

class AddBarcodeDialog extends StatefulWidget {
  const AddBarcodeDialog(
      {super.key, this.product, required this.callback, required this.getBarcodes, required this.initialBarcodes});

  final List<BarcodeData> initialBarcodes;
  final ProductDTO? product;
  final Function() callback;
  final Function(List<BarcodeData> barcodes) getBarcodes;

  @override
  State<AddBarcodeDialog> createState() => _AddBarcodeDialogState();
}

class _AddBarcodeDialogState extends State<AddBarcodeDialog> {
  List<BarcodeData> barcodes = [];

  @override
  void initState() {
    super.initState();
    barcodes = widget.initialBarcodes;
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: (barcodes.isEmpty)
                ? Center(
                    child: Text('Barcodelar Mavjud emas', style: TextStyle(color: AppColors.appColorWhite)),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                          hoverColor: AppColors.appColorGreen300,
                          style: ListTileStyle.drawer,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.appColorGreen300,
                            child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                          ),
                          title: Text(barcodes[index].barcode, style: TextStyle(color: AppColors.appColorWhite)),
                          subtitle:
                              Text(formatDateTime(barcodes[index].createdAt), style: TextStyle(color: AppColors.appColorGrey300)),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return PrintBarcode(
                                  barcode: barcodes[index].barcode,
                                  vendorCode: widget.product?.productData.vendorCode ?? '-',
                                );
                              },
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showAppAlertDialog(
                                    context,
                                    title: 'Diqqat!',
                                    message: 'Barcodeni o\'chirishni xohlaysizmi?',
                                    onConfirm: () async {
                                      try {
                                        await database.barcodeDao.deleteByBarcode(barcodes[index].barcode);
                                        setState(() {
                                          barcodes.removeAt(index);
                                        });
                                        widget.getBarcodes(barcodes);
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    buttonLabel: 'Ha',
                                    cancelLabel: 'Yo\'q',
                                  );
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ));
                    },
                    itemCount: barcodes.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 1, color: Colors.white24);
                    },
                  ),
          ),
          AddBarcodeButton(
            product: widget.product,
            getNewBarcode: (BarcodeData newBarcode) {
              setState(() {
                barcodes.add(newBarcode);
              });
              widget.getBarcodes(barcodes);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
