import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/providers/account_query_provider.dart';

final totalAmountByAccountProvider =
    Provider.family<double, int>((ref, accountId) {
  return ref.read(accountQueryProvider).getTotalValueByAccount(accountId);
});
