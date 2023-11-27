import 'dart:io';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:easy_sell/services/excel_service.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class UploadProductWidget extends StatefulWidget {
  const UploadProductWidget({super.key});

  @override
  State<UploadProductWidget> createState() => _UploadProductWidgetState();
}

class _UploadProductWidgetState extends State<UploadProductWidget> {
  String fileName = "";
  int? size;
  List<Map<String, dynamic>> data = [];

  bool loading = false;
  String? error;

  void uploadToServer() async {
    try {
      setState(() {
        loading = true;
      });
      var req = data.where((element) => element['isExist'] == false).map((e) {
        return {
          "categoryName": e['0'].toString(),
          "name": e['1'].toString(),
          "code": e['2'].toString(),
          "vendorCode": e['2'].toString(),
          "seasonsIds": [],
          "barcodes": getBarcodes(e),
        };
      }).toList();
      var res = await HttpServices.post("/product/create/all", req);
      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception(res.body);
      }
      await autoSync();
      setState(() {
        data = [];
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Xatolik yuz berdi: $e';
        loading = false;
      });
    }
  }

  List<String> getBarcodes(Map<String, dynamic> data) {
    List<String> barcodes = [];
    for (var j = 3; j < 20; j++) {
      if (data['$j'] != null) barcodes.add(data['$j'].toString());
    }
    return barcodes;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(dialogTitle: 'Excel faylni tanlang', type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);

                  if (result != null) {
                    File file = File(result.files.single.path ?? '');
                    data = ExcelService.readExcel(file);
                    setState(() {
                      loading = true;
                    });
                    for (var i = 0; i < data.length; i++) {
                      bool isExist = await database.productDao.checkByCode(data[i]['2'].toString());
                      data[i]['isExist'] = isExist;
                    }
                    setState(() {
                      loading = false;
                      fileName = result.files.single.name;
                      size = result.files.single.size;
                    });
                  } else {
                    // User canceled the picker
                  }
                },
                width: 200,
                height: 40,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(UniconsLine.file_upload, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Fayl tanlash', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
              if (size != null)
                Row(
                  children: [
                    const Icon(UniconsLine.table, color: Colors.white),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fileName, style: const TextStyle(color: Colors.white, fontSize: 18)),
                        Text("${((size ?? 0) / 1024).toStringAsFixed(2)} kb",
                            style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Excel faylning ma\'lumotlari', style: TextStyle(color: Colors.white, fontSize: 18)),
              Text("Jami: ${data.length} ta", style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        Container(
          height: height * 0.55,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.8)),
          ),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(
                      child: Text(
                      error ?? "",
                      style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 18),
                    ))
                  : data.isEmpty
                      ? const Center(
                          child: Text(
                          "Fayl bo'sh yoki tanlanmagan bo'lishi mumkin",
                          style: TextStyle(color: Colors.white),
                        ))
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return AppTableItems(
                              height: 40,
                              layouts: const [1, 1, 1, 1],
                              hideBorder: false,
                              items: [
                                AppTableItemStruct(
                                  innerWidget: Container(
                                    decoration: BoxDecoration(
                                      color: data[index]['isExist'] == true
                                          ? Colors.greenAccent.withOpacity(0.1)
                                          : Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(index.toString(), style: const TextStyle(color: Colors.white)),
                                        const SizedBox(width: 10),
                                        if (data[index]['isExist'] == true) const Icon(UniconsLine.check, color: Colors.green)
                                      ],
                                    ),
                                  ),
                                ),
                                AppTableItemStruct(
                                  innerWidget: Center(
                                      child: Text(data[index]['0'].toString(), style: const TextStyle(color: Colors.white))),
                                ),
                                AppTableItemStruct(
                                  innerWidget: Center(
                                      child: Text(data[index]['1'].toString(), style: const TextStyle(color: Colors.white))),
                                ),
                                AppTableItemStruct(
                                  innerWidget: Center(
                                      child: Text(data[index]['2'].toString(), style: const TextStyle(color: Colors.white))),
                                ),
                              ],
                            );
                          }),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Mavjudlar soni: ${data.where((element) => element['isExist'] == true).length} ta",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    " ( ${(data.where((element) => element['isExist'] == true).length / data.length * 100).toStringAsFixed(2)} % )",
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
                  ),
                ],
              ),
              AppButton(
                onTap: uploadToServer,
                width: 200,
                height: 40,
                color: AppColors.appColorGreen400,
                borderRadius: BorderRadius.circular(10),
                child: const Center(child: Text('Yuklash', style: TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
