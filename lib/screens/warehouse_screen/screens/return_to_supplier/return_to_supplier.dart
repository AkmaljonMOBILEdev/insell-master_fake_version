import 'package:easy_sell/screens/warehouse_screen/screens/return_to_supplier/widgets/create_return.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/return_to_supplier/widgets/returns_list.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/app_bar.dart';

class ReturnToSupplierScreen extends StatefulWidget {
  const ReturnToSupplierScreen({Key? key}) : super(key: key);

  @override
  State<ReturnToSupplierScreen> createState() => _ReturnToSupplierScreenState();
}

class _ReturnToSupplierScreenState extends State<ReturnToSupplierScreen> {
  bool loading = false;
  int offset = 0;
  int limit = 50;
  int total = 0;
  Storage storage = Storage();
  bool _isCashier = false;
  bool updated = false;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  void _getUserRole() async {
    var userRole = await storage.read('role');
    if (userRole == 'amikoCashier') {
      setState(() {
        _isCashier = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBarWidget(
          onTapBack: () => Get.back(),
          centerTitle: false,
          backgroundColor: Colors.black12,
          title: Text('Taminotchiga Vazvrat', style: TextStyle(color: AppColors.appColorWhite)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF26525f), Color(0xFF0f2228)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReturnedProductsList(updated: updated),
            const SizedBox(width: 20),
            ReturnProductRightContainers(
              getAll: () {
                setState(() {
                  updated = true;
                });
              },
              isCashier: _isCashier,
            )
          ],
        ),
      ),
    );
  }
}
