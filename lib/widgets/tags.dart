import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/providers/tag_list_provider.dart';
import 'package:monster_finances/providers/tags_selected_provider.dart';
import 'package:monster_finances/widgets/custom_chips_input.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';

class Tags extends HookConsumerWidget {
  const Tags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Tag>> tagList = ref.watch(tagListProvider);
    final AsyncValue<List<Tag>> selectedTags = ref.watch(tagsSelectedProvider);

    _buildField(List<Tag> tagList) {
      return CustomChipsInput(
        name: 'tags',
        initialValue: tagList,
        decoration: const InputDecoration(
          labelText: "Tags",
          icon: Icon(null),
        ),
        onChanged: (data) {
          debugPrint('onChanged');
          debugPrint(data.toString());
        },
        addChip: (String enteredText) {
          Tag newObj = Tag(value: enteredText);
          ref.read(tagListNotifierProvider.notifier).add(ref, newObj);
          return newObj;
        },
        chipBuilder: (context, state, Tag tag) {
          return InputChip(
            key: ObjectKey(tag.id),
            label: Text(tag.value),
            selected: selectedTags.valueOrNull?.contains(tag) ?? false,
            onSelected: (bool selected) {
              ref.read(tagsSelectedNotifierProvider.notifier).toggle(tag);
            },
            // onDeleted: () {
            //   ref.read(tagListNotifierProvider.notifier).remove(ref, tag);
            //   state.deleteChip(tag);
            // },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      );
    }

    return tagList.when(
      data: (data) => _buildField(data),
      error: (e, st) => ErrorIndicator(
        key: const Key('error_tag_list'),
        error: e,
      ),
      loading: () => const ProgressIndicator(
        key: Key('loading_tag_list'),
      ),
    );
  }
}
