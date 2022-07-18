import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';

final FutureProvider<AccountType?> lastAccountTypeSelectedProvider =
    FutureProvider((ref) async {
  final lastAccountTypeSelected =
      ref.watch(lastAccountTypeSelectedNotifierProvider);
  return lastAccountTypeSelected;
});

final StateNotifierProvider<LastAccountTypeSelectedNotifier, AccountType?>
    lastAccountTypeSelectedNotifierProvider =
    StateNotifierProvider<LastAccountTypeSelectedNotifier, AccountType?>((ref) {
  return LastAccountTypeSelectedNotifier();
});

class LastAccountTypeSelectedNotifier extends StateNotifier<AccountType?> {
  LastAccountTypeSelectedNotifier() : super(null);

  void update(AccountType type) {
    state = null;
    state = type;
  }
}
