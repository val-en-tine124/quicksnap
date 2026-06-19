import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class AppBarTitle extends _$AppBarTitle {
  String _title = '';

  @override
  String build() {
    // Watch the save signal — when it toggles, this rebuilds
    ref.watch(fileJustSavedProvider);
    final isEdited = ref.watch(isEditedProvider);
    final displayTitle = _title.isEmpty ? 'Untitled Document' : _title;
    if (isEdited) {
      return '$displayTitle *';
    }
    return displayTitle;
  }

  ///Change the  appBar name to `newTitle`.
  void changeTitle(String newTitle) {
    _title = newTitle;
    state = newTitle.isEmpty ? 'Untitled Document' : newTitle;
  }
  void reset(){
    _title = 'Untitled Document';
    state = 'Untitled Document';

  }
}
