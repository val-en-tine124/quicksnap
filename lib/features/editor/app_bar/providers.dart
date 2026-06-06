import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_drawer/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class AppBarTitle extends _$AppBarTitle {
  @override
  String build() {
    final fileData = ref.watch(filePickerProvider);
    // Watch the save signal — when it toggles, this rebuilds
    ref.watch(fileJustSavedProvider);
    var appBarTitle = fileData.value?.name ?? 'Untitled Document';
    final isEdited = ref.watch(isEditedProvider);
    if (isEdited) {
      appBarTitle += ' *';
    }
    return appBarTitle;
  }

  ///Change the  appBar name to `newTitle`.
  void changeTitle(String newTitle) {
    state = newTitle;
  }
}