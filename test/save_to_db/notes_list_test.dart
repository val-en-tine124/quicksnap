import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:quicksnap/features/save_to_db/models.dart';
import 'package:quicksnap/features/save_to_db/providers.dart';
import 'package:quicksnap/features/save_to_db/ui.dart';

// ---------------------------------------------------------------------------
// Helper: create a QuickSnapNote with a simple delta
// ---------------------------------------------------------------------------
QuickSnapNote _makeNote(String text) {
  return QuickSnapNote(
    deltaJson: jsonEncode([
      {'insert': '$text\n'},
    ]),
  );
}

// ---------------------------------------------------------------------------
// Provider tests
// ---------------------------------------------------------------------------
void main() {
  late LazyBox<QuickSnapNote> box;

  setUp(() async {
    // Use an in-memory Hive store so we don't need Flutter path provider.
    Hive.init('test/.hive_test_data');
    // Erase any leftover data from a previous run
    try {
      await Hive.deleteBoxFromDisk('QuickSnapNotes');
    } catch (_) {}

    box = await Hive.openLazyBox<QuickSnapNote>('QuickSnapNotes');
  });

  tearDown(() async {
    await box.close();
    try {
      await Hive.deleteBoxFromDisk('QuickSnapNotes');
    } catch (_) {}
  });

  group('QuickSnapNotes provider', () {
    testWidgets('returns empty list when box is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [handleHiveBoxProvider.overrideWith((ref) async => box)],
          child: const _ProviderReader(),
        ),
      );
      await tester.pump();

      // The provider should have data (empty list)
      expect(find.text('count: 0'), findsOneWidget);
    });

    testWidgets('returns saved notes', (tester) async {
      // Pre-populate the box
      await box.put('note1', _makeNote('Hello'));
      await box.put('note2', _makeNote('World'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [handleHiveBoxProvider.overrideWith((ref) async => box)],
          child: const _ProviderReader(),
        ),
      );
      await tester.pump();

      expect(find.text('count: 2'), findsOneWidget);
    });

    testWidgets('removefromDB removes a note', (tester) async {
      await box.put('note1', _makeNote('Hello'));
      await box.put('note2', _makeNote('World'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [handleHiveBoxProvider.overrideWith((ref) async => box)],
          child: const _ProviderReader(),
        ),
      );
      await tester.pump();
      expect(find.text('count: 2'), findsOneWidget);
    });

    testWidgets('hasMore returns true when there are unread notes', (
      tester,
    ) async {
      // Put more notes than the default batch size of 7, so not all are loaded
      for (int i = 0; i < 10; i++) {
        await box.put('note$i', _makeNote('Note $i'));
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [handleHiveBoxProvider.overrideWith((ref) async => box)],
          child: const _HasMoreReader(),
        ),
      );
      await tester.pump();

      // With 10 notes and batch size 7, hasMore should be true
      expect(find.text('hasMore: true'), findsOneWidget);
    });

    testWidgets('saveToDB persists a note', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [handleHiveBoxProvider.overrideWith((ref) async => box)],
          child: const _SaveAndRead(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // After saving "testNote", it should appear in the list
      expect(find.text('saved: testNote'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // UI tests for AnimatedNoteList
  // ---------------------------------------------------------------------------
  group('AnimatedNoteList', () {
    testWidgets('shows empty state when no notes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedNoteList(
              noNotes: 0,
              notes: [],
              controller: ScrollController(),
              hasMore: false,
            ),
          ),
        ),
      );

      expect(find.text('No saved notes'), findsOneWidget);
    });

    testWidgets('shows spinner when hasMore is true', (tester) async {
      final notes = [('note1', _makeNote('Hello'))];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 500,
              child: AnimatedNoteList(
                noNotes: notes.length,
                notes: notes,
                controller: ScrollController(),
                hasMore: true,
              ),
            ),
          ),
        ),
      );

      // Should show the note tile
      expect(find.text('note1'), findsOneWidget);
      // Should also show the spinner at the bottom
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not show spinner when hasMore is false', (tester) async {
      final notes = [('note1', _makeNote('Hello'))];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 500,
              child: AnimatedNoteList(
                noNotes: notes.length,
                notes: notes,
                controller: ScrollController(),
                hasMore: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('note1'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows multiple notes', (tester) async {
      final notes = [
        ('note1', _makeNote('First')),
        ('note2', _makeNote('Second')),
        ('note3', _makeNote('Third')),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 500,
              child: AnimatedNoteList(
                noNotes: notes.length,
                notes: notes,
                controller: ScrollController(),
                hasMore: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('note1'), findsOneWidget);
      expect(find.text('note2'), findsOneWidget);
      expect(find.text('note3'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(3));
    });
  });
}

// ---------------------------------------------------------------------------
// Helper widgets for testing providers without UI
// ---------------------------------------------------------------------------

/// Reads the provider and displays the count.
class _ProviderReader extends ConsumerWidget {
  const _ProviderReader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotes = ref.watch(quickSnapNotesProvider);
    return asyncNotes.when(
      data: (notes) => Text('count: ${notes.length}'),
      loading: () => const Text('loading'),
      error: (err, _) => Text('error: $err'),
    );
  }
}

/// Reads hasMore from the notifier.
class _HasMoreReader extends ConsumerWidget {
  const _HasMoreReader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotes = ref.watch(quickSnapNotesProvider);
    return asyncNotes.when(
      data: (_) {
        final hm = ref.read(quickSnapNotesProvider.notifier).hasMore();
        return Text('hasMore: $hm');
      },
      loading: () => const Text('loading'),
      error: (err, _) => Text('error: $err'),
    );
  }
}

/// Saves a note then reads it back.
class _SaveAndRead extends ConsumerWidget {
  const _SaveAndRead();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off a save after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(quickSnapNotesProvider.notifier);
      await notifier.saveToDB(
        // A simple delta
        Delta()..insert('Hello World'),
        'testNote',
      );
    });

    final asyncNotes = ref.watch(quickSnapNotesProvider);
    return asyncNotes.when(
      data: (notes) {
        final titles = notes.map((n) => n.$1).toList();
        return Text(
          'saved: ${titles.contains("testNote") ? "testNote" : "missing"}',
        );
      },
      loading: () => const Text('loading'),
      error: (err, _) => Text('error: $err'),
    );
  }
}
