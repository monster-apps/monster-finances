import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/providers/is_creating_new_transaction_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:monster_finances/views/account_transactions_page/account_transactions_page.dart';
import 'package:monster_finances/views/empty_page.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';
import 'package:monster_finances/views/transaction_page/transaction_page.dart';

class WrapperPage extends HookConsumerWidget {
  final Widget page;

  const WrapperPage(this.page, {Key? key}) : super(key: key);

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
      final Account? currentAccount = ref.watch(currentAccountProvider);
      final Transaction? currentTransaction =
          ref.watch(currentTransactionProvider);
      final bool isCreatingNewTransaction =
          ref.watch(isCreatingNewTransactionProvider);

      return Scaffold(
        body: Row(
          children: [
            ...buildBox(const AccountsPage(), width: 280.0),
            if (currentAccount != null)
              ...buildBox(const AccountTransactionsPage(), width: 320.0),
            Expanded(
              child: currentTransaction != null || isCreatingNewTransaction
                  ? TransactionPage()
                  : const EmptyPage(),
            ),
          ],
        ),
      );
    }

    if (ScreenUtil().isLargeScreen(context)) {
      return buildLargerScreen();
    }

    return page;
  }
}
