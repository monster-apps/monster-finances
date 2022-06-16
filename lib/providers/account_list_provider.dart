import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/main.dart';
import 'package:monster_finances/queries/accounts.dart';

final FutureProvider<List<Account>> accountListProvider =
    FutureProvider((ref) async {
  final accountList = ref.watch(accountListNotifierProvider);
  return accountList;
});

final StateNotifierProvider<AccountListNotifier, List<Account>>
    accountListNotifierProvider =
    StateNotifierProvider<AccountListNotifier, List<Account>>((ref) {
  return AccountListNotifier();
});

class AccountListNotifier extends StateNotifier<List<Account>> {
  AccountListNotifier() : super(AccountQuery().getAllAccounts());

  void add(Account account) async {
    storeBox.accounts.put(account);
    state = [...state, account];
  }
}
