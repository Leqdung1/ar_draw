import 'package:flutter/widgets.dart';

extension ListExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  T? lastWhereOrNull(bool Function(T) test) {
    for (final element in reversed) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  List<T> addOrUpdate(T element) {
    final index = indexWhere((e) => e == element);
    if (index == -1) {
      add(element);
    } else {
      this[index] = element;
    }
    return this;
  }

  List<T> addOrRemove(T element) {
    final index = indexWhere((e) => e == element);
    if (index == -1) {
      add(element);
    } else {
      removeAt(index);
    }
    return this;
  }

  /// if [T] is [num], return the max of all elements.
  /// only works for [num] type.
  T get max {
    if (T is! num) {
      throw Exception('$T must be num');
    }
    return reduce((value, element) =>
        (value as num) > (element as num) ? value : element);
  }

  /// if [T] is [num], return the min of all elements.
  /// only works for [num] type.
  T get min {
    if (T is! num) {
      throw Exception('$T must be num');
    }
    return reduce((value, element) =>
        (value as num) < (element as num) ? value : element);
  }

  List<Widget> withSeparator(Widget separator) {
    assert(T is! Widget, 'T must be Widget');
    if (isEmpty) {
      return [];
    }
    return expand<Widget>((e) => [e as Widget, separator]).toList()
      ..removeLast();
  }
}

extension NullableListExt<T> on List<T>? {
  bool get isBlank =>
      this == null || this!.isEmpty || !this!.any((e) => e != null);

  bool get isNotBlank => !isBlank;

  List<T> blankValue(List<T> value) => this.isBlank ? value : this!;
}

extension NullableMapExt<K, V> on Map<K, V>? {
  bool get isBlank =>
      this == null ||
      this!.isEmpty ||
      !this!.entries.any((e) => e.value != null);

  bool get isNotBlank => !isBlank;
}
