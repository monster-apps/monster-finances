import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:monster_finances/views/account_transactions_page/account_transactions_page.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';

import 'empty_page.dart';

class OverviewPage extends HookConsumerWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    buildBox(Widget widget, {required double width}) {
      return [
        SizedBox(
          width: width,
          child: widget,
        ),
        Container(width: 0.5, color: Colors.grey),
      ];
    }

    buildLargerScreen() {
      final int currentAccountId = ref.watch(currentAccountProvider);
      return Row(
        children: [
          ...buildBox(const AccountsPage(), width: 280.0),
          if (currentAccountId != 0)
            ...buildBox(const AccountTransactionsPage(), width: 320.0),
          const Expanded(
            child: EmptyPage(),
          ),
        ],
      );
    }

    if (ScreenUtil().isLargeScreen(context)) {
      return buildLargerScreen();
    }

    return const AccountsPage();
  }
}
