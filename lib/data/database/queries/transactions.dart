import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/providers/database_provider.dart';

class TransactionQuery {
  final ProviderRef ref;

  TransactionQuery(this.ref);

  List<Transaction> getAllTransactions() {
    return ref.read(databaseProvider).transactions.getAll();
  }

  List<Transaction> getAccountTransactions(Account? account) {
    if (account == null) {
      return const [];
    }

    return ref
        .read(databaseProvider)
        .transactions
        .query(Transaction_.account.equals(account.id))
        .build()
        .find();
  }

  int put(Transaction transaction) {
    return ref.read(databaseProvider).transactions.put(transaction);
  }
}
