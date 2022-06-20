import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/providers/database_provider.dart';

class AccountQuery {
  final ProviderRef ref;

  AccountQuery(this.ref);

  List<Account> getAllAccounts() {
    return ref.read(databaseProvider).accounts.getAll();
  }

  double getTotalValueByAccountType(int accountTypeId) {
    List<Account> accounts = ref
        .read(databaseProvider)
        .accounts
        .query(Account_.type.equals(accountTypeId))
        .build()
        .find();

    List<int> transactionIds = [];
    for (var account in accounts) {
      transactionIds += account.transactions.map((e) => e.id).toList();
    }
    return ref
        .read(databaseProvider)
        .transactions
        .query(Transaction_.id.oneOf(transactionIds))
        .build()
        .property(Transaction_.value)
        .sum();
  }

  double getTotalValueByAccount(int accountId) {
    return ref
        .read(databaseProvider)
        .transactions
        .query(Transaction_.account.equals(accountId))
        .build()
        .property(Transaction_.value)
        .sum();
  }

  double getTotalValue() {
    return ref
        .read(databaseProvider)
        .transactions
        .query()
        .build()
        .property(Transaction_.value)
        .sum();
  }
}
