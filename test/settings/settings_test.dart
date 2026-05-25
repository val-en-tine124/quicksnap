import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicksnap/features/settings/ui.dart';

void main() {
  testWidgets('This is a test for settings UI', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SettingsUI())));
    await tester.pump();
    expect(find.byType(ListView), findsOneWidget);
    await tester.tap(find.text('App Theme'));
    await tester.pumpAndSettle();
    expect(find.text('Choose Theme'), findsOneWidget);
  });
}
