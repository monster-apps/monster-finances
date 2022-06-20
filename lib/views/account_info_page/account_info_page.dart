import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/widgets/list_chip.dart';
import 'package:monster_finances/widgets/list_input.dart';

class AccountInfoPage extends HookConsumerWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  _buildOverviewList(context) {
    return [
      WidgetInput(
          icon: Icons.account_balance_outlined,
          title: "Name",
          hint: "Enter your account name",
          value: "Bank of montreal",
          onChange: (value) {
            debugPrint("called onChange $value");
          }),
      WidgetInput(
          icon: Icons.description,
          title: "Description",
          hint: "Enter the description",
          value: "Bank of montreal",
          onChange: (value) {
            debugPrint("called onChange $value");
          }),
      WidgetChip(
          icon: Icons.category_outlined,
          title: "Type",
          value: "Bank of montreal",
          options: const [
            FormBuilderChipOption(value: 'account', child: Text('Account')),
            FormBuilderChipOption(
                value: 'investment', child: Text('Investment')),
            FormBuilderChipOption(value: 'business', child: Text('Business')),
          ],
          onChange: (value) {
            debugPrint("called onChange $value");
          }),
      WidgetInput(
          icon: Icons.accessibility_outlined,
          title: "Responsible",
          hint: "Name of responsible",
          value: "Bank of montreal",
          onChange: (value) {
            debugPrint("called onChange $value");
          }),
      WidgetInput(
          icon: Icons.notes_outlined,
          title: "Notes",
          hint: "Add extra information",
          value: "Bank of montreal",
          maxLines: 5,
          onChange: (value) {
            debugPrint("called onConfirm $value");
          }),
    ];
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: _buildOverviewList(context),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                debugPrint("save form");
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
