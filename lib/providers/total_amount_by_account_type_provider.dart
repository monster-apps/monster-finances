import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/providers/account_query_provider.dart';

final totalAmountByAccountTypeProvider =
    Provider.family<double, int>((ref, accountTypeId) {
  return ref
      .read(accountQueryProvider)
      .getTotalValueByAccountType(accountTypeId);
});
