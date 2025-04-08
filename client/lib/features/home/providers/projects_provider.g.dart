// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsHash() => r'b0dbd7f53dec24b57a06907b4217702fbb8eab02';

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
    r'9447f1f80cff5149094522224abc20df4952d3e1';

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
