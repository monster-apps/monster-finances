import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/tag.dart';

final FutureProvider<List<Tag>> tagsSelectedProvider =
    FutureProvider((ref) async {
  final selectedTags = ref.watch(tagsSelectedNotifierProvider);
  return selectedTags;
});

final StateNotifierProvider<TagsSelectedNotifier, List<Tag>>
    tagsSelectedNotifierProvider =
    StateNotifierProvider<TagsSelectedNotifier, List<Tag>>((ref) {
  return TagsSelectedNotifier();
});

class TagsSelectedNotifier extends StateNotifier<List<Tag>> {
  TagsSelectedNotifier() : super(const []);

  void reset() {
    state = const [];
  }

  void toggle(Tag tag) {
    if (state.contains(tag)) {
      state.remove(tag);
      state = [...state];
    } else {
      state = [...state, tag];
    }
  }
}
