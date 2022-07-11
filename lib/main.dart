import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monster_finances/data/database/store/store.dart';
import 'package:monster_finances/providers/database_provider.dart';
import 'package:monster_finances/utils/screen_util.dart' as app_screen_util;
import 'package:monster_finances/views/account_info_page/account_info_page.dart';
import 'package:monster_finances/views/account_transactions_page/account_transactions_page.dart';
import 'package:monster_finances/views/not_found.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';
import 'package:monster_finances/views/transaction_page/transaction_page.dart';
import 'package:monster_finances/views/wrapper_page.dart';
import 'package:vrouter/vrouter.dart';

late MonsterStore storeBox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  storeBox = await MonsterStore.create();
  await storeBox.addInitialData();
  await storeBox.addDevData();

  initializeDateFormatting('en');

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(storeBox)],
      child: const MediaQuery(
        data: MediaQueryData(),
        child: MonsterApp(),
      ),
    ),
  );
}

class MonsterApp extends StatelessWidget {
  const MonsterApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return VMaterialApp(
          child: VRouter(
            title: 'Monster Finances',
            supportedLocales: const [
              Locale('en'),
            ],
            localizationsDelegates: const [
              FormBuilderLocalizations.delegate,
            ],
            theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                useMaterial3: true),
            transitionDuration: Duration(
              milliseconds:
                  app_screen_util.ScreenUtil().isLargeScreen(context) ? 0 : 300,
            ),
            reverseTransitionDuration: Duration(
              milliseconds:
                  app_screen_util.ScreenUtil().isLargeScreen(context) ? 0 : 300,
            ),
            initialUrl: "/overview",
            routes: [
              VWidget(
                path: '/overview',
                widget: const WrapperPage(AccountsPage()),
                stackedRoutes: [
                  VWidget(
                    path: '/accounts/:account_id',
                    aliases: const ['/accounts/new'],
                    widget: AccountInfoPage(),
                  ),
                  VWidget(
                    path: '/accounts/:account_id/transactions',
                    widget: const WrapperPage(AccountTransactionsPage()),
                    stackedRoutes: [
                      VWidget(
                        path:
                            '/accounts/:account_id/transactions/:transaction_id',
                        aliases: const [
                          '/accounts/:account_id/transactions/new'
                        ],
                        widget: WrapperPage(TransactionPage()),
                      ),
                    ],
                  ),
                ],
              ),
              VWidget(
                path: '/404',
                widget: const NotFoundPage(),
              ),
              VRouteRedirector(path: ':_(.+)', redirectTo: '/404'),
            ],
          ),
        );
      },
    );
  }
}
