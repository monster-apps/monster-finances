import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/entities/account_responsible.dart';
import 'package:monster_finances/entities/account_type.dart';
import 'package:monster_finances/entities/category.dart';
import 'package:monster_finances/entities/currency.dart';
import 'package:monster_finances/entities/transaction.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/utils/initial_data/account_type_data.dart';
import 'package:monster_finances/utils/initial_data/category_data.dart';
import 'package:monster_finances/utils/initial_data/currency_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/account_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/account_responsible_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/transaction_data.dart';

class InitialData {
  void createInitialData(
    Store store,
    Box<AccountType> accountTypes,
    Box<Category> categories,
    Box<Currency> currencies,
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

    _createManyIfEmpty(
      store,
      initialCurrencies,
      currencies,
    );
  }

  void createDevelopmentData(
    Store store,
    Box<Account> accounts,
    Box<AccountResponsible> accountResponsible,
    Box<Transaction> transactions,
  ) async {
    bool accountsCreated = await _createManyIfEmpty(
      store,
      devAccounts,
      accounts,
    );

    bool responsibleCreated = await _createManyIfEmpty(
      store,
      devAccountResponsible,
      accountResponsible,
    );

    _createManyIfEmpty(
      store,
      devTransactions,
      transactions,
    );

    // create relations
    // create account-responsible relations
    if (responsibleCreated) {
      AccountResponsible? responsible = accountResponsible.get(0);
      responsible?.accounts.addAll(accounts.getAll());
    }

    // create account-transactions relation
    if (accountsCreated) {
      Account? account = accounts.get(0);
      account?.transactions.addAll(transactions.getAll());
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
