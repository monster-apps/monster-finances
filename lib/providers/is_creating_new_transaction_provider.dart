import 'package:hooks_riverpod/hooks_riverpod.dart';

final isCreatingNewTransactionProvider =
    StateNotifierProvider<IsCreatingNewTransactionNotifier, bool>((ref) {
  return IsCreatingNewTransactionNotifier();
});

class IsCreatingNewTransactionNotifier extends StateNotifier<bool> {
  IsCreatingNewTransactionNotifier() : super(false);

  void update(bool isCreatingNewTransaction) =>
      state = isCreatingNewTransaction;
}
