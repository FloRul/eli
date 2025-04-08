// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companiesHash() => r'a03d6b41c2e2e578e3e5e258894ae73ffe7daa1f';

/// See also [companies].
@ProviderFor(companies)
final companiesProvider = FutureProvider<List<(int, String)>>.internal(
  companies,
  name: r'companiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$companiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompaniesRef = FutureProviderRef<List<(int, String)>>;
String _$currentCompanyNotifierHash() =>
    r'e24c4baf38f36c0ee7f5815c1b8b9c1ef49c284c';

/// See also [CurrentCompanyNotifier].
@ProviderFor(CurrentCompanyNotifier)
final currentCompanyNotifierProvider =
    NotifierProvider<CurrentCompanyNotifier, int?>.internal(
      CurrentCompanyNotifier.new,
      name: r'currentCompanyNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentCompanyNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentCompanyNotifier = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
