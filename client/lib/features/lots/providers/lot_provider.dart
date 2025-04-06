import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'lot_provider.g.dart';

@Riverpod(keepAlive: true)
class Lots extends _$Lots {
  // TODO: big chances this could be largely optimized by using a single query (join)
  @override
  Future<List<Lot>> build(int? projectId) async {
    if (projectId == null) {
      print("Project ID is null. Cannot fetch lots.");
      return []; // No project ID provided
    }

    // Use Supabase's query builder to fetch lots and related data
    // Select columns from 'lots' and all columns from related 'lot_items' and 'deliverables'
    final selectQuery = '''
      id, 
      title, 
      number, 
      provider,
      lot_items (
        id, parent_lot_id, title, quantity, end_manufacturing_date,
        ready_to_ship_date, planned_delivery_date, purchasing_progress,
        engineering_progress, manufacturing_progress, origin_country,
        incoterms, comments, required_on_site_date, status
      ),
      deliverables (
        id, title, due_date, is_received, parent_lot_id
      )
    ''';

    try {
      print("Fetching lots with items and deliverables for project ID: $projectId");
      final lotsData =
          await supabase
                  .from('lots')
                  .select(selectQuery) // Use the combined select query
                  .eq('project_id', projectId)
                  .order('id', ascending: true)
              as List<dynamic>;

      if (lotsData.isEmpty) {
        print("No lots found for project ID: $projectId.");
        return []; // No lots for this project
      }

      // Parse the combined data
      final List<Lot> combinedLots = [];
      for (var lotJson in lotsData) {
        final map = lotJson as Map<String, dynamic>;

        // Parse LotItems from the nested 'lot_items' list
        final List<LotItem> lotItems =
            (map['lot_items'] as List<dynamic>?)
                ?.map((itemJson) => LotItem.fromJson(itemJson as Map<String, dynamic>))
                .toList() ??
            [];

        // Parse Deliverables from the nested 'deliverables' list
        final List<Deliverable> lotDeliverables =
            (map['deliverables'] as List<dynamic>?)
                ?.map((delJson) => Deliverable.fromJson(delJson as Map<String, dynamic>))
                .toList() ??
            [];

        // Create the Lot object, manually adding the parsed items and deliverables
        // using copyWith because fromJson expects keys 'items'/'deliverables',
        // but Supabase returns keys matching table names 'lot_items'/'deliverables'.
        final lot = Lot(
          id: map['id'] as int,
          title: map['title'] as String,
          number: map['number'] as String,
          provider: map['provider'] as String,
        ); // Create Lot without items/deliverables first

        // Add the parsed items and deliverables using copyWith
        combinedLots.add(lot.copyWith(items: lotItems, deliverables: lotDeliverables));
      }

      print(
        "Successfully fetched and combined ${combinedLots.length} lots, "
        "${combinedLots.fold<int>(0, (sum, lot) => sum + lot.items.length)} items, and "
        "${combinedLots.fold<int>(0, (sum, lot) => sum + lot.deliverables.length)} deliverables "
        "for project $projectId using a single query.",
      );

      return combinedLots;
    } on PostgrestException catch (e, stackTrace) {
      print('Supabase Error fetching combined data for project $projectId: ${e.message}');
      print('Code: ${e.code}, Details: ${e.details}, Hint: ${e.hint}');
      print(stackTrace);
      throw Exception('Failed to load combined data for project $projectId: ${e.message}');
    } catch (e, stackTrace) {
      print('Error in Lots provider build method (single query) for project $projectId: $e');
      print(stackTrace);
      throw Exception('An unexpected error occurred while fetching combined data for project $projectId');
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

  Future<void> updateAllLotItemsStatus(int lotId, Status status) async {
    try {
      // Perform the update in the database
      await supabase.from('lot_items').update({'status': status.toString()}).eq('parent_lot_id', lotId);
      ref.invalidateSelf();
    } on PostgrestException catch (e) {
      print('Supabase Error updating lot items status for lot $lotId: ${e.message}');
      throw Exception('Failed to update lot items status: ${e.message}');
    } catch (e) {
      print('Error updating lot items status: $e');
      // Optionally invalidate state on error too
      ref.invalidateSelf();
      rethrow;
    }
  }
}
