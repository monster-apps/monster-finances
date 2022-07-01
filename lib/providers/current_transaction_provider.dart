import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';

final currentTransactionProvider =
    StateNotifierProvider<CurrentTransactionNotifier, Transaction?>((ref) {
  return CurrentTransactionNotifier();
});

class CurrentTransactionNotifier extends StateNotifier<Transaction?> {
  CurrentTransactionNotifier() : super(null);

  void update(Transaction? transaction) => state = transaction;
}
