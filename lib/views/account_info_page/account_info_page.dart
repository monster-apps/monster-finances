import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/providers/account_list_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/last_account_type_selected_provider.dart';
import 'package:monster_finances/providers/last_responsible_selected_provider.dart';
import 'package:monster_finances/widgets/custom_app_bar.dart';
import 'package:monster_finances/widgets/list_chip.dart';
import 'package:monster_finances/widgets/list_input.dart';
import 'package:monster_finances/widgets/responsible_chips.dart';
import 'package:vrouter/vrouter.dart';

class AccountInfoPage extends HookConsumerWidget {
  AccountInfoPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

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
          // implement it
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

  _buildFormFields(context, Account? account) {
    return [
      WidgetInput(
        icon: Icons.person,
        title: "Name",
        initialValue: account?.name ?? '',
        hint: "Enter your account name",
      ),
      WidgetInput(
        title: "Description",
        hint: "Enter the description",
        initialValue: account?.description ?? '',
      ),
      WidgetChip(
        title: "Type",
        initialValue: account?.type.target?.id ?? 0,
      ),
      // TODO: customise ResponsibleChips for transaction and Accounts or change it to dropdown
      const ResponsibleChips(),
      WidgetInput(
        icon: Icons.notes_outlined,
        title: "Notes",
        hint: "Add extra information",
        initialValue: account?.notes ?? '',
        maxLines: 5,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Account? currentAccount = ref.watch(currentAccountProvider);
    final AsyncValue<AccountType?> lastAccountTypeSelected =
        ref.watch(lastAccountTypeSelectedProvider);
    final AsyncValue<AccountResponsible?> lastResponsibleSelected =
        ref.watch(lastResponsibleSelectedProvider);

    mainBody() {
      return SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.only(bottom: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    Column(children: _buildFormFields(context, currentAccount)),
              ),
            ),
            if (currentAccount != null) deleteButton()
          ],
        ),
      );
    }

    buildWithBody(Widget body) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Accounts'),
        body: body,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'create-edit-account',
          onPressed: () async {
            if (_formKey.currentState!.saveAndValidate()) {
              final formValue = _formKey.currentState!.value;
              Account account = Account(
                id: currentAccount != null ? currentAccount.id : 0,
                name: formValue['Name'],
                description: formValue['Description'] ?? '',
                notes: formValue['Notes'],
              );

              if (lastResponsibleSelected.valueOrNull != null) {
                account.responsible.target =
                    lastResponsibleSelected.valueOrNull!;
              }

              if (lastAccountTypeSelected.valueOrNull != null) {
                account.type.target = lastAccountTypeSelected.valueOrNull!;
              }

              final InitializedVRouterSailor router = VRouter.of(context);
              ref.read(accountListNotifierProvider.notifier).add(account);
              router.pop();

              ScaffoldMessenger.of(context);
            }
          },
          label: const Text('Save'),
          icon: const Icon(Icons.save),
        ),
      );
    }

    return buildWithBody(mainBody());
  }
}
