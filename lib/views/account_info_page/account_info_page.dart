import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/widgets/list_chip.dart';
import 'package:monster_finances/widgets/list_input.dart';

class AccountInfoPage extends HookConsumerWidget {
  AccountInfoPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  _buildOverviewList(context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: const [
          WidgetInput(
            icon: Icons.person,
            title: "Name",
            hint: "Enter your account name",
          ),
          WidgetInput(
            title: "Description",
            hint: "Enter the description",
          ),
          WidgetChip(
            title: "Type",
            options: [
              FormBuilderChipOption(value: 'account', child: Text('Account')),
              FormBuilderChipOption(
                  value: 'investment', child: Text('Investment')),
              FormBuilderChipOption(value: 'business', child: Text('Business')),
            ],
          ),
          WidgetInput(
            title: "Responsible",
            hint: "Name of responsible",
          ),
          WidgetInput(
            icon: Icons.notes_outlined,
            title: "Notes",
            hint: "Add extra information",
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 1),
      () => 'Account Info Page',
    );

    return FutureBuilder(
      future: foo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Accounts'),
            ),
            body: ListView(
              children: [_buildOverviewList(context)],
            ),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'create-edit-account',
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  debugPrint(_formKey.currentState!.value.entries.toString());
                }
              },
              label: const Text('Save'),
              icon: const Icon(Icons.save),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
