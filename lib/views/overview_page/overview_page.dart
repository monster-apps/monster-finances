import 'package:flutter/material.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';

import 'empty_page.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildLargerScreen() {
      return Row(
        children: [
          const SizedBox(
            width: 280.0,
            child: AccountsPage(),
          ),
          Container(width: 0.5, color: Colors.grey),
          const Expanded(
            child: EmptyPage(),
          ),
        ],
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    const breakpoint = 600.0;
    if (screenWidth >= breakpoint) {
      return buildLargerScreen();
    }

    return const AccountsPage();
  }
}
