// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This is a provider for the text editor loading state.
/// It return a boolean.

@ProviderFor(EditorIsLoading)
final editorIsLoadingProvider = EditorIsLoadingProvider._();

/// This is a provider for the text editor loading state.
/// It return a boolean.
final class EditorIsLoadingProvider
    extends $NotifierProvider<EditorIsLoading, bool> {
  /// This is a provider for the text editor loading state.
  /// It return a boolean.
  EditorIsLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editorIsLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editorIsLoadingHash();

  @$internal
  @override
  EditorIsLoading create() => EditorIsLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$editorIsLoadingHash() => r'12c411cd75d265dad87de45683e368965f9fef3d';

/// This is a provider for the text editor loading state.
/// It return a boolean.

abstract class _$EditorIsLoading extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AppBarTitle)
final appBarTitleProvider = AppBarTitleProvider._();

final class AppBarTitleProvider extends $NotifierProvider<AppBarTitle, String> {
  AppBarTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBarTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBarTitleHash();

  @$internal
  @override
  AppBarTitle create() => AppBarTitle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$appBarTitleHash() => r'526879d1abf9923297023caf808cbd665b7e1183';

abstract class _$AppBarTitle extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

///This notifier contains methods for various file operation.

@ProviderFor(FilePickerNotifier)
final filePickerProvider = FilePickerNotifierProvider._();

///This notifier contains methods for various file operation.
final class FilePickerNotifierProvider
    extends $AsyncNotifierProvider<FilePickerNotifier, PlatformFile?> {
  ///This notifier contains methods for various file operation.
  FilePickerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filePickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filePickerNotifierHash();

  @$internal
  @override
  FilePickerNotifier create() => FilePickerNotifier();
}

String _$filePickerNotifierHash() =>
    r'5f8738b693112dad608197cafeafbd557f80bedd';

///This notifier contains methods for various file operation.

abstract class _$FilePickerNotifier extends $AsyncNotifier<PlatformFile?> {
  FutureOr<PlatformFile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlatformFile?>, PlatformFile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlatformFile?>, PlatformFile?>,
              AsyncValue<PlatformFile?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
