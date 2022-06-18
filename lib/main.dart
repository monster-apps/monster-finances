import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/providers/database_provider.dart';
import 'package:monster_finances/store/store.dart';
import 'package:monster_finances/views/account_info_page/account_info_page.dart';
import 'package:monster_finances/views/account_transactions_page/account_transactions_page.dart';
import 'package:monster_finances/views/not_found.dart';
import 'package:monster_finances/views/overview_page/overview_page.dart';
import 'package:monster_finances/views/transaction_page/transaction_page.dart';
import 'package:vrouter/vrouter.dart';

late MonsterStore storeBox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  storeBox = await MonsterStore.create();
  await storeBox.addInitialData();
  await storeBox.addDevData();

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(storeBox)],
      child: const MonsterApp(),
    ),
  );
}

class MonsterApp extends StatelessWidget {
  const MonsterApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return VRouter(
        title: 'Monster Finances',
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
        initialUrl: "/overview",
        routes: [
          VWidget(
            path: '/overview',
            widget: const OverviewPage(),
            stackedRoutes: [
              VWidget(
                path: '/accounts/:account_id',
                aliases: const ['/accounts/new'],
                widget: const AccountInfoPage(),
              ),
              VWidget(
                  path: '/accounts/:account_id/transactions',
                  widget: const AccountTransactionsPage(),
                  stackedRoutes: [
                    VWidget(
                      path:
                          '/accounts/:account_id/transactions/:transaction_id',
                      aliases: const ['/accounts/:account_id/transactions/new'],
                      widget: const TransactionPage(),
                    ),
                  ]),
            ],
          ),
          VWidget(
            path: '/404',
            widget: const NotFoundPage(),
          ),
          VRouteRedirector(path: ':_(.+)', redirectTo: '/404'),
        ]);
  }
}
