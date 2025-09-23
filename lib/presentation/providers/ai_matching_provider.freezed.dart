// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_matching_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AIMatchingState {
  List<AIMatch> get matches => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isGenerating => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get currentServiceRequestId => throw _privateConstructorUsedError;

  /// Create a copy of AIMatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIMatchingStateCopyWith<AIMatchingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIMatchingStateCopyWith<$Res> {
  factory $AIMatchingStateCopyWith(
    AIMatchingState value,
    $Res Function(AIMatchingState) then,
  ) = _$AIMatchingStateCopyWithImpl<$Res, AIMatchingState>;
  @useResult
  $Res call({
    List<AIMatch> matches,
    bool isLoading,
    bool isGenerating,
    String? error,
    String? currentServiceRequestId,
  });
}

/// @nodoc
class _$AIMatchingStateCopyWithImpl<$Res, $Val extends AIMatchingState>
    implements $AIMatchingStateCopyWith<$Res> {
  _$AIMatchingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIMatchingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matches = null,
    Object? isLoading = null,
    Object? isGenerating = null,
    Object? error = freezed,
    Object? currentServiceRequestId = freezed,
  }) {
    return _then(
      _value.copyWith(
            matches:
                null == matches
                    ? _value.matches
                    : matches // ignore: cast_nullable_to_non_nullable
                        as List<AIMatch>,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isGenerating:
                null == isGenerating
                    ? _value.isGenerating
                    : isGenerating // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentServiceRequestId:
                freezed == currentServiceRequestId
                    ? _value.currentServiceRequestId
                    : currentServiceRequestId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIMatchingStateImplCopyWith<$Res>
    implements $AIMatchingStateCopyWith<$Res> {
  factory _$$AIMatchingStateImplCopyWith(
    _$AIMatchingStateImpl value,
    $Res Function(_$AIMatchingStateImpl) then,
  ) = __$$AIMatchingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<AIMatch> matches,
    bool isLoading,
    bool isGenerating,
    String? error,
    String? currentServiceRequestId,
  });
}

/// @nodoc
class __$$AIMatchingStateImplCopyWithImpl<$Res>
    extends _$AIMatchingStateCopyWithImpl<$Res, _$AIMatchingStateImpl>
    implements _$$AIMatchingStateImplCopyWith<$Res> {
  __$$AIMatchingStateImplCopyWithImpl(
    _$AIMatchingStateImpl _value,
    $Res Function(_$AIMatchingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIMatchingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matches = null,
    Object? isLoading = null,
    Object? isGenerating = null,
    Object? error = freezed,
    Object? currentServiceRequestId = freezed,
  }) {
    return _then(
      _$AIMatchingStateImpl(
        matches:
            null == matches
                ? _value._matches
                : matches // ignore: cast_nullable_to_non_nullable
                    as List<AIMatch>,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isGenerating:
            null == isGenerating
                ? _value.isGenerating
                : isGenerating // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentServiceRequestId:
            freezed == currentServiceRequestId
                ? _value.currentServiceRequestId
                : currentServiceRequestId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$AIMatchingStateImpl implements _AIMatchingState {
  const _$AIMatchingStateImpl({
    final List<AIMatch> matches = const [],
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
    this.currentServiceRequestId,
  }) : _matches = matches;

  final List<AIMatch> _matches;
  @override
  @JsonKey()
  List<AIMatch> get matches {
    if (_matches is EqualUnmodifiableListView) return _matches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matches);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isGenerating;
  @override
  final String? error;
  @override
  final String? currentServiceRequestId;

  @override
  String toString() {
    return 'AIMatchingState(matches: $matches, isLoading: $isLoading, isGenerating: $isGenerating, error: $error, currentServiceRequestId: $currentServiceRequestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIMatchingStateImpl &&
            const DeepCollectionEquality().equals(other._matches, _matches) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isGenerating, isGenerating) ||
                other.isGenerating == isGenerating) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(
                  other.currentServiceRequestId,
                  currentServiceRequestId,
                ) ||
                other.currentServiceRequestId == currentServiceRequestId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_matches),
    isLoading,
    isGenerating,
    error,
    currentServiceRequestId,
  );

  /// Create a copy of AIMatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIMatchingStateImplCopyWith<_$AIMatchingStateImpl> get copyWith =>
      __$$AIMatchingStateImplCopyWithImpl<_$AIMatchingStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AIMatchingState implements AIMatchingState {
  const factory _AIMatchingState({
    final List<AIMatch> matches,
    final bool isLoading,
    final bool isGenerating,
    final String? error,
    final String? currentServiceRequestId,
  }) = _$AIMatchingStateImpl;

  @override
  List<AIMatch> get matches;
  @override
  bool get isLoading;
  @override
  bool get isGenerating;
  @override
  String? get error;
  @override
  String? get currentServiceRequestId;

  /// Create a copy of AIMatchingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIMatchingStateImplCopyWith<_$AIMatchingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
