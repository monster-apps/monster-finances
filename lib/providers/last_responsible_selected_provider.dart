import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';

final FutureProvider<AccountResponsible?> lastResponsibleSelectedProvider =
    FutureProvider((ref) async {
  final lastResponsibleSelected =
      ref.watch(lastResponsibleSelectedNotifierProvider);
  return lastResponsibleSelected;
});

final StateNotifierProvider<LastResponsibleSelectedNotifier,
        AccountResponsible?> lastResponsibleSelectedNotifierProvider =
    StateNotifierProvider<LastResponsibleSelectedNotifier, AccountResponsible?>(
        (ref) {
  return LastResponsibleSelectedNotifier();
});

class LastResponsibleSelectedNotifier
    extends StateNotifier<AccountResponsible?> {
  LastResponsibleSelectedNotifier() : super(null);

  void update(AccountResponsible responsible) {
    state = null;
    state = responsible;
  }
}
