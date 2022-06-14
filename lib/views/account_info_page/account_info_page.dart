import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/widgets/input_dialog.dart';

class AccountInfoPage extends HookConsumerWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  _buildOverviewList(context) {
    return [
      const WidgetInputDialog(
        label: "name",
        title: "account",
        value: "Bank of montreal",
      ),
      const ListTile(
        leading: CircleAvatar(child: Text('N')),
        title: Text('Description'),
        subtitle: Text('001 23112 001 123 456 7'),
      )
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
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
