// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsHash() => r'ad8d35eb83ccd729935c683e62ea567370bf22bb';

/// See also [projects].
@ProviderFor(projects)
final projectsProvider = FutureProvider<List<(int, String)>>.internal(
  projects,
  name: r'projectsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$projectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectsRef = FutureProviderRef<List<(int, String)>>;
String _$currentProjectNotifierHash() =>
    r'9887e3dabe770a20eccf23e812b5f2e9764ae78f';

/// See also [CurrentProjectNotifier].
@ProviderFor(CurrentProjectNotifier)
final currentProjectNotifierProvider =
    NotifierProvider<CurrentProjectNotifier, int?>.internal(
      CurrentProjectNotifier.new,
      name: r'currentProjectNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentProjectNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentProjectNotifier = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
