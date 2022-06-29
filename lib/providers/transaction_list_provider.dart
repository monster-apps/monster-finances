import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/transaction_query_provider.dart';

final FutureProvider<List<Transaction>> transactionListProvider =
    FutureProvider((ref) async {
  final transactionList = ref.watch(transactionListNotifierProvider);
  return transactionList;
});

final StateNotifierProvider<TransactionListNotifier, List<Transaction>>
    transactionListNotifierProvider =
    StateNotifierProvider<TransactionListNotifier, List<Transaction>>((ref) {
  return TransactionListNotifier(ref);
});

class TransactionListNotifier extends StateNotifier<List<Transaction>> {
  TransactionListNotifier(ref)
      : super(ref.read(transactionQueryProvider).getAllTransactions());

  void add(ref, Transaction transaction) async {
    ref.read(transactionQueryProvider).put(transaction);
    state = [...state, transaction];
  }
}
