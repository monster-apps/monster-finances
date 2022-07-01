import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_finances/views/empty_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  testWidgets('should have loading state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EmptyPage(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should have project name and version', (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'test-app-name',
      packageName: 'test-package-name',
      version: '0.0.0',
      buildNumber: '0',
      buildSignature: 'test',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: EmptyPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Monster Finances'), findsOneWidget);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    expect(find.text(packageInfo.version), findsOneWidget);
  });
}
