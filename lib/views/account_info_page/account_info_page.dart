import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/widgets/input_dialog.dart';

class AccountInfoPage extends HookConsumerWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  _buildOverviewList(context) {
    return ListTile.divideTiles(context: context, tiles: [
      WidgetInputDialog(
          title: "Name",
          value: "Bank of montreal",
          onConfirm: (value) {
            debugPrint("called onConfirm $value");
          }),
      WidgetInputDialog(
          title: "Description",
          value: "Bank of montreal",
          onConfirm: (value) {
            debugPrint("called onConfirm $value");
          }),
    ]);
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
