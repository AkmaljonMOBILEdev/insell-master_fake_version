import 'dart:io';

import 'package:easy_sell/screens/splash_screen/splash_screen.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:easy_sell/utils/pages.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'database/my_database.dart';

void main() async {
  File errorFile = await File('error.txt').create();
  MyDatabase database = MyDatabase();
  Get.put(database);
  Get.put(errorFile);
  await GetStorage.init();
  // setMinWindowSize(const Size(1368, 700));
  setMinWindowSize(const Size(1024, 768));
  // setMaxWindowSize(const Size(1024, 768));
  // setWindowSize(const Size(1360, 768));
  // toggleFullScreen();
  runApp(const MyApp());
  registerAutoSync();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'InSell',
      debugShowCheckedModeBanner: false,
      locale: const Locale('uz'),
      fallbackLocale: const Locale('uz'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
      theme: ThemeData(
        fontFamily: 'EasySell',
        useMaterial3: true,
        primarySwatch: Colors.green,
        scrollbarTheme: const ScrollbarThemeData(
          thumbColor: MaterialStatePropertyAll<Color>(Colors.white30),
          thumbVisibility: MaterialStatePropertyAll(true),
        ),
      ),
      home: const SplashScreen(),
      getPages: AppPages.routes,
    );
  }
}
