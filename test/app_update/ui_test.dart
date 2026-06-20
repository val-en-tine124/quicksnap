import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicksnap/features/app_update/models.dart';
import 'package:quicksnap/features/app_update/ui.dart';

void main() {
  group('QuickSnapUpdateDialog', () {

    testWidgets('displays update title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuickSnapUpdateDialog(
                updateConfig: UpdateConfig(
                  latestVersion: '2.0.0',
                  downloadUrlV8a: 'https://example.com/app.apk',
                  downloadUrlV7a: 'https://example.com/app.apk',
                  isMandatory: false,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Update Available'), findsOneWidget);
    });

    testWidgets('displays new version number', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuickSnapUpdateDialog(
                updateConfig: UpdateConfig(
                  latestVersion: '3.1.0',
                  downloadUrlV8a: 'https://example.com/app.apk',
                  downloadUrlV7a: 'https://example.com/app.apk',
                  isMandatory: false,
                ),
              ),
            ),
          ),
        ),
      );

      // Version appears in the main message "A new version (3.1.0) is available!"
      expect(find.textContaining('3.1.0'), findsWidgets);
    });

    testWidgets('displays release notes when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuickSnapUpdateDialog(
                updateConfig: UpdateConfig(
                  latestVersion: '2.0.0',
                  downloadUrlV8a: 'https://example.com/app.apk',
                  downloadUrlV7a: 'https://example.com/app.apk',
                  isMandatory: false,
                  releaseNotes: 'Fixed critical bugs',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text("What's new:"), findsOneWidget);
      expect(find.text('Fixed critical bugs'), findsOneWidget);
    });

    testWidgets(
      'does not show release notes section when releaseNotes is null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: QuickSnapUpdateDialog(
                  updateConfig: UpdateConfig(
                    latestVersion: '2.0.0',
                    downloadUrlV8a: 'https://example.com/app.apk',
                    downloadUrlV7a: 'https://example.com/app.apk',
                    isMandatory: false,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.text("What's new:"), findsNothing);
      },
    );

  
   
  

    testWidgets('shows "Download Update" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: QuickSnapUpdateDialog(
                updateConfig: UpdateConfig(
                  latestVersion: '2.0.0',
                  downloadUrlV8a: 'https://example.com/app.apk',
                  downloadUrlV7a: 'https://example.com/app.apk',
                  isMandatory: false,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Download Update'), findsOneWidget);
    });

    testWidgets('"Later" button dismisses dialog with false', (
      WidgetTester tester,
    ) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    dialogResult = await showDialog<bool>(
                      context: context,
                      builder: (context) => const QuickSnapUpdateDialog(
                        updateConfig: UpdateConfig(
                          latestVersion: '2.0.0',
                          downloadUrlV8a: 'https://example.com/app.apk',
                          downloadUrlV7a: 'https://example.com/app.apk',
                          isMandatory: false,
                        ),
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pump();

      await tester.tap(find.text('Later'));
      await tester.pump();

      expect(dialogResult, false);
    });

    testWidgets('"Update Now" button dismisses dialog with true', (
      WidgetTester tester,
    ) async {
      bool? dialogResult;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      dialogResult = await showDialog<bool>(
                        context: context,
                        builder: (context) => const QuickSnapUpdateDialog(
                          updateConfig: UpdateConfig(
                            latestVersion: '2.0.0',
                            downloadUrlV8a: 'https://example.com/app.apk',
                            downloadUrlV7a: 'https://example.com/app.apk',
                            isMandatory: false,
                          ),
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pump();

      await tester.tap(find.text('Download Update'));
      await tester.pump();

      expect(dialogResult, true);
    });
  });

}