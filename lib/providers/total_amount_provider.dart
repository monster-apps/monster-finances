import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/queries/accounts.dart';

final totalAmountProvider = Provider((ref) {
  return getTotalValue();
});
