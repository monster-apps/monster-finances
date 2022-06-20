import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/providers/account_query_provider.dart';

final totalAmountProvider = Provider((ref) {
  return ref.read(accountQueryProvider).getTotalValue();
});
