import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class AccountTransactionsPage extends StatelessWidget {
  const AccountTransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 1),
      () => 'Account Transactions Page',
    );

    return FutureBuilder(
      future: foo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Transaction name",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "description",
                    style: TextStyle(fontSize: 14.0),
                  )
                ],
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit account',
                  onPressed: () {
                    context.vRouter.toSegments(['accounts', 'new']);
                  },
                ),
              ],
            ),
            body: Center(
              child: Text('Page: ${snapshot.data}'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.vRouter
                    .toSegments(['accounts', '1', 'transactions', 'new']);
              },
              child: const Icon(Icons.add),
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
