import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/main.dart';
import 'package:monster_finances/objectbox.g.dart';

double getTotalValueByAccountType(int accountTypeId) {
  List<Account> accounts = storeBox.accounts
      .query(Account_.type.equals(accountTypeId))
      .build()
      .find();

  List<int> transactionIds = [];
  for (var account in accounts) {
    transactionIds += account.transactions.map((e) => e.id).toList();
  }
  return storeBox.transactions
      .query(Transaction_.id.oneOf(transactionIds))
      .build()
      .property(Transaction_.value)
      .sum();
}

double getTotalValueByAccount(int accountId) {
  return storeBox.transactions
      .query(Transaction_.account.equals(accountId))
      .build()
      .property(Transaction_.value)
      .sum();
}
