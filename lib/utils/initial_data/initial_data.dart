import 'package:monster_finances/entities/account_type.dart';
import 'package:monster_finances/entities/category.dart';
import 'package:monster_finances/entities/currency.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:monster_finances/utils/initial_data/account_type_data.dart';
import 'package:monster_finances/utils/initial_data/category_data.dart';
import 'package:monster_finances/utils/initial_data/currency_data.dart';

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

  void _createManyIfEmpty<T>(
    Store store,
    List<T> initialData,
    Box<T> box,
  ) {
    if (box.isEmpty()) {
      store.runInTransactionAsync(
        TxMode.write,
        (Store store, List<T> data) {
          store.box<T>().putMany(data);
        },
        initialData,
      );
    }
  }
}
