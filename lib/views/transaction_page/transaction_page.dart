import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/providers/account_transaction_list_provider.dart';
import 'package:monster_finances/providers/category_list_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/providers/last_responsible_selected_provider.dart';
import 'package:monster_finances/providers/tags_selected_provider.dart';
import 'package:monster_finances/providers/transaction_query_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:monster_finances/widgets/custom_app_bar.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';
import 'package:monster_finances/widgets/responsible_chips.dart';
import 'package:monster_finances/widgets/tags.dart';
import 'package:vrouter/vrouter.dart';

import '../../data/database/entities/transaction.dart';

class TransactionPage extends HookConsumerWidget {
  TransactionPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  _buildFormFields(
      context, List<Category> categories, Transaction? transaction) {
    return [
      FormBuilderTextField(
        name: 'value',
        textInputAction: TextInputAction.next,
        initialValue: transaction?.value.toString(),
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
        textInputAction: TextInputAction.next,
        initialValue: transaction?.description,
        decoration: const InputDecoration(
          labelText: 'Description',
          icon: Icon(null),
        ),
      ),
      FormBuilderDateTimePicker(
        name: 'date',
        textInputAction: TextInputAction.next,
        initialValue: transaction != null ? transaction.date : DateTime.now(),
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: 'Transaction Date',
          icon: Icon(null),
        ),
      ),
      FormBuilderDropdown(
        name: 'category',
        initialValue: transaction?.category.targetId,
        decoration: InputDecoration(
          labelText: 'Category',
          icon: const Icon(null),
          hintText: 'Select category',
          suffix: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _formKey.currentState!.fields['category']?.reset();
            },
          ),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        items: categories
            .map((category) => DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ))
            .toList(),
      ),
      const ResponsibleChips(),
      FormBuilderTextField(
        name: 'notes',
        initialValue: transaction?.notes,
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
    final Transaction? currentTransaction =
        ref.watch(currentTransactionProvider);
    final Account? currentAccount = ref.watch(currentAccountProvider);

    final AsyncValue<List<Category>> categoryList =
        ref.watch(categoryListProvider);
    final AsyncValue<List<Tag>> selectedTags = ref.watch(tagsSelectedProvider);
    final AsyncValue<AccountResponsible?> lastResponsibleSelected =
        ref.watch(lastResponsibleSelectedProvider);

    deleteButton() {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
          ),
          onPressed: () {
            ref
                .read(accountTransactionListNotifierProvider.notifier)
                .delete(ref, currentTransaction!);
            VRouter.of(context).pop();
          },
          label: const Text(
            'Delete Transaction',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    mainBody(List<Category> categories) {
      return SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.only(bottom: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _buildFormFields(
                    context,
                    categories,
                    currentTransaction,
                  ),
                ),
              ),
            ),
            if (currentTransaction != null) deleteButton()
          ],
        ),
      );
    }

    buildWithBody(Widget body) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Transaction'),
        body: SafeArea(
          child: body,
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'create-edit-transaction',
          onPressed: () async {
            debugPrint("save form");
            if (_formKey.currentState!.saveAndValidate()) {
              debugPrint(_formKey.currentState!.value.toString());
              final formValue = _formKey.currentState!.value;
              Transaction transaction = Transaction(
                id: currentTransaction != null ? currentTransaction.id : 0,
                value: double.parse(formValue['value']),
                description: formValue['description'] ?? '',
                date: formValue['date'],
                notes: formValue['notes'],
              );
              transaction.account.target = currentAccount;
              if (selectedTags.valueOrNull != null) {
                transaction.tags.addAll(selectedTags.valueOrNull!);
              }
              if (lastResponsibleSelected.valueOrNull != null) {
                transaction.responsible.target =
                    lastResponsibleSelected.valueOrNull!;
              }
              if (formValue['category'] != null) {
                transaction.category.targetId = formValue['category'];
              }

              final InitializedVRouterSailor router = VRouter.of(context);
              final ScaffoldMessengerState messenger =
                  ScaffoldMessenger.of(context);
              bool isLargeScreen = ScreenUtil().isLargeScreen(context);

              int transactionId = await ref
                  .read(accountTransactionListNotifierProvider.notifier)
                  .add(ref, transaction);

              router.pop();
              if (isLargeScreen) {
                Transaction? transaction =
                    ref.read(transactionQueryProvider).getById(transactionId);
                ref
                    .read(currentTransactionProvider.notifier)
                    .update(transaction);
                router.toSegments([
                  'accounts',
                  currentAccount!.id.toString(),
                  'transactions',
                  transactionId.toString()
                ]);
              }

              ref.read(tagsSelectedNotifierProvider.notifier).reset();

              const snackBar = SnackBar(
                content: Text('Transaction saved successfully.'),
              );
              messenger.showSnackBar(snackBar);
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
