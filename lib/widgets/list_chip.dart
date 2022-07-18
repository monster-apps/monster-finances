import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/providers/account_type_list_provider.dart';
import 'package:monster_finances/providers/last_account_type_selected_provider.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';

class WidgetChip extends HookConsumerWidget {
  const WidgetChip({
    Key? key,
    this.icon,
    this.initialValue,
    required this.title,
  }) : super(key: key);

  final IconData? icon;
  final String title;
  final int? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AccountType>> accountTypeList =
        ref.watch(accountTypeListProvider);

    _buildFields(List<AccountType> accountTypeList) {
      List<FormBuilderChipOption<int>> accountTypeOptions = accountTypeList
          .map((e) =>
              FormBuilderChipOption<int>(value: e.id, child: Text(e.name)))
          .toList();

      return FormBuilderChoiceChip<int>(
        name: title,
        initialValue: initialValue,
        selectedColor: Colors.blue,
        onChanged: (data) {
          AccountType accountType =
              accountTypeList.firstWhere((e) => e.id == data);
          ref
              .read(lastAccountTypeSelectedNotifierProvider.notifier)
              .update(accountType);
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: 'Select an option',
        ),
        options: accountTypeOptions,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      );
    }

    return accountTypeList.when(
      data: (data) => _buildFields(data),
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
