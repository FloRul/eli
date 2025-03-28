import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/providers/current_project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lot_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Lot>> lots(Ref ref) async {
  var res = await supabase.from('lots').select().eq('project_id', ref.read(currentProjectProvider));
  return res.map((e) => Lot.fromJson(e)).toList();
}
