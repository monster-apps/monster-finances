import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/utils/initial_data/account_type_data.dart';
import 'package:monster_finances/utils/initial_data/category_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/account_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/account_responsible_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/transaction_data.dart';

class InitialData {
  void createInitialData(
    Store store,
    Box<AccountType> accountTypes,
    Box<Category> categories,
  ) {
    _createManyIfEmpty(
      store,
      initialAccountTypes,
      accountTypes,
    );

    _createManyIfEmpty(
      store,
      initialCategories,
      categories,
    );
  }

  void createDevelopmentData(
    Store store,
    Box<Account> accounts,
    Box<AccountResponsible> accountResponsible,
    Box<Transaction> transactions,
  ) async {
    // accounts.removeAll();
    // accountResponsible.removeAll();
    // transactions.removeAll();

    bool accountsCreated = await _createManyIfEmpty(
      store,
      devAccounts,
      accounts,
    );

    await _createManyIfEmpty(
      store,
      devAccountResponsible,
      accountResponsible,
    );

    bool transactionsCreated = await _createManyIfEmpty(
      store,
      devTransactions,
      transactions,
    );

    // create relations
    List<Account> accountList = accounts.getAll();
    if (accountsCreated) {
      for (var account in accountList) {
        Query<AccountType> accountTypeQuery =
            store.box<AccountType>().query().build();
        AccountType? accountType = accountTypeQuery.findFirst();
        accountTypeQuery.close();
        account.type.target = accountType!;

        store.box<Account>().put(account);
      }
    }

    if (transactionsCreated) {
      List<Transaction> transactionsList = transactions.getAll();
      List<AccountResponsible> responsibleList = accountResponsible.getAll();
      AccountResponsible firstResponsible = responsibleList.first;
      Account firstAccount = accountList.first;
      for (var transaction in transactionsList) {
        transaction.account.target = firstAccount;
        transaction.responsible.target = firstResponsible;
        store.box<Transaction>().put(transaction);
      }
    }
  }

  Future<bool> _createManyIfEmpty<T>(
    Store store,
    List<T> initialData,
    Box<T> box,
  ) async {
    if (box.isEmpty()) {
      await store.runInTransactionAsync(
        TxMode.write,
        (Store store, List<T> data) {
          store.box<T>().putMany(data);
        },
        initialData,
      );
      return true;
    }
    return false;
  }
}
