import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/utils/validator.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicons/unicons.dart';
import 'package:window_manager/window_manager.dart';
import '../../generated/assets.dart';
import '../../utils/listeners.dart';
import '../../utils/routes.dart';
import '../../widgets/app_input_underline.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GetStorage box = GetStorage();
  bool _showPassword = true;
  bool _forgetPassword = true;
  final WindowListener _windowListener = WindowsListener();
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  Storage storage = Storage();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late DownloadFunctions downloadFunctions;
  MyDatabase database = Get.find<MyDatabase>();

  @override
  void initState() {
    downloadFunctions = DownloadFunctions(database: database, progress: {}, setter: (fn) {});
    windowManager.addListener(_windowListener);
    _init();
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
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
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesLoginBg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.dstOver),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 450,
              height: 500,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(30)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('In',
                            style: TextStyle(
                                color: AppColors.appColorWhite, fontWeight: FontWeight.w600, fontSize: 50, letterSpacing: 3)),
                        Text('Sell',
                            style: TextStyle(
                                color: AppColors.appColorGreen300, fontWeight: FontWeight.w600, fontSize: 50, letterSpacing: 3)),
                      ],
                    ),
                    const SizedBox(height: 50),
                    AppInputUnderline(
                      hintText: 'Login',
                      validator: AppValidator().loginValidate,
                      prefixIcon: UniconsLine.user,
                      controller: _loginController,
                    ),
                    const SizedBox(height: 30),
                    AppInputUnderline(
                      hintText: 'Password',
                      validator: AppValidator().passwordValidate,
                      textHide: _showPassword,
                      prefixIcon: UniconsLine.lock,
                      suffixIcon: showPassword(),
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppButton(
                          tooltip: '',
                          onTap: () {
                            setState(() {
                              _forgetPassword = !_forgetPassword;
                            });
                          },
                          width: 180,
                          height: 40,
                          hoverRadius: BorderRadius.circular(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _forgetPassword
                                  ? Text(
                                      'Parolni unuttingizmi?',
                                      style: TextStyle(
                                          color: AppColors.appColorGrey400,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 1),
                                    )
                                  : Row(
                                      children: [
                                        Icon(UniconsLine.phone_alt, color: AppColors.appColorGrey400, size: 20),
                                        Text(
                                          ' 0611',
                                          style: TextStyle(
                                              color: AppColors.appColorGrey400,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        AppButton(
                          tooltip: '',
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              String username = _loginController.text;
                              String password = _passwordController.text;
                              var res = await HttpServices.post("/user/sign-in", {'username': username, 'password': password});
                              if (res.statusCode == 200) {
                                var json = jsonDecode(res.body);
                                storage.write('token', json['jwt']);
                                storage.write('user', jsonEncode(json['user']));
                                setState(() {
                                  isLoading = false;
                                });
                                Get.toNamed(Routes.HOME);
                              } else {
                                if (context.mounted) {
                                  showAppSnackBar(context, 'Login yoki Parolni xato kiritdingiz', 'OK', isError: true);
                                }
                              }
                            }
                          },
                          width: 180,
                          height: 40,
                          color: AppColors.appColorGreen400,
                          hoverColor: AppColors.appColorGreen300,
                          colorOnClick: AppColors.appColorGreen700,
                          splashColor: AppColors.appColorGreen700,
                          borderRadius: BorderRadius.circular(15),
                          hoverRadius: BorderRadius.circular(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isLoading)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: AppColors.appColorWhite, strokeWidth: 2),
                                ),
                              SizedBox(width: isLoading ? 10 : 0),
                              Text(
                                'Kirish',
                                style: TextStyle(
                                    color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite, size: 18)
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 100)
          ],
        ),
      ),
    );
  }

  Widget showPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _showPassword = !_showPassword;
        });
      },
      icon: _showPassword
          ? Icon(
              UniconsLine.eye,
              color: AppColors.appColorWhite,
            )
          : Icon(
              UniconsLine.eye_slash,
              color: AppColors.appColorWhite,
            ),
    );
  }
}
