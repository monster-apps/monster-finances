import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';

final currentAccountProvider =
    StateNotifierProvider<CurrentAccountNotifier, Account?>((ref) {
  return CurrentAccountNotifier();
});

class CurrentAccountNotifier extends StateNotifier<Account?> {
  CurrentAccountNotifier() : super(null);

  void update(ref, Account account) {
    ref.read(currentTransactionProvider.notifier).update(null);
    state = account;
  }
}
