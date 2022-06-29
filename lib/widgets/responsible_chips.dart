import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/providers/last_responsible_selected_provider.dart';
import 'package:monster_finances/providers/responsible_list_provider.dart';
import 'package:monster_finances/widgets/custom_chips_input.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';

class ResponsibleChips extends HookConsumerWidget {
  const ResponsibleChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AccountResponsible>> responsibleList =
        ref.watch(responsibleListProvider);
    final AsyncValue<AccountResponsible?> lastResponsibleSelected =
        ref.watch(lastResponsibleSelectedProvider);

    _buildField(List<AccountResponsible> responsibleList) {
      return CustomChipsInput(
        name: 'responsible',
        initialValue: responsibleList,
        decoration: const InputDecoration(
          labelText: "Responsible",
          icon: Icon(null),
        ),
        onChanged: (data) {
          debugPrint('onChanged');
          debugPrint(data.toString());
        },
        addChip: (String enteredText) {
          AccountResponsible newObj = AccountResponsible(name: enteredText);
          ref.read(responsibleListNotifierProvider.notifier).add(ref, newObj);
          return newObj;
        },
        chipBuilder: (context, state, AccountResponsible responsible) {
          return InputChip(
            key: ObjectKey(responsible.id),
            label: Text(responsible.name),
            selected: lastResponsibleSelected.valueOrNull?.id == responsible.id,
            onSelected: (bool selected) {
              ref
                  .read(lastResponsibleSelectedNotifierProvider.notifier)
                  .update(responsible);
            },
            onDeleted: () {
              ref
                  .read(responsibleListNotifierProvider.notifier)
                  .remove(ref, responsible);
              state.deleteChip(responsible);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      );
    }

    return responsibleList.when(
      data: (data) => _buildField(data),
      error: (e, st) => ErrorIndicator(
        key: const Key('error_responsible_list'),
        error: e,
      ),
      loading: () => const ProgressIndicator(
        key: Key('loading_responsible_list'),
      ),
    );
  }
}
