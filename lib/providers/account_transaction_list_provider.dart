import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/providers/total_amount_by_account_provider.dart';
import 'package:monster_finances/providers/total_amount_by_account_type_provider.dart';
import 'package:monster_finances/providers/total_amount_provider.dart';
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

  Future<int> add(ref, Transaction transaction) async {
    int transactionId = ref.read(transactionQueryProvider).put(transaction);
    ref.refresh(totalAmountProvider);
    ref.refresh(totalAmountByAccountTypeProvider(
        transaction.account.target!.type.targetId));
    ref.refresh(totalAmountByAccountProvider(transaction.account.targetId));

    state = ref
        .read(transactionQueryProvider)
        .getAccountTransactions(ref.watch(currentAccountProvider));

    return transactionId;
  }

  void delete(ref, Transaction transaction) async {
    ref.read(transactionQueryProvider).delete(transaction.id);
    ref.read(currentTransactionProvider.notifier).update(null);
    ref.refresh(totalAmountProvider);
    ref.refresh(totalAmountByAccountTypeProvider(
        transaction.account.target!.type.targetId));
    ref.refresh(totalAmountByAccountProvider(transaction.account.targetId));

    state = ref
        .read(transactionQueryProvider)
        .getAccountTransactions(ref.watch(currentAccountProvider));
  }
}
