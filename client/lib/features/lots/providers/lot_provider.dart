import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/deliverable.dart';
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
    // Use a local variable for the Supabase client if needed
    final supabase = Supabase.instance.client;

    try {
      // 1. Fetch Lots
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
        // Initialize Lot without items/deliverables first
        lots.add(Lot.fromJson(lotJson as Map<String, dynamic>));
        lotIds.add(lotJson['id'] as int);
      }
      print("Fetched ${lots.length} lots for project $projectId with IDs: $lotIds");

      // If there are no lot IDs, no need to fetch items or deliverables
      if (lotIds.isEmpty) {
        print("No lot IDs to fetch items or deliverables for.");
        // Return the lots list (which might be empty or contain lots without sub-items)
        return lots;
      }

      // --- Fetch Items (Existing Logic) ---
      print("Fetching items for lot IDs: $lotIds");
      final itemsData =
          await supabase
                  .from('lot_items')
                  .select(
                    'id, parent_lot_id, title, quantity, end_manufacturing_date, '
                    'ready_to_ship_date, planned_delivery_date, purchasing_progress, '
                    'engineering_progress, manufacturing_progress, origin_country, '
                    'incoterms, comments, required_on_site_date, status',
                  )
                  .filter('parent_lot_id', 'in', '(${lotIds.join(',')})')
              as List<dynamic>;

      // --- Fetch Deliverables (New Logic) ---
      print("Fetching deliverables for lot IDs: $lotIds");
      final deliverablesData =
          await supabase
                  .from('deliverables') // Use the correct table name from your Supabase schema
                  .select(
                    'id, title, due_date, is_received, parent_lot_id', // Select all needed fields + parent_lot_id
                  )
                  .filter('parent_lot_id', 'in', '(${lotIds.join(',')})')
              as List<dynamic>;

      // --- Parse Items and Deliverables ---
      final List<LotItem> allItems =
          itemsData.map((itemJson) => LotItem.fromJson(itemJson as Map<String, dynamic>)).toList();
      print("Fetched ${allItems.length} items for these lots.");

      // **Important:** For grouping deliverables, your Deliverable class needs access
      // to `parent_lot_id`. If it's not a direct field in the Dart class,
      // you might need to adjust the grouping logic or, preferably,
      // add `parentLotId` (or similar) to your Deliverable freezed class
      // and ensure `Deliverable.fromJson` handles the `parent_lot_id` key
      // from the JSON. Let's assume `Deliverable.fromJson` makes it accessible
      // somehow, perhaps via an intermediary field or directly.
      // If not, you'll need to modify the grouping below or the Deliverable class.
      // We also need to handle the `parent_lot_id` key during parsing.

      final List<Deliverable> allDeliverables = [];
      final Map<int, List<Deliverable>> deliverablesGroupedByLotId = {};

      for (var deliverableJson in deliverablesData) {
        final map = deliverableJson as Map<String, dynamic>;
        // Extract parent_lot_id before parsing if it's not in the Deliverable class
        final parentLotId = map['parent_lot_id'] as int?;
        if (parentLotId != null) {
          final deliverable = Deliverable.fromJson(map);
          allDeliverables.add(deliverable);
          // Group manually since groupBy might not work if parentLotId isn't a field
          (deliverablesGroupedByLotId[parentLotId] ??= []).add(deliverable);
        } else {
          print("Warning: Deliverable JSON missing parent_lot_id: $map");
        }
      }
      print("Fetched ${allDeliverables.length} deliverables for these lots.");

      // --- Group Items ---
      final itemsGroupedByLotId = groupBy(
        allItems,
        (LotItem item) => item.parentLotId,
      ); // Assuming LotItem has parentLotId

      // --- Combine Lots with their respective Items and Deliverables ---
      final List<Lot> combinedLots =
          lots.map((lot) {
            final List<LotItem> lotItems = itemsGroupedByLotId[lot.id] ?? [];
            final List<Deliverable> lotDeliverables = deliverablesGroupedByLotId[lot.id] ?? [];
            // Use copyWith to add both lists
            return lot.copyWith(items: lotItems, deliverables: lotDeliverables);
          }).toList();

      print("Successfully combined lots, items, and deliverables for project $projectId.");
      return combinedLots;
    } on PostgrestException catch (e, stackTrace) {
      print('Supabase Error fetching data for project $projectId: ${e.message}');
      print('Code: ${e.code}, Details: ${e.details}, Hint: ${e.hint}');
      print(stackTrace);
      // Consider more specific error handling or rethrowing a custom exception
      throw Exception('Failed to load data for project ${projectId ?? 'N/A'}: ${e.message}');
    } catch (e, stackTrace) {
      print('Error in Lots provider build method for project $projectId: $e');
      print(stackTrace);
      throw Exception('An unexpected error occurred while fetching data for project ${projectId ?? 'N/A'}');
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

  Future<void> createLotItem(int parentLotId, Map<String, dynamic> data) async {
    // Ensure parent_lot_id is in the map if not already added by the form
    final insertData = {...data, 'parent_lot_id': parentLotId};

    try {
      // Perform the insert in the database
      await supabase.from('lot_items').insert(insertData);

      // Invalidate the provider to trigger a refetch including the new item
      ref.invalidateSelf();
    } on PostgrestException catch (e) {
      print('Supabase Error creating lot item for lot $parentLotId: ${e.message}');
      throw Exception('Failed to create lot item: ${e.message}');
    } catch (e) {
      print('Error creating lot item: $e');
      // Optionally invalidate state on error too
      ref.invalidateSelf();
      rethrow;
    }
  }
}
