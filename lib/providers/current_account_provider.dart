import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentAccountProvider =
    StateNotifierProvider<CurrentAccountNotifier, int>((ref) {
  return CurrentAccountNotifier();
});

class CurrentAccountNotifier extends StateNotifier<int> {
  CurrentAccountNotifier() : super(0);

  void update(int accountId) => state = accountId;
}
