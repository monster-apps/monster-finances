import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/transaction_query_provider.dart';

final FutureProvider<List<Transaction>> accountTransactionListProvider =
    FutureProvider((ref) async {
  final transactionList = ref.watch(accountTransactionListNotifierProvider);
  return transactionList;
});

final StateNotifierProvider<AccountTransactionListNotifier, List<Transaction>>
    accountTransactionListNotifierProvider =
    StateNotifierProvider<AccountTransactionListNotifier, List<Transaction>>(
        (ref) {
  return AccountTransactionListNotifier(ref);
});

class AccountTransactionListNotifier extends StateNotifier<List<Transaction>> {
  AccountTransactionListNotifier(ref)
      : super(ref
            .read(transactionQueryProvider)
            .getAccountTransactions(ref.watch(currentAccountProvider)));

  void add(ref, Transaction transaction) async {
    ref.read(transactionQueryProvider).put(transaction);
    state = ref
        .read(transactionQueryProvider)
        .getAccountTransactions(ref.watch(currentAccountProvider));
  }
}
