import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/queries/accounts.dart';

final totalAmountByAccountTypeProvider =
    Provider.family<double, int>((ref, accountTypeId) {
  return getTotalValueByAccountType(accountTypeId);
});
