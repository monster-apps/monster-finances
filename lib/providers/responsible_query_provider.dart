import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/queries/responsible.dart';

final responsibleQueryProvider =
    Provider<ResponsibleQuery>((ref) => ResponsibleQuery(ref));
