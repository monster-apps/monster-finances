import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/providers/tag_query_provider.dart';

final FutureProvider<List<Tag>> tagListProvider = FutureProvider((ref) async {
  final tagList = ref.watch(tagListNotifierProvider);
  return tagList;
});

final StateNotifierProvider<TagListNotifier, List<Tag>>
    tagListNotifierProvider =
    StateNotifierProvider<TagListNotifier, List<Tag>>((ref) {
  return TagListNotifier(ref);
});

class TagListNotifier extends StateNotifier<List<Tag>> {
  TagListNotifier(ref) : super(ref.read(tagQueryProvider).getAllTags());

  void add(ref, Tag tag) async {
    ref.read(tagQueryProvider).put(tag);
    state = ref.read(tagQueryProvider).getAllTags();
  }

  void remove(ref, Tag tag) async {
    ref.read(tagQueryProvider).remove(tag);
    state.remove(tag);
    state = [...state];
  }
}
