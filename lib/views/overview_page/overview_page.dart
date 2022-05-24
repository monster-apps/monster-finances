import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:vrouter/vrouter.dart';

List _elements = [
  {
    'name': 'Bank A',
    'description': '',
    'type': 'Account',
    'responsible': 'Luan',
    'operating_currency': 'BRL',
  },
  {
    'name': 'Bank B',
    'description': 'Chequing account',
    'type': 'Account',
    'responsible': 'Luan',
    'operating_currency': 'CAD',
  },
  {
    'name': 'Bank B',
    'description': 'Savings account',
    'type': 'Account',
    'responsible': 'Luan',
    'operating_currency': 'CAD',
  },
  {
    'name': 'Exchange A',
    'description': '',
    'type': 'Investment',
    'responsible': 'Luan',
    'operating_currency': 'CAD',
  },
  {
    'name': 'Brokerage A',
    'description': '',
    'type': 'Investment',
    'responsible': 'Luan',
    'operating_currency': 'CAD',
  },
  {
    'name': 'Metamask',
    'description': 'Account 1',
    'type': 'Investment',
    'responsible': 'Luan',
    'operating_currency': '',
  },
];

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 2),
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
      ),);
    }

    mainBody() {
      return SingleChildScrollView(
        child: Row(children: [
          Expanded(
            child: GroupedListView<dynamic, String>(
              elements: _elements,
              groupBy: (element) => element['type'],
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // itemExtent: 40.0,
              separator: const Divider(),
              groupHeaderBuilder: (element) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Text(element['type']),
                    const Spacer(),
                    const Text('+ 1215.49')
                  ],
                ),
              ),
              itemBuilder: (context, element) {
                return ListTile(
                  leading: const Icon(Icons.house_outlined),
                  title: Text(element['name']),
                  subtitle: Text(element['description']),
                  trailing: const Text('+ 123.90'),
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 16.0),
                  onTap: () {
                    context.vRouter
                        .toSegments(['accounts', '1', 'transactions']);
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
