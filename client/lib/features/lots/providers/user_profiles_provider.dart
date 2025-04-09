import 'dart:async';

import 'package:client/features/lots/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
FutureOr<List<UserProfile>> userProfiles(Ref ref) {
  return [];
}
