import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:monster_finances/config.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/queries/accounts.dart';
import 'package:monster_finances/providers/account_query_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/views/account_transactions_page/account_transactions_page.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';
import 'package:monster_finances/views/overview_page/empty_page.dart';
import 'package:monster_finances/views/overview_page/overview_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../_test_utils/fake_accounts.dart';
import 'overview_page_test.mocks.dart';

ProviderScope getProviderScope(MockAccountQuery accountQuery) {
  return ProviderScope(
    overrides: [accountQueryProvider.overrideWithValue(accountQuery)],
    child: HookBuilder(
      builder: (context) {
        return const MaterialApp(home: OverviewPage());
      },
    ),
  );
}

@GenerateMocks([AccountQuery])
void main() {
  group('large screen', () {
    testWidgets('should render account page and empty page', (tester) async {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue = Size(
        (Config().breakpoint + 1) * dpi,
        420.0 * dpi,
      );

      PackageInfo.setMockInitialValues(
        appName: 'test-app-name',
        packageName: 'test-package-name',
        version: '0.0.0',
        buildNumber: '0',
        buildSignature: 'test',
      );

      final MockAccountQuery accountQuery = MockAccountQuery();

      when(accountQuery.getAllAccounts()).thenReturn(List.empty());
      when(accountQuery.getTotalValue()).thenReturn(0);

      await tester.pumpWidget(getProviderScope(accountQuery));
      await tester.pumpAndSettle();

      expect(find.byType(AccountsPage), findsOneWidget);
      expect(find.byType(AccountTransactionsPage), findsNothing);
      expect(find.byType(EmptyPage), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should render account page, transactions and empty page',
        (tester) async {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue = Size(
        (Config().breakpoint + 1) * dpi,
        420.0 * dpi,
      );

      PackageInfo.setMockInitialValues(
        appName: 'test-app-name',
        packageName: 'test-package-name',
        version: '0.0.0',
        buildNumber: '0',
        buildSignature: 'test',
      );

      final MockAccountQuery accountQuery = MockAccountQuery();

      final List<Account> accounts = [
        ...AccountTestUtil().createFakeAccounts(amount: 1, typeId: 1),
      ];

      when(accountQuery.getAllAccounts()).thenReturn(accounts);
      when(accountQuery.getTotalValue()).thenReturn(0);
      when(accountQuery.getTotalValueByAccount(1)).thenReturn(0.0);
      when(accountQuery.getTotalValueByAccountType(1)).thenReturn(0.0);

      CurrentAccountNotifier notifier = CurrentAccountNotifier();
      notifier.update(1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountQueryProvider.overrideWithValue(accountQuery),
            currentAccountProvider.overrideWithValue(notifier)
          ],
          child: HookBuilder(
            builder: (context) {
              return const MaterialApp(home: OverviewPage());
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AccountsPage), findsOneWidget);
      expect(find.byType(AccountTransactionsPage), findsOneWidget);
      expect(find.byType(EmptyPage), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('small screen', () {
    testWidgets('should render only account page', (tester) async {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue = Size(
        (Config().breakpoint - 1) * dpi,
        420.0 * dpi,
      );

      final MockAccountQuery accountQuery = MockAccountQuery();

      when(accountQuery.getAllAccounts()).thenReturn(List.empty());
      when(accountQuery.getTotalValue()).thenReturn(0);

      await tester.pumpWidget(getProviderScope(accountQuery));
      await tester.pumpAndSettle();

      expect(find.byType(AccountsPage), findsOneWidget);
      expect(find.byType(AccountTransactionsPage), findsNothing);
      expect(find.byType(EmptyPage), findsNothing);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
