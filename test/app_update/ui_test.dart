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

    testWidgets('shows mandatory update warning when isMandatory is true', (
      WidgetTester tester,
    ) async {
      const config = UpdateConfig(
        latestVersion: '2.0.0',
        downloadUrlV8a: 'https://example.com/app.apk',
        downloadUrlV7a: 'https://example.com/app.apk',
        isMandatory: true,
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuickSnapUpdateDialog(
              updateConfig: config,
              isMandatory: true,
            ),
          ),
        ),
      );

      await tester.pump();

      // Check for the warning text
      expect(
        find.text('This update is required to continue using the app.'),
        findsOneWidget,
      );
    });

    testWidgets('does not show mandatory warning when isMandatory is false', (
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
                ),
              ),
            ),
          ),
        ),
      );

      expect(
        find.text('This update is required to continue using the app.'),
        findsNothing,
      );
    });

    testWidgets('shows "Later" button when update is not mandatory', (
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
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Later'), findsOneWidget);
    });

    testWidgets('does not show "Later" button when update is mandatory', (
      WidgetTester tester,
    ) async {
      const config = UpdateConfig(
        latestVersion: '2.0.0',
        downloadUrlV8a: 'https://example.com/app.apk',
        downloadUrlV7a: 'https://example.com/app.apk',
        isMandatory: true,
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuickSnapUpdateDialog(
              updateConfig: config,
              isMandatory: true,
            ),
          ),
        ),
      );

      await tester.pump();

      // When isMandatory is true, the "Later" button should not be shown
      expect(find.text('Later'), findsNothing);
    });

    testWidgets('shows "Update Now" button', (WidgetTester tester) async {
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

      expect(find.text('Update Now'), findsOneWidget);
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

      await tester.tap(find.text('Update Now'));
      await tester.pump();

      expect(dialogResult, true);
    });
    testWidgets("Show linear progress bar", (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body:QuicksnapUpdateProgressBar(progress: 1.0,),
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text("Updating QuickSnap ..."), findsOneWidget);
    });
  });

}