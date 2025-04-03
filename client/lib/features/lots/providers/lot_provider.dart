import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';
part 'lot_provider.g.dart';

@Riverpod(keepAlive: true)
class Lots extends _$Lots {
  @override
  Future<List<Lot>> build(int? projectId) async {
    try {
      // Check if projectId is null
      if (projectId == null) {
        print("Project ID is null. Cannot fetch lots.");
        return []; // No project ID provided
      }
      final lotsData =
          await supabase
                  .from('lots')
                  .select('id, title, number, provider')
                  .eq('project_id', projectId)
                  .order('id', ascending: true)
              as List<dynamic>;

      if (lotsData.isEmpty) {
        print("No lots found for project ID: $projectId.");
        return []; // No lots for this project
      }

      // Parse Lots and extract IDs
      final List<Lot> lots = [];
      final List<int> lotIds = [];
      for (var lotJson in lotsData) {
        lots.add(Lot.fromJson(lotJson as Map<String, dynamic>));
        lotIds.add(lotJson['id'] as int);
      }
      print("Fetched ${lots.length} lots for project $projectId with IDs: $lotIds");

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

      print("Successfully combined lots and items for project $projectId.");
      return combinedLots;
    } on PostgrestException catch (e, stackTrace) {
      print('Supabase Error fetching lots/items for project $projectId: ${e.message}');
      print(stackTrace);
      throw Exception('Failed to load data for project: ${e.message}');
    } catch (e, stackTrace) {
      print('Error in Lots provider for project $projectId: $e');
      print(stackTrace);
      throw Exception('An unexpected error occurred while fetching lots for project');
    }
  }

  // Refresh method remains the same
  void refreshLots() {
    ref.invalidateSelf();
  }

  Future<void> createLot(int projectId, Map<String, dynamic> data) async {
    try {
      // Add the project_id to the data to be inserted
      final insertData = {...data, 'project_id': projectId};

      // Perform the insert in the database
      final List<dynamic> newLotData = await supabase
          .from('lots')
          .insert(insertData)
          .select('id, title, number, provider'); // Select the newly created lot basic info

      if (newLotData.isEmpty) {
        throw Exception('Failed to create lot - no data returned.');
      }

      // Parse the newly created lot (without items initially)
      final newLot = Lot.fromJson(newLotData.first as Map<String, dynamic>);

      // --- Update State ---
      // Get current state or empty list if null/error
      final currentLots = state.valueOrNull ?? [];
      // Add the new lot
      final updatedLots = [...currentLots, newLot];
      // Update the state
      state = AsyncValue.data(updatedLots);

      // Optionally, you could invalidate the whole provider,
      // but manual update is often faster UI-wise
      // ref.invalidateSelf();
    } on PostgrestException catch (e) {
      print('Supabase Error creating lot for project $projectId: ${e.message}');
      throw Exception('Failed to create lot: ${e.message}');
    } catch (e) {
      print('Error creating lot: $e');
      // Optionally invalidate state on error to force a refetch
      ref.invalidateSelf();
      rethrow;
    }
  }

  // Update a Lot's fields
  Future<void> updateLot(int lotId, Map<String, dynamic> fields) async {
    try {
      // Get current state
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistically update UI
      final updatedLots =
          currentLots.map((lot) {
            if (lot.id == lotId) {
              // Create a copy with updated fields
              return lot.copyWith(
                title: fields['title'] ?? lot.title,
                number: fields['number'] ?? lot.number,
                provider: fields['provider'] ?? lot.provider,
              );
            }
            return lot;
          }).toList();

      // Update state optimistically
      state = AsyncValue.data(updatedLots);

      // Perform the update in the database
      await supabase.from('lots').update(fields).eq('id', lotId);

      // No need to refresh state since we've already updated it optimistically
    } catch (e) {
      print('Error updating lot: $e');
      // Revert to previous state on error
      refreshLots();
      rethrow;
    }
  }

  // Update a LotItem's fields
  Future<void> updateLotItem(int itemId, Map<String, dynamic> fields) async {
    try {
      // Get current state
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Find the lot containing this item
      final List<Lot> updatedLots =
          currentLots.map((lot) {
            // If this lot contains the item we're updating
            final updatedItems =
                lot.items.map((item) {
                  if (item.id == itemId) {
                    // Create a copy with updated fields
                    return item.copyWith(
                      title: fields['title'] ?? item.title,
                      quantity: fields['quantity'] ?? item.quantity,
                      endManufacturingDate:
                          fields['end_manufacturing_date'] != null
                              ? DateTime.parse(fields['end_manufacturing_date'])
                              : item.endManufacturingDate,
                      readyToShipDate:
                          fields['ready_to_ship_date'] != null
                              ? DateTime.parse(fields['ready_to_ship_date'])
                              : item.readyToShipDate,
                      plannedDeliveryDate:
                          fields['planned_delivery_date'] != null
                              ? DateTime.parse(fields['planned_delivery_date'])
                              : item.plannedDeliveryDate,
                      requiredOnSiteDate:
                          fields['required_on_site_date'] != null
                              ? DateTime.parse(fields['required_on_site_date'])
                              : item.requiredOnSiteDate,
                      purchasingProgress: fields['purchasing_progress'] ?? item.purchasingProgress,
                      engineeringProgress: fields['engineering_progress'] ?? item.engineeringProgress,
                      manufacturingProgress: fields['manufacturing_progress'] ?? item.manufacturingProgress,
                      originCountry: fields['origin_country'] ?? item.originCountry,
                      incoterms:
                          fields['incoterms'] != null ? Incoterm.fromString(fields['incoterms']) : item.incoterms,
                      comments: fields['comments'] ?? item.comments,
                      status: fields['status'] != null ? Status.fromString(fields['status']) : item.status,
                    );
                  }
                  return item;
                }).toList();

            // If we found and updated the item in this lot
            if (updatedItems.any((item) => item.id == itemId)) {
              return lot.copyWith(items: updatedItems);
            }

            return lot;
          }).toList();

      // Update state optimistically
      state = AsyncValue.data(updatedLots);

      // Perform the update in the database
      await supabase.from('lot_items').update(fields).eq('id', itemId);

      // No need to refresh state since we've already updated it optimistically
    } catch (e) {
      print('Error updating lot item: $e');
      // Revert to previous state on error
      refreshLots();
      rethrow;
    }
  }
}
