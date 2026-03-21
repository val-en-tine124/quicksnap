// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickSnapSettings {

 ThemeMode get theme; bool get autoFocus; bool get expands; bool get disableClipboard; bool get scrollable; double get padding;
/// Create a copy of QuickSnapSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickSnapSettingsCopyWith<QuickSnapSettings> get copyWith => _$QuickSnapSettingsCopyWithImpl<QuickSnapSettings>(this as QuickSnapSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickSnapSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.autoFocus, autoFocus) || other.autoFocus == autoFocus)&&(identical(other.expands, expands) || other.expands == expands)&&(identical(other.disableClipboard, disableClipboard) || other.disableClipboard == disableClipboard)&&(identical(other.scrollable, scrollable) || other.scrollable == scrollable)&&(identical(other.padding, padding) || other.padding == padding));
}


@override
int get hashCode => Object.hash(runtimeType,theme,autoFocus,expands,disableClipboard,scrollable,padding);

@override
String toString() {
  return 'QuickSnapSettings(theme: $theme, autoFocus: $autoFocus, expands: $expands, disableClipboard: $disableClipboard, scrollable: $scrollable, padding: $padding)';
}


}

/// @nodoc
abstract mixin class $QuickSnapSettingsCopyWith<$Res>  {
  factory $QuickSnapSettingsCopyWith(QuickSnapSettings value, $Res Function(QuickSnapSettings) _then) = _$QuickSnapSettingsCopyWithImpl;
@useResult
$Res call({
 ThemeMode theme, bool autoFocus, bool expands, bool disableClipboard, bool scrollable, double padding
});




}
/// @nodoc
class _$QuickSnapSettingsCopyWithImpl<$Res>
    implements $QuickSnapSettingsCopyWith<$Res> {
  _$QuickSnapSettingsCopyWithImpl(this._self, this._then);

  final QuickSnapSettings _self;
  final $Res Function(QuickSnapSettings) _then;

/// Create a copy of QuickSnapSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? autoFocus = null,Object? expands = null,Object? disableClipboard = null,Object? scrollable = null,Object? padding = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode,autoFocus: null == autoFocus ? _self.autoFocus : autoFocus // ignore: cast_nullable_to_non_nullable
as bool,expands: null == expands ? _self.expands : expands // ignore: cast_nullable_to_non_nullable
as bool,disableClipboard: null == disableClipboard ? _self.disableClipboard : disableClipboard // ignore: cast_nullable_to_non_nullable
as bool,scrollable: null == scrollable ? _self.scrollable : scrollable // ignore: cast_nullable_to_non_nullable
as bool,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickSnapSettings].
extension QuickSnapSettingsPatterns on QuickSnapSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickSnapSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickSnapSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickSnapSettings value)  $default,){
final _that = this;
switch (_that) {
case _QuickSnapSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickSnapSettings value)?  $default,){
final _that = this;
switch (_that) {
case _QuickSnapSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode theme,  bool autoFocus,  bool expands,  bool disableClipboard,  bool scrollable,  double padding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickSnapSettings() when $default != null:
return $default(_that.theme,_that.autoFocus,_that.expands,_that.disableClipboard,_that.scrollable,_that.padding);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode theme,  bool autoFocus,  bool expands,  bool disableClipboard,  bool scrollable,  double padding)  $default,) {final _that = this;
switch (_that) {
case _QuickSnapSettings():
return $default(_that.theme,_that.autoFocus,_that.expands,_that.disableClipboard,_that.scrollable,_that.padding);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode theme,  bool autoFocus,  bool expands,  bool disableClipboard,  bool scrollable,  double padding)?  $default,) {final _that = this;
switch (_that) {
case _QuickSnapSettings() when $default != null:
return $default(_that.theme,_that.autoFocus,_that.expands,_that.disableClipboard,_that.scrollable,_that.padding);case _:
  return null;

}
}

}

/// @nodoc


class _QuickSnapSettings extends QuickSnapSettings {
  const _QuickSnapSettings({this.theme = ThemeMode.system, this.autoFocus = true, this.expands = true, this.disableClipboard = false, this.scrollable = true, this.padding = 0.0}): super._();
  

@override@JsonKey() final  ThemeMode theme;
@override@JsonKey() final  bool autoFocus;
@override@JsonKey() final  bool expands;
@override@JsonKey() final  bool disableClipboard;
@override@JsonKey() final  bool scrollable;
@override@JsonKey() final  double padding;

/// Create a copy of QuickSnapSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickSnapSettingsCopyWith<_QuickSnapSettings> get copyWith => __$QuickSnapSettingsCopyWithImpl<_QuickSnapSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickSnapSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.autoFocus, autoFocus) || other.autoFocus == autoFocus)&&(identical(other.expands, expands) || other.expands == expands)&&(identical(other.disableClipboard, disableClipboard) || other.disableClipboard == disableClipboard)&&(identical(other.scrollable, scrollable) || other.scrollable == scrollable)&&(identical(other.padding, padding) || other.padding == padding));
}


@override
int get hashCode => Object.hash(runtimeType,theme,autoFocus,expands,disableClipboard,scrollable,padding);

@override
String toString() {
  return 'QuickSnapSettings(theme: $theme, autoFocus: $autoFocus, expands: $expands, disableClipboard: $disableClipboard, scrollable: $scrollable, padding: $padding)';
}


}

/// @nodoc
abstract mixin class _$QuickSnapSettingsCopyWith<$Res> implements $QuickSnapSettingsCopyWith<$Res> {
  factory _$QuickSnapSettingsCopyWith(_QuickSnapSettings value, $Res Function(_QuickSnapSettings) _then) = __$QuickSnapSettingsCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode theme, bool autoFocus, bool expands, bool disableClipboard, bool scrollable, double padding
});




}
/// @nodoc
class __$QuickSnapSettingsCopyWithImpl<$Res>
    implements _$QuickSnapSettingsCopyWith<$Res> {
  __$QuickSnapSettingsCopyWithImpl(this._self, this._then);

  final _QuickSnapSettings _self;
  final $Res Function(_QuickSnapSettings) _then;

/// Create a copy of QuickSnapSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? autoFocus = null,Object? expands = null,Object? disableClipboard = null,Object? scrollable = null,Object? padding = null,}) {
  return _then(_QuickSnapSettings(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode,autoFocus: null == autoFocus ? _self.autoFocus : autoFocus // ignore: cast_nullable_to_non_nullable
as bool,expands: null == expands ? _self.expands : expands // ignore: cast_nullable_to_non_nullable
as bool,disableClipboard: null == disableClipboard ? _self.disableClipboard : disableClipboard // ignore: cast_nullable_to_non_nullable
as bool,scrollable: null == scrollable ? _self.scrollable : scrollable // ignore: cast_nullable_to_non_nullable
as bool,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
