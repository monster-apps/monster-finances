import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/objectbox.g.dart';
import 'package:vrouter/vrouter.dart';

import '../../main.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 1),
      () => 'Overview Page',
    );

    buildWithBody(Widget body) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Overview'),
        ),
        body: body,
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
              groupHeaderBuilder: (element) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Text(element.type.target != null
                        ? element.type.target!.name
                        : ''),
                    const Spacer(),
                    const Text('+ 1215.49'),
                  ],
                ),
              ),
              itemBuilder: (context, element) {
                double amountInAccount = storeBox.transactions
                    .query(Transaction_.account.equals(element.id))
                    .build()
                    .property(Transaction_.value)
                    .sum();
                return ListTile(
                  leading: const Icon(Icons.house_outlined),
                  title: Text(element.name),
                  subtitle: Text(
                      element.description != null ? element.description! : ''),
                  trailing: Text(
                      '${amountInAccount > 0 ? '+' : '-'} $amountInAccount'),
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
