import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/providers/last_responsible_selected_provider.dart';
import 'package:monster_finances/providers/responsible_list_provider.dart';
import 'package:monster_finances/widgets/custom_chips_input.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';

class ResponsibleChips extends HookConsumerWidget {
  const ResponsibleChips({Key? key}) : super(key: key);
  static const String deleteConfirmationKey = "CONFIRMED";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Transaction? currentTransaction =
        ref.watch(currentTransactionProvider);

    final AsyncValue<List<AccountResponsible>> responsibleList =
        ref.watch(responsibleListProvider);
    final AsyncValue<AccountResponsible?> lastResponsibleSelected =
        ref.watch(lastResponsibleSelectedProvider);

    deleteDialog() {
      return AlertDialog(
        title: const Text(
            'This responsible is linked to other transactions or accounts'),
        content: const Text(
            'Deleting this responsible will delete it for all linked transactions and accounts. Are you sure you want to continue?'),
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

    buildField(List<AccountResponsible> responsibleList) {
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
            selected: currentTransaction?.responsible.targetId ==
                    responsible.id ||
                (currentTransaction == null &&
                    lastResponsibleSelected.valueOrNull?.id == responsible.id),
            onSelected: (bool selected) {
              ref
                  .read(lastResponsibleSelectedNotifierProvider.notifier)
                  .update(responsible);
            },
            onDeleted: () async {
              var shouldDelete = true;
              if (responsible.transactions.isNotEmpty ||
                  responsible.accounts.isNotEmpty) {
                final result = await showDialog(
                    context: context, builder: (context) => deleteDialog());
                shouldDelete = result == deleteConfirmationKey;
              }

              if (shouldDelete) {
                ref
                    .read(responsibleListNotifierProvider.notifier)
                    .remove(ref, responsible);
                state.deleteChip(responsible);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      );
    }

    return responsibleList.when(
      data: (data) => buildField(data),
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
