import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/queries/categories.dart';

final categoryQueryProvider =
    Provider<CategoryQuery>((ref) => CategoryQuery(ref));
