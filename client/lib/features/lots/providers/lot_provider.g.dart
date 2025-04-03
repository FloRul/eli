// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lotsHash() => r'0485b48afdfce078e53cc18c4323197be3d85842';

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

abstract class _$Lots extends BuildlessAsyncNotifier<List<Lot>> {
  late final int? projectId;

  FutureOr<List<Lot>> build(int? projectId);
}

/// See also [Lots].
@ProviderFor(Lots)
const lotsProvider = LotsFamily();

/// See also [Lots].
class LotsFamily extends Family<AsyncValue<List<Lot>>> {
  /// See also [Lots].
  const LotsFamily();

  /// See also [Lots].
  LotsProvider call(int? projectId) {
    return LotsProvider(projectId);
  }

  @override
  LotsProvider getProviderOverride(covariant LotsProvider provider) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lotsProvider';
}

/// See also [Lots].
class LotsProvider extends AsyncNotifierProviderImpl<Lots, List<Lot>> {
  /// See also [Lots].
  LotsProvider(int? projectId)
    : this._internal(
        () => Lots()..projectId = projectId,
        from: lotsProvider,
        name: r'lotsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$lotsHash,
        dependencies: LotsFamily._dependencies,
        allTransitiveDependencies: LotsFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  LotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final int? projectId;

  @override
  FutureOr<List<Lot>> runNotifierBuild(covariant Lots notifier) {
    return notifier.build(projectId);
  }

  @override
  Override overrideWith(Lots Function() create) {
    return ProviderOverride(
      origin: this,
      override: LotsProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<Lots, List<Lot>> createElement() {
    return _LotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LotsProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LotsRef on AsyncNotifierProviderRef<List<Lot>> {
  /// The parameter `projectId` of this provider.
  int? get projectId;
}

class _LotsProviderElement extends AsyncNotifierProviderElement<Lots, List<Lot>>
    with LotsRef {
  _LotsProviderElement(super.provider);

  @override
  int? get projectId => (origin as LotsProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
