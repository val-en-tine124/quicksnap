import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizmos_settings_screen/gizmos_settings_screen.dart';
import 'package:quicksnap/features/settings/ui.dart';

void main() {
  testWidgets("This is a test for settings UI", (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child:MaterialApp(home: SettingsUI())));
    await tester.pump();
    expect(find.byType(SettingsSkin), findsOneWidget);
    await tester.tap(find.byType(DetailsSettingsCell),kind:.mouse);
    await tester.pumpAndSettle();
  });
}
