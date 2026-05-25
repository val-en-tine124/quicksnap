import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicksnap/features/editor/about.dart';

void main() {
  testWidgets('Find text on selectable area.', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home:AboutPage()));
    await tester.pump();
    expect(find.text('Abba'),findsOneWidget);
    expect(find.text('compact'),findsOneWidget);
  }); 
}
