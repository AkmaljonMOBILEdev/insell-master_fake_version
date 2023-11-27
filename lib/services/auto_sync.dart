import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:get/get.dart';

MyDatabase database = Get.find<MyDatabase>();
UploadFunctions uploadFunctions = UploadFunctions(database: database, progress: progress, setter: setter);
DownloadFunctions downloadFunctions = DownloadFunctions(database: database, setter: setter, progress: progress);
Map<String, dynamic> progress = {};
Storage storage = Storage();

void setter(Function fn) {}

Future<void> autoSync() async {
  try {
    await uploadFunctions.getAll(cancelToken: CancelToken());
    await downloadFunctions.getAll(cancelToken: CancelToken());
    await storage.write('lastSync', DateTime.now().toString());
  } catch (e) {
    rethrow;
  }
}

// register auto sync function

void registerAutoSync() async {
  try {
    autoSync();
    Timer(const Duration(minutes: 15), () {
      registerAutoSync();
    });
  } catch (e) {
    rethrow;
  }
}
