import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/entities/account_responsible.dart';
import 'package:monster_finances/entities/account_type.dart';
import 'package:monster_finances/entities/category.dart';
import 'package:monster_finances/entities/currency.dart';
import 'package:monster_finances/entities/tag.dart';
import 'package:monster_finances/entities/transaction.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/utils/initial_data/initial_data.dart';

class MonsterStore {
  late final Store store;

  late final Box<Account> accounts;
  late final Box<AccountResponsible> accountResponsible;
  late final Box<AccountType> accountTypes;
  late final Box<Category> categories;
  late final Box<Currency> currencies;
  late final Box<Tag> tags;
  late final Box<Transaction> transactions;

  MonsterStore._create(this.store) {
    accounts = Box<Account>(store);
    accountResponsible = Box<AccountResponsible>(store);
    accountTypes = Box<AccountType>(store);
    categories = Box<Category>(store);
    currencies = Box<Currency>(store);
    tags = Box<Tag>(store);
    transactions = Box<Transaction>(store);

    InitialData().createInitialData(
      store,
      accountTypes,
      categories,
      currencies,
    );

    InitialData().createDevelopmentData(
      store,
      accounts,
      accountResponsible,
      transactions,
    );
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<MonsterStore> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(macosApplicationGroup: 'monster.finance');
    return MonsterStore._create(store);
  }
}
