import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/queries/accounts.dart';

final totalAmountByAccountProvider =
    Provider.family<double, int>((ref, accountId) {
  return getTotalValueByAccount(accountId);
});
