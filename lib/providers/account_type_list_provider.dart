import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/providers/account_type_query_provider.dart';

final FutureProvider<List<AccountType>> accountTypeListProvider =
    FutureProvider((ref) async {
  final accountTypeList = ref.watch(accountTypeListNotifierProvider);
  return accountTypeList;
});

final StateNotifierProvider<AccountTypeListNotifier, List<AccountType>>
    accountTypeListNotifierProvider =
    StateNotifierProvider<AccountTypeListNotifier, List<AccountType>>((ref) {
  return AccountTypeListNotifier(ref);
});

class AccountTypeListNotifier extends StateNotifier<List<AccountType>> {
  AccountTypeListNotifier(ref)
      : super(ref.read(accountTypeQueryProvider).getAllTypes());

  void add(ref, AccountType accountType) async {
    ref.read(accountTypeQueryProvider).put(accountType);
    state = ref.read(accountTypeQueryProvider).getAllTypes();
  }

  void remove(ref, AccountType accountType) async {
    ref.read(accountTypeQueryProvider).remove(accountType);
    state.remove(accountType);
    state = [...state];
  }
}
