import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectAccountProvider = Provider.family<int, int>((ref, accountId) {
  return accountId;
});
