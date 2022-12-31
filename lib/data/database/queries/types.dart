import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/providers/database_provider.dart';

class AccountTypeQuery {
  final ProviderRef ref;

  AccountTypeQuery(this.ref);

  List<AccountType> getAllTypes() {
    return ref.read(databaseProvider).accountTypes.getAll();
  }

  int put(AccountType accountType) {
    return ref.read(databaseProvider).accountTypes.put(accountType);
  }

  void remove(AccountType accountType) {
    ref.read(databaseProvider).accountTypes.remove(accountType.id);
  }

  AccountType? getById(int accountTypeId) {
    return ref.read(databaseProvider).accountTypes.get(accountTypeId);
  }
}
