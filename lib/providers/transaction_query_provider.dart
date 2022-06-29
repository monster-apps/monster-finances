import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/queries/transactions.dart';

final transactionQueryProvider =
    Provider<TransactionQuery>((ref) => TransactionQuery(ref));
