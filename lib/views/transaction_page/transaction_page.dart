import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/providers/category_list_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/last_responsible_selected_provider.dart';
import 'package:monster_finances/providers/tags_selected_provider.dart';
import 'package:monster_finances/providers/transaction_list_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';
import 'package:monster_finances/widgets/responsible_chips.dart';
import 'package:monster_finances/widgets/tags.dart';
import 'package:vrouter/vrouter.dart';

import '../../data/database/entities/transaction.dart';

class TransactionPage extends HookConsumerWidget {
  TransactionPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  _buildFormFields(context, List<Category> categories) {
    return [
      FormBuilderTextField(
        name: 'value',
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^[-\d]+\.?\d{0,2}')),
        ],
        decoration: const InputDecoration(
          labelText: 'Transaction value',
          icon: Icon(Icons.paid),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
        ]),
      ),
      FormBuilderTextField(
        name: 'description',
        decoration: const InputDecoration(
          labelText: 'Description',
          icon: Icon(null),
        ),
      ),
      FormBuilderDateTimePicker(
        name: 'date',
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: 'Transaction Date',
          icon: Icon(null),
        ),
        initialValue: DateTime.now(),
      ),
      FormBuilderDropdown(
        name: 'category',
        decoration: const InputDecoration(
          labelText: 'Category',
          icon: Icon(null),
        ),
        allowClear: true,
        hint: const Text('Select category'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        items: categories
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                ))
            .toList(),
      ),
      const ResponsibleChips(),
      FormBuilderTextField(
        name: 'notes',
        decoration: const InputDecoration(
          labelText: 'Notes',
          icon: Icon(Icons.notes_outlined),
          hintText: 'Add extra information',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true,
        ),
        maxLines: 5,
      ),
      const Tags()
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Category>> categoryList =
        ref.watch(categoryListProvider);
    final int currentAccountId = ref.watch(currentAccountProvider);
    final AsyncValue<List<Tag>> selectedTags = ref.watch(tagsSelectedProvider);
    final AsyncValue<AccountResponsible?> lastResponsibleSelected =
        ref.watch(lastResponsibleSelectedProvider);

    mainBody(List<Category> categories) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64.0),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: _buildFormFields(context, categories),
              ),
            ),
          ),
        ),
      );
    }

    buildWithBody(Widget body) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Transaction'),
        ),
        body: body,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'create-edit-transaction',
          onPressed: () {
            debugPrint("save form");
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              debugPrint(_formKey.currentState!.value.toString());
              final formValue = _formKey.currentState!.value;
              Transaction transaction = Transaction(
                value: double.parse(formValue['value']),
                description: formValue['description'] ?? '',
                date: formValue['date'],
                notes: formValue['notes'],
              );
              transaction.account.targetId = currentAccountId;
              if (selectedTags.valueOrNull != null) {
                transaction.tags.addAll(selectedTags.valueOrNull!);
              }
              if (lastResponsibleSelected.valueOrNull != null) {
                transaction.responsible.target =
                    lastResponsibleSelected.valueOrNull!;
              }
              ref
                  .read(transactionListNotifierProvider.notifier)
                  .add(ref, transaction);

              if (!ScreenUtil().isLargeScreen(context)) {
                VRouter.of(context).pop();
              }

              const snackBar = SnackBar(
                content: Text('Transaction saved successfully.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              debugPrint("validation failed");
              const snackBar = SnackBar(
                content: Text('We could\'t save this transaction. '
                    'Please, fix the issues and try again.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          label: const Text('Save'),
          icon: const Icon(Icons.save),
        ),
      );
    }

    // TODO: replace this with the when of loading current transaction obj
    return categoryList.when(
      data: (data) => buildWithBody(mainBody(data)),
      error: (e, st) => buildWithBody(
        ErrorIndicator(
          key: const Key('error_category_list'),
          error: e,
        ),
      ),
      loading: () => buildWithBody(
        const ProgressIndicator(key: Key('loading_category_list')),
      ),
    );
  }
}
