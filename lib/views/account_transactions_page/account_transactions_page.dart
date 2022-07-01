import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/account_transaction_list_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/utils/text_util.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';
import 'package:vrouter/vrouter.dart';

class AccountTransactionsPage extends HookConsumerWidget {
  const AccountTransactionsPage({Key? key}) : super(key: key);

  String buildDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String buildDisplayDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Account? currentAccount = ref.watch(currentAccountProvider);
    final Transaction? currentTransaction =
        ref.watch(currentTransactionProvider);
    final AsyncValue<List<Transaction>> transactions =
        ref.watch(accountTransactionListProvider);

    buildWithBody(Widget body) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('${currentAccount?.name} Transactions'),
        ),
        body: body,
        floatingActionButton: FloatingActionButton(
          heroTag: 'go-to-create-transaction-page',
          onPressed: () {
            VRouter.of(context).toSegments([
              'accounts',
              currentAccount!.id.toString(),
              'transactions',
              'new'
            ]);
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    mainBody(List<Transaction> transactions) {
      return SingleChildScrollView(
        child: Row(children: [
          Expanded(
            child: GroupedListView<Transaction, String>(
              elements: transactions,
              groupBy: (Transaction element) => buildDate(element.date),
              order: GroupedListOrder.DESC,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // itemExtent: 40.0,
              separator: const Divider(),
              groupHeaderBuilder: (Transaction element) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    children: [
                      Text(buildDisplayDate(element.date)),
                    ],
                  ),
                );
              },
              itemBuilder: (BuildContext context, Transaction element) {
                return ListTile(
                  key: Key('transaction-id-${element.id}'),
                  title: Text(element.category.target?.name ?? ''),
                  subtitle: Text(element.description),
                  selected: currentTransaction?.id == element.id,
                  trailing: Text(TextUtil().getFormattedAmount(element.value)),
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 16.0),
                  onTap: () {
                    ref
                        .read(currentTransactionProvider.notifier)
                        .update(element);
                    VRouter.of(context).toSegments([
                      'accounts',
                      currentAccount!.id.toString(),
                      'transactions',
                      element.id.toString()
                    ]);
                  },
                );
              },
            ),
          ),
        ]),
      );
    }

    if (currentAccount == null) {
      return buildWithBody(const Text('No account selected'));
    }

    return transactions.when(
      data: (data) => buildWithBody(mainBody(data)),
      error: (e, st) => buildWithBody(
        ErrorIndicator(
          key: const Key('error_transactions_list'),
          error: e,
        ),
      ),
      loading: () => buildWithBody(
        const ProgressIndicator(key: Key('loading_transactions_list')),
      ),
    );
  }
}
