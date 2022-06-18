import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/providers/account_query_provider.dart';
import 'package:monster_finances/queries/accounts.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';

import 'accounts_page_test.mocks.dart';

@GenerateMocks([AccountQuery])
void main() {
  testWidgets('default account page with no data', (tester) async {
    final accountQuery = MockAccountQuery();
    when(accountQuery.getAllAccounts()).thenReturn(List.empty());
    when(accountQuery.getTotalValue()).thenReturn(0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [accountQueryProvider.overrideWithValue(accountQuery)],
        child: HookBuilder(
          builder: (context) {
            return const MaterialApp(home: AccountsPage());
          },
        ),
      ),
    );

    // The default value is `0`, as declared in our provider
    expect(find.text('0.0'), findsOneWidget);
  });

  testWidgets('account page with 2 positive value accounts', (tester) async {
    final accountQuery = MockAccountQuery();
    when(accountQuery.getAllAccounts()).thenReturn([
      Account(id: 1, name: 'Bank A'),
      Account(id: 2, name: 'Bank B'),
    ]);
    when(accountQuery.getTotalValue()).thenReturn(0.3);
    when(accountQuery.getTotalValueByAccountType(any)).thenReturn(0.3);
    when(accountQuery.getTotalValueByAccount(1)).thenReturn(0.1);
    when(accountQuery.getTotalValueByAccount(2)).thenReturn(0.2);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [accountQueryProvider.overrideWithValue(accountQuery)],
        child: HookBuilder(
          builder: (context) {
            return const MaterialApp(home: AccountsPage());
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // The default value is `0`, as declared in our provider
    expect(find.text('+ 0.1'), findsOneWidget);
    expect(find.text('+ 0.2'), findsOneWidget);
    expect(find.text('+ 0.3'), findsNWidgets(2));
  });

  testWidgets('account page with 2 negative value accounts', (tester) async {
    final accountQuery = MockAccountQuery();
    when(accountQuery.getAllAccounts()).thenReturn([
      Account(id: 1, name: 'Bank A'),
      Account(id: 2, name: 'Bank B'),
    ]);
    when(accountQuery.getTotalValue()).thenReturn(-0.3);
    when(accountQuery.getTotalValueByAccountType(any)).thenReturn(-0.3);
    when(accountQuery.getTotalValueByAccount(1)).thenReturn(-0.1);
    when(accountQuery.getTotalValueByAccount(2)).thenReturn(-0.2);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [accountQueryProvider.overrideWithValue(accountQuery)],
        child: HookBuilder(
          builder: (context) {
            return const MaterialApp(home: AccountsPage());
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // The default value is `0`, as declared in our provider
    expect(find.text('- 0.1'), findsOneWidget);
    expect(find.text('- 0.2'), findsOneWidget);
    expect(find.text('- 0.3'), findsNWidgets(2));
  });
}
