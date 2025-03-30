import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/providers/current_project_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';
part 'lot_provider.g.dart';

@Riverpod(keepAlive: true)
class Lots extends _$Lots {
  @override
  Future<List<Lot>> build() async {
    // --- Watch the selected project ID ---
    final currentProjectId = ref.watch(currentProjectProviderProvider);
    print("Lots provider building for project ID: $currentProjectId");

    // --- If no project is current, return empty list ---
    if (currentProjectId == null) {
      print("No project selected, returning empty list.");
      // Or you could throw an error, depending on desired UI behaviour
      return [];
    }

    // --- Fetch data only if a project ID is selected ---
    try {
      // 1. Fetch Lots for the selected project
      final lotsData =
          await supabase
                  .from('lots')
                  .select('id, title, number, provider') // Keep minimal fields
                  .eq('project_id', currentProjectId) // <-- FILTER ADDED HERE
                  .order('id', ascending: true)
              as List<dynamic>;

      if (lotsData.isEmpty) {
        print("No lots found for project ID: $currentProjectId.");
        return []; // No lots for this project
      }

      // Parse Lots and extract IDs
      final List<Lot> lots = [];
      final List<int> lotIds = [];
      for (var lotJson in lotsData) {
        lots.add(Lot.fromJson(lotJson as Map<String, dynamic>));
        lotIds.add(lotJson['id'] as int);
      }
      print("Fetched ${lots.length} lots for project $currentProjectId with IDs: $lotIds");

      // If there are no lot IDs, no need to fetch items
      if (lotIds.isEmpty) {
        print("No lot IDs to fetch items for.");
        return lots; // Return the lots list (which might be empty if lotsData was non-empty but parsing failed somehow, though unlikely)
      }

      // 2. Fetch LotItems for the retrieved Lot IDs (only necessary fields)
      final itemsData =
          await supabase
                  .from('lot_items')
                  .select(
                    'id, parent_lot_id, title, quantity, end_manufacturing_date, '
                    'ready_to_ship_date, planned_delivery_date, purchasing_progress, '
                    'engineering_progress, manufacturing_progress, origin_country, '
                    'incoterms, comments, required_on_site_date, status',
                  )
                  .filter('parent_lot_id', 'in', '(${lotIds.join(',')})') // <-- FILTER ADDED HERE
              as List<dynamic>;

      // Parse items
      final List<LotItem> allItems =
          itemsData.map((itemJson) => LotItem.fromJson(itemJson as Map<String, dynamic>)).toList();
      print("Fetched ${allItems.length} items for these lots.");

      // 3. Group Items by parent_lot_id
      final itemsGroupedByLotId = groupBy(allItems, (LotItem item) => item.parentLotId);

      // 4. Combine Lots with their respective Items
      final List<Lot> combinedLots =
          lots.map((lot) {
            final List<LotItem> lotItems = itemsGroupedByLotId[lot.id] ?? [];
            return lot.copyWith(items: lotItems);
          }).toList();

      print("Successfully combined lots and items for project $currentProjectId.");
      return combinedLots;
    } on PostgrestException catch (e, stackTrace) {
      print('Supabase Error fetching lots/items for project $currentProjectId: ${e.message}');
      print(stackTrace);
      throw Exception('Failed to load data for project: ${e.message}');
    } catch (e, stackTrace) {
      print('Error in Lots provider for project $currentProjectId: $e');
      print(stackTrace);
      throw Exception('An unexpected error occurred while fetching lots for project');
    }
  }

  // Refresh method remains the same
  Future<void> refreshLots() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
