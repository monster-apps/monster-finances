import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/queries/accounts.dart';

final accountQueryProvider = Provider<AccountQuery>((ref) => AccountQuery(ref));
