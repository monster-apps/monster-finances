import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/providers/tag_list_provider.dart';
import 'package:monster_finances/providers/tags_selected_provider.dart';
import 'package:monster_finances/widgets/custom_chips_input.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';

class Tags extends HookConsumerWidget {
  const Tags({Key? key}) : super(key: key);
  static const String deleteConfirmationKey = "CONFIRMED";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Transaction? currentTransaction =
        ref.watch(currentTransactionProvider);

    final AsyncValue<List<Tag>> tagList = ref.watch(tagListProvider);
    final AsyncValue<List<Tag>> selectedTags = ref.watch(tagsSelectedProvider);

    deleteDialog() {
      return AlertDialog(
        title: const Text('This tag is linked to other transactions'),
        content: const Text(
            'Deleting this tag will delete it for all already linked transactions. Are you sure you want to continue?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, deleteConfirmationKey),
            child: const Text('Delete'),
          ),
        ],
      );
    }

    buildField(List<Tag> tagList) {
      return CustomChipsInput(
        name: 'tags',
        initialValue: tagList,
        decoration: const InputDecoration(
          labelText: "Tags",
          icon: Icon(null),
        ),
        addChip: (String enteredText) {
          Tag newObj = Tag(value: enteredText);
          ref.read(tagListNotifierProvider.notifier).add(ref, newObj);
          return newObj;
        },
        chipBuilder: (context, state, Tag tag) {
          return InputChip(
            key: ObjectKey(tag.id),
            label: Text(tag.value),
            selected: currentTransaction?.tags
                    .any((element) => element.id == tag.id) ??
                false ||
                    (currentTransaction == null &&
                        selectedTags.hasValue &&
                        selectedTags.value!.contains(tag)),
            onSelected: (bool selected) {
              ref.read(tagsSelectedNotifierProvider.notifier).toggle(tag);
            },
            onDeleted: () async {
              var shouldDelete = true;
              if (tag.transactions.isNotEmpty) {
                final result = await showDialog(
                    context: context, builder: (context) => deleteDialog());
                shouldDelete = result == deleteConfirmationKey;
              }

              if (shouldDelete) {
                ref.read(tagListNotifierProvider.notifier).remove(ref, tag);
                state.deleteChip(tag);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      );
    }

    return tagList.when(
      data: (data) => buildField(data),
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
