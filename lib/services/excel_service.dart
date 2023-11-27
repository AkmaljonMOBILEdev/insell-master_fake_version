import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:excel/excel.dart' as ex;
import 'package:path_provider/path_provider.dart';

class ExcelService {
  static Future<void> createExcelFile(List<List<dynamic>> data, String fileName, BuildContext context) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    if (data.isNotEmpty) {
      sheetObject.appendRow(data[0]);

      // Окраска первой строки
      for (var i = 0; i <= data[0].length; i++) {
        sheetObject.cell(CellIndex.indexByString("${String.fromCharCode(65 + i)}1")).cellStyle = CellStyle(
          backgroundColorHex: "#999999",
          bold: true,
          topBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
          bottomBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
          leftBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
          rightBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
        );
      }

      for (int i = 1; i < data.length; i++) {
        sheetObject.appendRow(data[i]);
      }
      List<int>? fileBytes = excel.save();
      Directory? downloadPath = await getDownloadsDirectory();
      File(join('${downloadPath?.path}/$fileName.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes ?? []);
      OpenFile.open('${downloadPath?.path}/$fileName.xlsx');
    }
  }

  static List<Map<String, dynamic>> readExcel(File file) {
    List<Map<String, dynamic>> result = [];
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]?.rows ?? []) {
        Map<String, dynamic> rowMap = {};
        row.forEach((Data? element) {
          int index = row.indexOf(element);
          rowMap[index.toString()] = element?.value;
        });
        result.add(rowMap);
      }
    }
    return result;
  }

  static createTxtFile(List list, String s, BuildContext context) async {
    String data = '';
    for (int i = 0; i < list.length; i++) {
      data += '${list[i].join("\t")}\n';
    }
    Directory? downloadPath = await getDownloadsDirectory();
    File(join('${downloadPath?.path}/$s.txt'))
      ..createSync(recursive: true)
      ..writeAsStringSync(data);
    OpenFile.open('${downloadPath?.path}/$s.txt');
  }
}
