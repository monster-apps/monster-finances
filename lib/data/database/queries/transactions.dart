import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/database_provider.dart';

class TransactionQuery {
  final ProviderRef ref;

  TransactionQuery(this.ref);

  List<Transaction> getAllTransactions() {
    return ref.read(databaseProvider).transactions.getAll();
  }

  void put(Transaction transaction) {
    ref.read(databaseProvider).transactions.put(transaction);
  }
}
