import 'package:flutter/material.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 2),
      () => 'Account Info Page',
    );

    return FutureBuilder(
      future: foo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              body: Center(
            child: Text('Page: ${snapshot.data}'),
          ));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
