import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/queries/types.dart';

final accountTypeQueryProvider =
    Provider<AccountTypeQuery>((ref) => AccountTypeQuery(ref));
