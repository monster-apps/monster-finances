import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/providers/account_list_provider.dart';
import 'package:monster_finances/providers/account_query_provider.dart';
import 'package:monster_finances/queries/accounts.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';

import '../../_test_utils/fake_accounts.dart';
import 'accounts_page_test.mocks.dart';

ProviderScope getProviderScope(MockAccountQuery accountQuery) {
  return ProviderScope(
    overrides: [accountQueryProvider.overrideWithValue(accountQuery)],
    child: HookBuilder(
      builder: (context) {
        return const MaterialApp(home: AccountsPage());
      },
    ),
  );
}

@GenerateMocks([AccountQuery])
void main() {
  group('accounts should display the proper states for error and loading', () {
    testWidgets('account page with error', (tester) async {
      final MockAccountQuery accountQuery = MockAccountQuery();
      when(accountQuery.getTotalValue()).thenReturn(0);

      final error = Error();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountListProvider.overrideWithValue(AsyncValue.error(error)),
            accountQueryProvider.overrideWithValue(accountQuery),
          ],
          child: HookBuilder(
            builder: (context) {
              return const MaterialApp(home: AccountsPage());
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_account_list')), findsOneWidget);
    });

    testWidgets('account page should have a loading state', (tester) async {
      final MockAccountQuery accountQuery = MockAccountQuery();
      when(accountQuery.getTotalValue()).thenReturn(0);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountListProvider.overrideWithValue(const AsyncValue.loading()),
            accountQueryProvider.overrideWithValue(accountQuery),
          ],
          child: HookBuilder(
            builder: (context) {
              return const MaterialApp(home: AccountsPage());
            },
          ),
        ),
      );

      expect(find.byKey(const Key('loading_account_list')), findsOneWidget);
    });
  });

  group('accounts should display the proper data in the page', () {
    testWidgets('default account page with no data', (tester) async {
      final MockAccountQuery accountQuery = MockAccountQuery();

      when(accountQuery.getAllAccounts()).thenReturn(List.empty());
      when(accountQuery.getTotalValue()).thenReturn(0);

      await tester.pumpWidget(getProviderScope(accountQuery));

      // The default value is `0`, as declared in our provider
      expect(find.text('0.0'), findsOneWidget);
    });

    testWidgets('account page with 2 positive value accounts', (tester) async {
      final MockAccountQuery accountQuery = MockAccountQuery();

      final List<Account> accounts = [
        ...AccountTestUtil().createFakeAccounts(amount: 2, typeId: 1),
      ];

      when(accountQuery.getAllAccounts()).thenReturn(accounts);

      when(accountQuery.getTotalValue()).thenReturn(0.3);
      when(accountQuery.getTotalValueByAccountType(1)).thenReturn(0.3);
      when(accountQuery.getTotalValueByAccount(1)).thenReturn(0.1);
      when(accountQuery.getTotalValueByAccount(2)).thenReturn(0.2);

      await tester.pumpWidget(getProviderScope(accountQuery));

      await tester.pumpAndSettle();

      // The default value is `0`, as declared in our provider
      expect(find.text('+ 0.1'), findsOneWidget);
      expect(find.text('+ 0.2'), findsOneWidget);
      expect(find.text('+ 0.3'), findsNWidgets(2));
      expect(find.text('Type 1'), findsOneWidget);
      expect(find.text('Bank 1'), findsOneWidget);
      expect(find.text('Bank 2'), findsOneWidget);
    });
  });

  testWidgets('account page with 2 negative value accounts', (tester) async {
    final MockAccountQuery accountQuery = MockAccountQuery();

    final List<Account> accounts = [
      ...AccountTestUtil().createFakeAccounts(amount: 2, typeId: 1),
    ];

    when(accountQuery.getAllAccounts()).thenReturn(accounts);

    when(accountQuery.getTotalValue()).thenReturn(-0.3);
    when(accountQuery.getTotalValueByAccountType(1)).thenReturn(-0.3);
    when(accountQuery.getTotalValueByAccount(1)).thenReturn(-0.1);
    when(accountQuery.getTotalValueByAccount(2)).thenReturn(-0.2);

    await tester.pumpWidget(getProviderScope(accountQuery));

    await tester.pumpAndSettle();

    // The default value is `0`, as declared in our provider
    expect(find.text('- 0.1'), findsOneWidget);
    expect(find.text('- 0.2'), findsOneWidget);
    expect(find.text('- 0.3'), findsNWidgets(2));
    expect(find.text('Type 1'), findsOneWidget);
    expect(find.text('Bank 1'), findsOneWidget);
    expect(find.text('Bank 2'), findsOneWidget);
  });

  group('accounts should be grouped by account type', () {
    testWidgets('account page with 2 types of accounts', (tester) async {
      final MockAccountQuery accountQuery = MockAccountQuery();

      final List<Account> accounts = [
        ...AccountTestUtil().createFakeAccounts(amount: 2, typeId: 1),
        ...AccountTestUtil().createFakeAccounts(
          amount: 2,
          startFromId: 3,
          typeId: 2,
        ),
      ];

      when(accountQuery.getAllAccounts()).thenReturn(accounts);

      when(accountQuery.getTotalValue()).thenReturn(0.12);
      when(accountQuery.getTotalValueByAccountType(1)).thenReturn(0.3);
      when(accountQuery.getTotalValueByAccountType(2)).thenReturn(0.9);
      when(accountQuery.getTotalValueByAccount(1)).thenReturn(0.1);
      when(accountQuery.getTotalValueByAccount(2)).thenReturn(0.2);
      when(accountQuery.getTotalValueByAccount(3)).thenReturn(0.4);
      when(accountQuery.getTotalValueByAccount(4)).thenReturn(0.5);

      await tester.pumpWidget(getProviderScope(accountQuery));

      await tester.pumpAndSettle();

      // The default value is `0`, as declared in our provider
      expect(find.text('+ 0.1'), findsOneWidget);
      expect(find.text('+ 0.2'), findsOneWidget);
      expect(find.text('+ 0.3'), findsOneWidget);
      expect(find.text('+ 0.4'), findsOneWidget);
      expect(find.text('+ 0.5'), findsOneWidget);
      expect(find.text('+ 0.9'), findsOneWidget);
      expect(find.text('+ 0.12'), findsOneWidget);
      expect(find.text('Type 1'), findsOneWidget);
      expect(find.text('Type 2'), findsOneWidget);
      expect(find.text('Bank 1'), findsOneWidget);
      expect(find.text('Bank 2'), findsOneWidget);
      expect(find.text('Bank 3'), findsOneWidget);
      expect(find.text('Bank 4'), findsOneWidget);
    });
  });
}
