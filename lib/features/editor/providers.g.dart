// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$appBarTitleHash() => r'3c944e727c6d54635aaaaa37c23e29c538223545';

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
    r'ac92e92a91ce0eb2771b27508e3f098b192d6b51';

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
