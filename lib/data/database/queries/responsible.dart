import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/providers/database_provider.dart';

class ResponsibleQuery {
  final ProviderRef ref;

  ResponsibleQuery(this.ref);

  List<AccountResponsible> getAllResponsible() {
    return ref.read(databaseProvider).accountResponsible.getAll();
  }

  int put(AccountResponsible responsible) {
    return ref.read(databaseProvider).accountResponsible.put(responsible);
  }

  void remove(AccountResponsible responsible) {
    ref.read(databaseProvider).accountResponsible.remove(responsible.id);
  }

  AccountResponsible? getById(int responsibleId) {
    return ref.read(databaseProvider).accountResponsible.get(responsibleId);
  }
}
