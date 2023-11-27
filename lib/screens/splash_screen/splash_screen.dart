import 'dart:ui';

import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import '../../constants/colors.dart';
import '../../generated/assets.dart';
import '../../utils/listeners.dart';
import '../../utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loading = false;
  final WindowListener _windowListener = WindowsListener();
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    _checkToken();
    windowManager.addListener(_windowListener);
    _init();
  }

  void _checkToken() async {
    setState(() {
      loading = true;
    });
    try {
      var res = await HttpServices.get('/user/get-me');
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      setState(() {
        loading = false;
      });
      if (res.statusCode == 200) {
        storage.write('user', res.body);
      }
      Get.toNamed(
        res.statusCode == 200 ? Routes.HOME : Routes.LOGIN,
      );
    } catch (e) {
      Get.toNamed(Routes.HOME);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(_windowListener);
    super.dispose();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesLoginBg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.dstOver),
          ),
        ),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Center(
                child: loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('In',
                                  style: TextStyle(
                                      color: AppColors.appColorWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 90,
                                      letterSpacing: 4)),
                              Text(
                                'Sell',
                                style: TextStyle(
                                    color: AppColors.appColorGreen300,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 90,
                                    letterSpacing: 4),
                              ),
                            ],
                          ),
                          SizedBox(width: 210, child: LinearProgressIndicator(color: AppColors.appColorGreen300))
                        ],
                      )
                    : const SizedBox())),
      ),
    );
  }
}
