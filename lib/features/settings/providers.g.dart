// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class QuickSnapSettingsAdapter extends TypeAdapter<QuickSnapSettings> {
  @override
  final typeId = 0;

  @override
  QuickSnapSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuickSnapSettings(
      theme: fields[6] == null ? ThemeMode.system : fields[6] as ThemeMode,
      autoFocus: fields[7] == null ? true : fields[7] as bool,
      expands: fields[8] == null ? true : fields[8] as bool,
      disableClipboard: fields[9] == null ? false : fields[9] as bool,
      scrollable: fields[10] == null ? true : fields[10] as bool,
      padding: fields[11] == null ? 0.0 : (fields[11] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, QuickSnapSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(6)
      ..write(obj.theme)
      ..writeByte(7)
      ..write(obj.autoFocus)
      ..writeByte(8)
      ..write(obj.expands)
      ..writeByte(9)
      ..write(obj.disableClipboard)
      ..writeByte(10)
      ..write(obj.scrollable)
      ..writeByte(11)
      ..write(obj.padding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickSnapSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final typeId = 1;

  @override
  ThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    switch (obj) {
      case ThemeMode.system:
        writer.writeByte(0);
      case ThemeMode.light:
        writer.writeByte(1);
      case ThemeMode.dark:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsInHive)
final settingsInHiveProvider = SettingsInHiveProvider._();

final class SettingsInHiveProvider
    extends
        $FunctionalProvider<
          Box<QuickSnapSettings>,
          Box<QuickSnapSettings>,
          Box<QuickSnapSettings>
        >
    with $Provider<Box<QuickSnapSettings>> {
  SettingsInHiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsInHiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsInHiveHash();

  @$internal
  @override
  $ProviderElement<Box<QuickSnapSettings>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Box<QuickSnapSettings> create(Ref ref) {
    return settingsInHive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<QuickSnapSettings> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<QuickSnapSettings>>(value),
    );
  }
}

String _$settingsInHiveHash() => r'eff2512fc477aa0482b73e6ec85eb0099139d746';

@ProviderFor(SettingsState)
final settingsStateProvider = SettingsStateProvider._();

final class SettingsStateProvider
    extends $AsyncNotifierProvider<SettingsState, QuickSnapSettings> {
  SettingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStateHash();

  @$internal
  @override
  SettingsState create() => SettingsState();
}

String _$settingsStateHash() => r'5acf99278d81251c02108c471c2809e8e88c6fd2';

abstract class _$SettingsState extends $AsyncNotifier<QuickSnapSettings> {
  FutureOr<QuickSnapSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<QuickSnapSettings>, QuickSnapSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QuickSnapSettings>, QuickSnapSettings>,
              AsyncValue<QuickSnapSettings>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentTheme)
final currentThemeProvider = CurrentThemeProvider._();

final class CurrentThemeProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  CurrentThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return currentTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$currentThemeHash() => r'10375e7c4f4e387b0c459fdca925741c72b10b6f';

@ProviderFor(currentAutoFocus)
final currentAutoFocusProvider = CurrentAutoFocusProvider._();

final class CurrentAutoFocusProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CurrentAutoFocusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAutoFocusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAutoFocusHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return currentAutoFocus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$currentAutoFocusHash() => r'65c97eac16603ec529b69dd194454cfbb09bdcf4';

@ProviderFor(currentEditorExpand)
final currentEditorExpandProvider = CurrentEditorExpandProvider._();

final class CurrentEditorExpandProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CurrentEditorExpandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEditorExpandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEditorExpandHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return currentEditorExpand(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$currentEditorExpandHash() =>
    r'456df88534a0d70af1899f6487a4de76d558f8d4';

@ProviderFor(currentDisableClipboard)
final currentDisableClipboardProvider = CurrentDisableClipboardProvider._();

final class CurrentDisableClipboardProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CurrentDisableClipboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDisableClipboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDisableClipboardHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return currentDisableClipboard(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$currentDisableClipboardHash() =>
    r'bfa5462f6b78c07d0c333549025eb2c7901b8c22';

@ProviderFor(currentEditorScrollable)
final currentEditorScrollableProvider = CurrentEditorScrollableProvider._();

final class CurrentEditorScrollableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CurrentEditorScrollableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEditorScrollableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEditorScrollableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return currentEditorScrollable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$currentEditorScrollableHash() =>
    r'002e2f40db7552edccecd3f8e243764cdcd2b59a';

@ProviderFor(currentEditorPadding)
final currentEditorPaddingProvider = CurrentEditorPaddingProvider._();

final class CurrentEditorPaddingProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  CurrentEditorPaddingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEditorPaddingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEditorPaddingHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return currentEditorPadding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$currentEditorPaddingHash() =>
    r'b7103743dd35f8437655267da0422b23a6873a7c';
