import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/utils/initial_data/initial_data.dart';

class MonsterStore {
  late final Store store;

  late final Box<Account> accounts;
  late final Box<AccountResponsible> accountResponsible;
  late final Box<AccountType> accountTypes;
  late final Box<Category> categories;
  late final Box<Tag> tags;
  late final Box<Transaction> transactions;

  MonsterStore._create(this.store) {
    accounts = Box<Account>(store);
    accountResponsible = Box<AccountResponsible>(store);
    accountTypes = Box<AccountType>(store);
    categories = Box<Category>(store);
    tags = Box<Tag>(store);
    transactions = Box<Transaction>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<MonsterStore> create({String? directory}) async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = directory == null
        ? await openStore(macosApplicationGroup: 'monster.finance')
        : await openStore(
            macosApplicationGroup: 'monster.finance',
            directory: directory,
          );
    return MonsterStore._create(store);
  }

  Future<void> addInitialData() async {
    InitialData().createInitialData(
      store,
      accountTypes,
      categories,
    );
  }

  Future<void> addDevData() async {
    InitialData().createDevelopmentData(
      store,
      accounts,
      accountResponsible,
      transactions,
    );
  }
}
