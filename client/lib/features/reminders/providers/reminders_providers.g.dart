// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminders_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reminderByIdHash() => r'ea50bd61a656c34ab7144543a8c71a0665e7dd6f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [reminderById].
@ProviderFor(reminderById)
const reminderByIdProvider = ReminderByIdFamily();

/// See also [reminderById].
class ReminderByIdFamily extends Family<AsyncValue<Reminder?>> {
  /// See also [reminderById].
  const ReminderByIdFamily();

  /// See also [reminderById].
  ReminderByIdProvider call(int id) {
    return ReminderByIdProvider(id);
  }

  @override
  ReminderByIdProvider getProviderOverride(
    covariant ReminderByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reminderByIdProvider';
}

/// See also [reminderById].
class ReminderByIdProvider extends AutoDisposeFutureProvider<Reminder?> {
  /// See also [reminderById].
  ReminderByIdProvider(int id)
    : this._internal(
        (ref) => reminderById(ref as ReminderByIdRef, id),
        from: reminderByIdProvider,
        name: r'reminderByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$reminderByIdHash,
        dependencies: ReminderByIdFamily._dependencies,
        allTransitiveDependencies:
            ReminderByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ReminderByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Reminder?> Function(ReminderByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReminderByIdProvider._internal(
        (ref) => create(ref as ReminderByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Reminder?> createElement() {
    return _ReminderByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReminderByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReminderByIdRef on AutoDisposeFutureProviderRef<Reminder?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ReminderByIdProviderElement
    extends AutoDisposeFutureProviderElement<Reminder?>
    with ReminderByIdRef {
  _ReminderByIdProviderElement(super.provider);

  @override
  int get id => (origin as ReminderByIdProvider).id;
}

String _$remindersNotifierHash() => r'ecd49e4c6a649b1acd25638c1b4f38ad29967ff8';

abstract class _$RemindersNotifier
    extends BuildlessAsyncNotifier<List<Reminder>> {
  late final ReminderFilters filters;

  FutureOr<List<Reminder>> build(ReminderFilters filters);
}

/// See also [RemindersNotifier].
@ProviderFor(RemindersNotifier)
const remindersNotifierProvider = RemindersNotifierFamily();

/// See also [RemindersNotifier].
class RemindersNotifierFamily extends Family<AsyncValue<List<Reminder>>> {
  /// See also [RemindersNotifier].
  const RemindersNotifierFamily();

  /// See also [RemindersNotifier].
  RemindersNotifierProvider call(ReminderFilters filters) {
    return RemindersNotifierProvider(filters);
  }

  @override
  RemindersNotifierProvider getProviderOverride(
    covariant RemindersNotifierProvider provider,
  ) {
    return call(provider.filters);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'remindersNotifierProvider';
}

/// See also [RemindersNotifier].
class RemindersNotifierProvider
    extends AsyncNotifierProviderImpl<RemindersNotifier, List<Reminder>> {
  /// See also [RemindersNotifier].
  RemindersNotifierProvider(ReminderFilters filters)
    : this._internal(
        () => RemindersNotifier()..filters = filters,
        from: remindersNotifierProvider,
        name: r'remindersNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$remindersNotifierHash,
        dependencies: RemindersNotifierFamily._dependencies,
        allTransitiveDependencies:
            RemindersNotifierFamily._allTransitiveDependencies,
        filters: filters,
      );

  RemindersNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filters,
  }) : super.internal();

  final ReminderFilters filters;

  @override
  FutureOr<List<Reminder>> runNotifierBuild(
    covariant RemindersNotifier notifier,
  ) {
    return notifier.build(filters);
  }

  @override
  Override overrideWith(RemindersNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RemindersNotifierProvider._internal(
        () => create()..filters = filters,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filters: filters,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<RemindersNotifier, List<Reminder>>
  createElement() {
    return _RemindersNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemindersNotifierProvider && other.filters == filters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filters.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RemindersNotifierRef on AsyncNotifierProviderRef<List<Reminder>> {
  /// The parameter `filters` of this provider.
  ReminderFilters get filters;
}

class _RemindersNotifierProviderElement
    extends AsyncNotifierProviderElement<RemindersNotifier, List<Reminder>>
    with RemindersNotifierRef {
  _RemindersNotifierProviderElement(super.provider);

  @override
  ReminderFilters get filters => (origin as RemindersNotifierProvider).filters;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
