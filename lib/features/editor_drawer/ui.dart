import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/save_to_db/ui.dart';

/// Legacy drawer — kept for compatibility.
/// Active drawer is DBNotesDrawer in save_to_db/ui.dart.
class EditorDrawer extends ConsumerWidget {
  const EditorDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DBNotesDrawer();
  }
}