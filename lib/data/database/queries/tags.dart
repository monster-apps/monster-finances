import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/providers/database_provider.dart';

class TagQuery {
  final ProviderRef ref;

  TagQuery(this.ref);

  List<Tag> getAllTags() {
    return ref.read(databaseProvider).tags.getAll();
  }

  void put(Tag tag) {
    ref.read(databaseProvider).tags.put(tag);
  }
}
