// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductListState {

 List<Product> get items; int get total; bool get isLoadingMore; bool get fromCache;
/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductListStateCopyWith<ProductListState> get copyWith => _$ProductListStateCopyWithImpl<ProductListState>(this as ProductListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductListState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.fromCache, _this.fromCache) || other.fromCache == _this.fromCache));
}


@override
int get hashCode {
  final _this = this as ProductListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.total,_this.isLoadingMore,_this.fromCache);
}

@override
String toString() {
  final _this = this as ProductListState;
  return 'ProductListState(items: ${_this.items}, total: ${_this.total}, isLoadingMore: ${_this.isLoadingMore}, fromCache: ${_this.fromCache})';
}


}

/// @nodoc
abstract mixin class $ProductListStateCopyWith<$Res>  {
  factory $ProductListStateCopyWith(ProductListState value, $Res Function(ProductListState) _then) = _$ProductListStateCopyWithImpl;
@useResult
$Res call({
 List<Product> items, int total, bool isLoadingMore, bool fromCache
});




}
/// @nodoc
class _$ProductListStateCopyWithImpl<$Res>
    implements $ProductListStateCopyWith<$Res> {
  _$ProductListStateCopyWithImpl(this._self, this._then);

  final ProductListState _self;
  final $Res Function(ProductListState) _then;

/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? isLoadingMore = null,Object? fromCache = null,}) {
  return _then(ProductListState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Product>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductListState].
extension ProductListStatePatterns on ProductListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductListState value)  $default,){
final _that = this;
switch (_that) {
case _ProductListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductListState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Product> items,  int total,  bool isLoadingMore,  bool fromCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
return $default(_that.items,_that.total,_that.isLoadingMore,_that.fromCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Product> items,  int total,  bool isLoadingMore,  bool fromCache)  $default,) {final _that = this;
switch (_that) {
case _ProductListState():
return $default(_that.items,_that.total,_that.isLoadingMore,_that.fromCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Product> items,  int total,  bool isLoadingMore,  bool fromCache)?  $default,) {final _that = this;
switch (_that) {
case _ProductListState() when $default != null:
return $default(_that.items,_that.total,_that.isLoadingMore,_that.fromCache);case _:
  return null;

}
}

}

/// @nodoc


class _ProductListState extends ProductListState {
  const _ProductListState({ List<Product> items = const [], this.total = 0, this.isLoadingMore = false, this.fromCache = false}): _items = items,super._();
  

 final  List<Product> _items;
@override@JsonKey() List<Product> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool fromCache;

/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductListStateCopyWith<_ProductListState> get copyWith => __$ProductListStateCopyWithImpl<_ProductListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductListState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,isLoadingMore,fromCache);
}

@override
String toString() {
    return 'ProductListState(items: $items, total: $total, isLoadingMore: $isLoadingMore, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class _$ProductListStateCopyWith<$Res> implements $ProductListStateCopyWith<$Res> {
  factory _$ProductListStateCopyWith(_ProductListState value, $Res Function(_ProductListState) _then) = __$ProductListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Product> items, int total, bool isLoadingMore, bool fromCache
});




}
/// @nodoc
class __$ProductListStateCopyWithImpl<$Res>
    implements _$ProductListStateCopyWith<$Res> {
  __$ProductListStateCopyWithImpl(this._self, this._then);

  final _ProductListState _self;
  final $Res Function(_ProductListState) _then;

/// Create a copy of ProductListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? isLoadingMore = null,Object? fromCache = null,}) {
  return _then(_ProductListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Product>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
