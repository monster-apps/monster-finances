import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/queries/tags.dart';

final tagQueryProvider = Provider<TagQuery>((ref) => TagQuery(ref));
