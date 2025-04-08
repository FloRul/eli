// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyAccessHash() => r'150f3d8c8e5e3c7963c8dc644bd7d7680a369ca4';

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

/// See also [companyAccess].
@ProviderFor(companyAccess)
const companyAccessProvider = CompanyAccessFamily();

/// See also [companyAccess].
class CompanyAccessFamily extends Family<AsyncValue<List<UserCompanyAccess>>> {
  /// See also [companyAccess].
  const CompanyAccessFamily();

  /// See also [companyAccess].
  CompanyAccessProvider call(int companyId) {
    return CompanyAccessProvider(companyId);
  }

  @override
  CompanyAccessProvider getProviderOverride(
    covariant CompanyAccessProvider provider,
  ) {
    return call(provider.companyId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'companyAccessProvider';
}

/// See also [companyAccess].
class CompanyAccessProvider
    extends AutoDisposeFutureProvider<List<UserCompanyAccess>> {
  /// See also [companyAccess].
  CompanyAccessProvider(int companyId)
    : this._internal(
        (ref) => companyAccess(ref as CompanyAccessRef, companyId),
        from: companyAccessProvider,
        name: r'companyAccessProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$companyAccessHash,
        dependencies: CompanyAccessFamily._dependencies,
        allTransitiveDependencies:
            CompanyAccessFamily._allTransitiveDependencies,
        companyId: companyId,
      );

  CompanyAccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final int companyId;

  @override
  Override overrideWith(
    FutureOr<List<UserCompanyAccess>> Function(CompanyAccessRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyAccessProvider._internal(
        (ref) => create(ref as CompanyAccessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserCompanyAccess>> createElement() {
    return _CompanyAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyAccessProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompanyAccessRef
    on AutoDisposeFutureProviderRef<List<UserCompanyAccess>> {
  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _CompanyAccessProviderElement
    extends AutoDisposeFutureProviderElement<List<UserCompanyAccess>>
    with CompanyAccessRef {
  _CompanyAccessProviderElement(super.provider);

  @override
  int get companyId => (origin as CompanyAccessProvider).companyId;
}

String _$projectAccessHash() => r'9ef8cb05faf4fa68dccf00bcb6c2373ae200fcc3';

/// See also [projectAccess].
@ProviderFor(projectAccess)
const projectAccessProvider = ProjectAccessFamily();

/// See also [projectAccess].
class ProjectAccessFamily extends Family<AsyncValue<List<UserProjectAccess>>> {
  /// See also [projectAccess].
  const ProjectAccessFamily();

  /// See also [projectAccess].
  ProjectAccessProvider call(int projectId) {
    return ProjectAccessProvider(projectId);
  }

  @override
  ProjectAccessProvider getProviderOverride(
    covariant ProjectAccessProvider provider,
  ) {
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
  String? get name => r'projectAccessProvider';
}

/// See also [projectAccess].
class ProjectAccessProvider
    extends AutoDisposeFutureProvider<List<UserProjectAccess>> {
  /// See also [projectAccess].
  ProjectAccessProvider(int projectId)
    : this._internal(
        (ref) => projectAccess(ref as ProjectAccessRef, projectId),
        from: projectAccessProvider,
        name: r'projectAccessProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$projectAccessHash,
        dependencies: ProjectAccessFamily._dependencies,
        allTransitiveDependencies:
            ProjectAccessFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectAccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final int projectId;

  @override
  Override overrideWith(
    FutureOr<List<UserProjectAccess>> Function(ProjectAccessRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectAccessProvider._internal(
        (ref) => create(ref as ProjectAccessRef),
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
  AutoDisposeFutureProviderElement<List<UserProjectAccess>> createElement() {
    return _ProjectAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectAccessProvider && other.projectId == projectId;
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
mixin ProjectAccessRef
    on AutoDisposeFutureProviderRef<List<UserProjectAccess>> {
  /// The parameter `projectId` of this provider.
  int get projectId;
}

class _ProjectAccessProviderElement
    extends AutoDisposeFutureProviderElement<List<UserProjectAccess>>
    with ProjectAccessRef {
  _ProjectAccessProviderElement(super.provider);

  @override
  int get projectId => (origin as ProjectAccessProvider).projectId;
}

String _$companiesNotifierHash() => r'e437cd9ba24d5d06f9bc62fd27399e2f11ff2493';

/// See also [CompaniesNotifier].
@ProviderFor(CompaniesNotifier)
final companiesNotifierProvider =
    AsyncNotifierProvider<CompaniesNotifier, List<Company>>.internal(
      CompaniesNotifier.new,
      name: r'companiesNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companiesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CompaniesNotifier = AsyncNotifier<List<Company>>;
String _$tenantUsersNotifierHash() =>
    r'93460e077810a5ba30be7cc178365fd09ffe8c6d';

/// See also [TenantUsersNotifier].
@ProviderFor(TenantUsersNotifier)
final tenantUsersNotifierProvider = AutoDisposeAsyncNotifierProvider<
  TenantUsersNotifier,
  List<TenantUser>
>.internal(
  TenantUsersNotifier.new,
  name: r'tenantUsersNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tenantUsersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TenantUsersNotifier = AutoDisposeAsyncNotifier<List<TenantUser>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
