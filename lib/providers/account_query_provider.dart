import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/queries/accounts.dart';

final accountQueryProvider = Provider<AccountQuery>((ref) => AccountQuery(ref));
