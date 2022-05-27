import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/queries/accounts.dart';
import 'package:monster_finances/utils/text_util.dart';
import 'package:vrouter/vrouter.dart';

import '../../main.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 1),
      () => 'Overview Page',
    );

    buildWithBody(Widget body) {
      double amountTotal = getTotalValue();

      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Overview'),
        ),
        body: body,
        bottomNavigationBar: BottomAppBar(
          child: ListTile(
            title: const Text('Total'),
            trailing: Text(TextUtil().getFormattedAmount(amountTotal)),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            VRouter.of(context).to('/accounts/new');
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    mainBody() {
      return SingleChildScrollView(
        child: Row(children: [
          Expanded(
            child: GroupedListView<Account, String>(
              elements: storeBox.accounts.getAll(),
              groupBy: (element) =>
                  element.type.target != null ? element.type.target!.name : '',
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // itemExtent: 40.0,
              separator: const Divider(),
              groupHeaderBuilder: (element) {
                double amountInAccountType =
                    getTotalValueByAccountType(element.type.targetId);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(element.type.target != null
                          ? element.type.target!.name
                          : ''),
                      const Spacer(),
                      Text(TextUtil().getFormattedAmount(amountInAccountType)),
                    ],
                  ),
                );
              },
              itemBuilder: (context, element) {
                double amountInAccount = getTotalValueByAccount(element.id);
                return ListTile(
                  title: Text(element.name),
                  subtitle: Text(
                      element.description != null ? element.description! : ''),
                  trailing:
                      Text(TextUtil().getFormattedAmount(amountInAccount)),
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 16.0),
                  onTap: () {
                    context.vRouter.toSegments(
                        ['accounts', element.id.toString(), 'transactions']);
                  },
                );
              },
            ),
          ),
        ]),
      );
    }

    return FutureBuilder(
      future: foo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildWithBody(mainBody());
        }
        return buildWithBody(const Center(child: CircularProgressIndicator()));
      },
    );
  }
}