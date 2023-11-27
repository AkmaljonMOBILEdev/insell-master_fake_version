import 'package:easy_sell/screens/finance_screen/finance_screen.dart';
import 'package:easy_sell/screens/finance_screen/outgoings_screen/widgets/outgoings_screens/pay_to_another_cash_screen.dart';
import 'package:easy_sell/screens/finance_screen/outgoings_screen/widgets/outgoings_screens/pay_to_supplier_screen.dart';
import 'package:easy_sell/screens/login_screen/login_screen.dart';
import 'package:easy_sell/screens/money_send_screen/money_send_screen.dart';
import 'package:easy_sell/screens/prices_screen/prices_screen.dart';
import 'package:easy_sell/screens/season_screen/season_screen.dart';
import 'package:easy_sell/screens/sell_screen/screens/trade_history_screen/trade_history_screen.dart';
import 'package:easy_sell/screens/transfer_product_screen/transfer_product_screen.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_expenses/product_expenses_screen.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_screen/product_screen.dart';
import 'package:easy_sell/screens/settings_screen/settings_screen.dart';
import 'package:easy_sell/screens/splash_screen/splash_screen.dart';
import 'package:easy_sell/screens/supplier_screen/supplier_screen.dart';
import 'package:easy_sell/screens/sync_screen/sync_screen.dart';
import 'package:easy_sell/screens/warehouse_screen/warehouse_screen.dart';
import 'package:easy_sell/utils/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../screens/admin_panel_screen/admin_panel_screen.dart';
import '../screens/category_screen/category_screen.dart';
import '../screens/client_screen/client_screen.dart';
import '../screens/currency_screen/currency_screen.dart';
import '../screens/finance_screen/outgoings_screen/widgets/outgoings_screens/pay_give_to_counterparty_screen.dart';
import '../screens/finance_screen/outgoings_screen/widgets/outgoings_screens/pay_to_organization_screen.dart';
import '../screens/finance_screen/outgoings_screen/widgets/outgoings_screens/pay_to_other_consumption.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/money_send_screen/screens/money_send_history_screen/money_send_history_screen.dart';
import '../screens/partner_screen/partner_screen.dart';
import '../screens/prices_screen/screens/price_settings_screen/price_settings_screen.dart';
import '../screens/report_screen/report_screen.dart';
import '../screens/sell_screen/sell_screen.dart';
import '../screens/settings_screen/screens/cashback_settings_screen/cashback_settings_screen.dart';
import '../screens/warehouse_screen/screens/box_screen/warehouse_add_box_screen.dart';
import '../screens/warehouse_screen/screens/history_screen/warehouse_history_screen.dart';

class AppPages {
  AppPages._();

  static const GO_LOGIN = Routes.LOGIN;
  static const GO_HOME = Routes.HOME;
  static const GO_PRODUCT = Routes.PRODUCT;
  static const GO_WAREHOUSE = Routes.WAREHOUSE;
  static const GO_CLIENT = Routes.CLIENT;
  static const GO_IN_OUT_COMES = Routes.FINANCE;
  static const GO_KASSA = Routes.KASSA;
  static const GO_REPORT = Routes.REPORT;
  static const GO_SPLASH = Routes.SPLASH;
  static const GO_WAREHOUSE_HISTORY = Routes.WAREHOUSE_HISTORY;
  static const GO_WAREHOUSE_BOX_ADD = Routes.WAREHOUSE_BOX_ADD;
  static const GO_MOVE_PRODUCT = Routes.MOVE_PRODUCT;
  static const GO_TRADE_HISTORY = Routes.TRADE_HISTORY;
  static const GO_PRICES = Routes.PRICES;
  static const GO_PRODUCT_EXPENSES = Routes.PRODUCT_EXPENSES;
  static const GO_MONEY_SEND = Routes.MONEY_SEND;
  static const GO_MONEY_SEND_HISTORY = Routes.MONEY_SEND_HISTORY;
  static const GO_SEASON = Routes.SEASON;
  static const GO_MONEY_SETTINGS = Routes.MONEY_SETTINGS;
  static const GO_CASHBACK_SETTINGS = Routes.CASHBACK_SETTINGS;
  static const GO_PARTNER = Routes.PARTNER;
  static const GO_PAY_TO_SUPPLIER = Routes.PAY_TO_SUPPLIER;
  static const GO_PAY_TO_ORGANIZATION = Routes.PAY_TO_ORGANIZATION;
  static const GO_PAY_TO_ANOTHER_CASH = Routes.PAY_TO_ANOTHER_CASH;
  static const GO_PAY_TO_COUNTERPARTY_DEBT = Routes.PAY_GIVE_TO_COUNTERPARTY_DEBT;
  static const GO_PAY_TO_OTHER_CONSUMPTION = Routes.PAY_TO_OTHER_CONSUMPTION;
  static const GO_ADMIN_PANEL = Routes.ADMIN_PANEL;
  static const GO_CURRENCY = Routes.CURRENCY;

  static const TEST_2 = Routes.TEST_2;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.PRODUCT,
      page: () => const ProductScreen(),
    ),
    GetPage(
      name: Routes.WAREHOUSE,
      page: () => const WarehouseScreen(),
    ),
    GetPage(
      name: Routes.CLIENT,
      page: () => const ClientScreen(),
    ),
    GetPage(
      name: Routes.FINANCE,
      page: () => const FinanceScreen(),
    ),
    GetPage(
      name: Routes.KASSA,
      page: () => const SellScreen(),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => const ReportScreen(),
    ),
    GetPage(
      name: Routes.SUPPLIER,
      page: () => const SupplierScreen(),
    ),
    GetPage(
      name: Routes.CATEGORY,
      page: () => const CategoryTestScreen(),
    ),
    GetPage(
      name: Routes.SYNC,
      page: () => const SyncScreen(),
    ),
    GetPage(
      name: Routes.WAREHOUSE_HISTORY,
      page: () => const WarehouseHistoryScreen(),
    ),
    GetPage(
      name: Routes.WAREHOUSE_BOX_ADD,
      page: () => const WarehouseAddBoxScreen(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: Routes.MOVE_PRODUCT,
      page: () => const MoveProductScreen(),
    ),
    GetPage(
      name: Routes.TRADE_HISTORY,
      page: () => const TradeHistoryScreen(),
    ),
    GetPage(
      name: Routes.PRICES,
      page: () => const PricesScreen(),
    ),
    GetPage(
      name: Routes.PRODUCT_EXPENSES,
      page: () => const ProductExpensesScreen(),
    ),
    GetPage(
      name: Routes.MONEY_SEND,
      page: () => const MoneySendScreen(),
    ),
    GetPage(
      name: Routes.MONEY_SEND_HISTORY,
      page: () => const MoneySendHistoryScreen(),
    ),
    GetPage(
      name: Routes.SEASON,
      page: () => const SeasonScreen(),
    ),
    GetPage(
      name: Routes.MONEY_SETTINGS,
      page: () => const PriceSettingsScreen(),
    ),
    GetPage(
      name: Routes.CASHBACK_SETTINGS,
      page: () => const CashbackSettingsScreen(),
    ),
    GetPage(
      name: Routes.PARTNER,
      page: () => const PartnerScreen(),
    ),
    GetPage(
      name: Routes.PAY_TO_SUPPLIER,
      page: () => const PayToSupplierScreen(),
    ),
    GetPage(
      name: Routes.PAY_TO_ORGANIZATION,
      page: () => const PayToOrganizationScreen(),
    ),
    GetPage(
      name: Routes.PAY_TO_ANOTHER_CASH,
      page: () => const PayToAnotherCashScreen(),
    ),
    GetPage(
      name: Routes.PAY_GIVE_TO_COUNTERPARTY_DEBT,
      page: () => const PayGiveToCounterpartyScreen(),
    ),
    GetPage(
      name: Routes.PAY_TO_OTHER_CONSUMPTION,
      page: () => PayToOtherConsumptionScreen(),
    ),
    GetPage(
      name:  Routes.ADMIN_PANEL,
      page: () => const AdminPanelScreen(),
    ),
    GetPage(
      name: Routes.CURRENCY,
      page: () => const CurrencyScreen(),
    )
  ];
}
