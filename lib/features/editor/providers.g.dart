// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilePickerNotifier)
final filePickerProvider = FilePickerNotifierProvider._();

final class FilePickerNotifierProvider
    extends $AsyncNotifierProvider<FilePickerNotifier, PlatformFile?> {
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
    r'35fd2b325cbda2b2a5ab05e4d2fcc440ba102dc1';

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
