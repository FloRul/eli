import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_filter.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'lot_provider.g.dart';

@Riverpod(keepAlive: true)
class LotFilterNotifier extends _$LotFilterNotifier {
  @override
  LotFilter build() {
    return LotFilter.empty();
  }

  void setStatus(Status? newStatus) {
    state = state.copyWith(status: newStatus);
  }
}

@Riverpod(keepAlive: true)
FutureOr<List<Lot>> filteredLots(Ref ref) {
  return [];
}

@Riverpod(keepAlive: true)
class Lots extends _$Lots {
  @override
  FutureOr<List<Lot>> build(int? projectId) async {
    if (projectId == null) {
      print("Project ID is null. Cannot fetch lots.");
      return [];
    }
    const selectQuery = '''
      id, title, number, provider,
      lot_items (
        id, parent_lot_id, title, quantity, end_manufacturing_date,
        ready_to_ship_date, planned_delivery_date, purchasing_progress,
        engineering_progress, manufacturing_progress, origin_country,
        incoterms, comments, required_on_site_date, status
      ),
      deliverables (
        id, title, due_date, is_received, parent_lot_id
      ),
      user_profiles ( full_name, email, id )
    ''';
    try {
      final lotsData = await supabase.from('lots').select(selectQuery).eq('project_id', projectId) as List<dynamic>;

      if (lotsData.isEmpty) return [];

      final List<Lot> combinedLots = lotsData.map((lotJson) => Lot.fromJson(lotJson as Map<String, dynamic>)).toList();

      return combinedLots;
    } on PostgrestException catch (e, stackTrace) {
      print('Supabase Error fetching lots for project $projectId: ${e.message}');
      print(stackTrace);
      throw Exception('Failed to load lots: ${e.message}');
    } catch (e, stackTrace) {
      print('Error in Lots provider build method for project $projectId: $e');
      print(stackTrace);
      throw Exception('An unexpected error occurred while fetching lots');
    }
  }

  // --- Lot Management ---

  Future<Lot> createLot(Lot lotTemplate) async {
    final previousState = state;
    try {
      // Prepare data for Supabase: convert object to JSON, add project_id, remove potential id.
      final insertData =
          lotTemplate.toJson()
            ..remove('id') // Ensure ID isn't sent on creation
            ..remove('items') // Don't insert nested items/deliverables here
            ..remove('deliverables')
            ..remove('user_profiles') // Don't insert joined data
            ..addAll({'project_id': projectId}); // Add the foreign key

      // Insert and select the newly created lot (including potential joined data if needed)
      const selectFields = '''
        id, title, number, provider,
        user_profiles ( full_name, email )
      '''; // Select basic fields + profile
      final List<dynamic> newLotData = await supabase.from('lots').insert(insertData).select(selectFields);

      if (newLotData.isEmpty) {
        throw Exception('Failed to create lot - no data returned.');
      }

      // Parse the full lot object returned by the DB
      final createdLot = Lot.fromJson(newLotData.first as Map<String, dynamic>);
      createdLot.lotItems.clear(); // Ensure items list is empty initially
      createdLot.deliverables.clear(); // Ensure deliverables list is empty initially

      // Optimistic State Update
      final currentLots = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentLots, createdLot]);
      print("Optimistically added new lot: ${createdLot.id}");
      return createdLot; // Return the created object
    } on PostgrestException catch (e) {
      print('Supabase Error creating lot for project $projectId: ${e.message}');
      state = previousState; // Revert state
      throw Exception('Failed to create lot: ${e.message}');
    } catch (e) {
      print('Error creating lot: $e');
      state = previousState; // Revert state
      rethrow;
    }
  }

  /// Updates an existing Lot.
  /// Expects the full [updatedLot] object containing the desired state.
  Future<void> updateLot(Lot updatedLot) async {
    final previousState = state;
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI Update: Replace the old lot with the updated one
      bool found = false;
      final newLotsList =
          currentLots.map((lot) {
            if (lot.id == updatedLot.id) {
              found = true;
              // Replace directly, but keep original items/deliverables references
              // as this method only updates the Lot's own fields in the DB.
              // If the UI modified items/deliverables, separate update calls are needed for those.
              return updatedLot.copyWith(lotItems: lot.lotItems, deliverables: lot.deliverables);
            }
            return lot;
          }).toList();

      if (!found) {
        print("Lot ${updatedLot.id} not found in current state for update.");
        return;
      }

      state = AsyncValue.data(newLotsList);
      print("Optimistically updated lot: ${updatedLot.id}");

      // Prepare data for Supabase: Only include fields from the 'lots' table
      final updateData =
          updatedLot.toJson()
            ..remove('id') // Don't update the ID
            ..remove('items') // Don't update nested lists here
            ..remove('deliverables')
            ..remove('user_profiles'); // Don't update joined data

      // DB Update
      await supabase.from('lots').update(updateData).eq('id', updatedLot.id);
      print("Successfully updated lot ${updatedLot.id} in DB");
    } catch (e) {
      print('Error updating lot ${updatedLot.id}: $e');
      state = previousState; // Revert optimistic update
      rethrow;
    }
  }

  // --- LotItem Management ---

  /// Creates a new LotItem.
  /// Expects [newItem] object with `parentLotId` set, but `id` likely null/ignored.
  Future<LotItem> createLotItem(LotItem newItem) async {
    final previousState = state;
    try {
      // Prepare data: Convert to JSON, remove ID if present
      final insertData = newItem.toJson()..remove('id');

      // Validate parentLotId (optional but good practice)
      if (insertData['parent_lot_id'] == null) {
        throw ArgumentError("Cannot create LotItem without a parentLotId.");
      }
      final parentLotId = insertData['parent_lot_id'] as int;

      // Insert and select the full new item
      final List<dynamic> newItemData =
          await supabase.from('lot_items').insert(insertData).select(); // Select all columns

      if (newItemData.isEmpty) {
        throw Exception("Failed to create lot item - no data returned.");
      }
      final createdItem = LotItem.fromJson(newItemData.first as Map<String, dynamic>);

      // Optimistic State Update
      final currentLots = state.valueOrNull;
      if (currentLots != null) {
        final updatedLots =
            currentLots.map((lot) {
              if (lot.id == parentLotId) {
                return lot.copyWith(lotItems: [...lot.lotItems, createdItem]);
              }
              return lot;
            }).toList();
        state = AsyncValue.data(updatedLots);
        print("Optimistically added item ${createdItem.id} to lot $parentLotId");
      } else {
        ref.invalidateSelf(); // Fallback
      }
      return createdItem; // Return the created object
    } on PostgrestException catch (e) {
      print('Supabase Error creating lot item for lot ${newItem.parentLotId}: ${e.message}');
      state = previousState; // Revert state
      throw Exception('Failed to create lot item: ${e.message}');
    } catch (e) {
      print('Error creating lot item: $e');
      state = previousState; // Revert state
      rethrow;
    }
  }

  /// Updates an existing LotItem.
  /// Expects the full [updatedItem] object containing the desired state.
  Future<void> updateLotItem(LotItem updatedItem) async {
    final previousState = state;
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI update: Find the parent lot and replace the item
      bool found = false;
      final updatedLots =
          currentLots.map((lot) {
            // Check if this lot contains the item
            if (lot.lotItems.any((item) => item.id == updatedItem.id)) {
              found = true;
              return lot.copyWith(
                lotItems:
                    lot.lotItems.map((item) {
                      // Replace the matching item directly
                      return item.id == updatedItem.id ? updatedItem : item;
                    }).toList(),
              );
            }
            return lot;
          }).toList();

      if (!found) {
        print("LotItem ${updatedItem.id} not found in current state for update.");
        return;
      }

      state = AsyncValue.data(updatedLots); // Apply optimistic update
      print("Optimistically updated item: ${updatedItem.id}");

      // DB Update: Send the whole object's JSON
      final updateData = updatedItem.toJson()..remove('id'); // Don't update ID
      await supabase.from('lot_items').update(updateData).eq('id', updatedItem.id);
      print("Successfully updated item ${updatedItem.id} in DB");
    } catch (e) {
      print('Error updating lot item ${updatedItem.id}: $e');
      state = previousState; // Revert optimistic update
      rethrow;
    }
  }

  /// Deletes a LotItem by its ID.
  Future<void> deleteLotItem(int itemId) async {
    final previousState = state;
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      Lot? parentLot;
      int initialTotalItems = currentLots.fold(0, (sum, lot) => sum + lot.lotItems.length);

      // Optimistic UI update
      final updatedLots =
          currentLots.map((lot) {
            final initialLength = lot.lotItems.length;
            final updatedItems = lot.lotItems.where((item) => item.id != itemId).toList();
            if (updatedItems.length < initialLength) {
              parentLot = lot;
              return lot.copyWith(lotItems: updatedItems);
            }
            return lot;
          }).toList();

      int finalTotalItems = updatedLots.fold(0, (sum, lot) => sum + lot.lotItems.length);

      if (parentLot != null && finalTotalItems < initialTotalItems) {
        state = AsyncValue.data(updatedLots);
        print("Optimistically deleted item: $itemId from lot ${parentLot?.id}");
      } else {
        print("Item $itemId not found in current state for deletion.");
        return;
      }

      // DB delete
      await supabase.from('lot_items').delete().eq('id', itemId);
      print("Successfully deleted item $itemId from DB");
    } catch (e) {
      print('Error deleting lot item $itemId: $e');
      state = previousState;
      rethrow;
    }
  }

  /// Updates the status for all items within a specific lot.
  /// Note: This still takes lotId and Status for efficiency, as updating
  ///       multiple items via individual objects would be less performant.
  Future<void> updateAllLotItemsStatus(int lotId, Status status) async {
    try {
      // DB Update first
      await supabase
          .from('lot_items')
          .update({'status': status.toJson()}) // Use enum's toJson
          .eq('parent_lot_id', lotId);
      print("Successfully updated status for items in lot $lotId in DB");

      // Update state manually
      final currentLots = state.valueOrNull;
      if (currentLots != null) {
        final updatedLots =
            currentLots.map((lot) {
              if (lot.id == lotId) {
                if (lot.lotItems.isEmpty || lot.lotItems.every((item) => item.status == status)) {
                  return lot; // No change needed
                }
                // Create updated items using copyWith
                final updatedItems = lot.lotItems.map((item) => item.copyWith(status: status)).toList();
                return lot.copyWith(lotItems: updatedItems);
              }
              return lot;
            }).toList();

        if (updatedLots != currentLots) {
          state = AsyncValue.data(updatedLots);
          print("Manually updated status for items in lot $lotId in state");
        }
      } else {
        ref.invalidateSelf();
      }
    } on PostgrestException catch (e) {
      print('Supabase Error updating lot items status for lot $lotId: ${e.message}');
      ref.invalidateSelf(); // Invalidate to refetch on DB error
      throw Exception('Failed to update lot items status: ${e.message}');
    } catch (e) {
      print('Error updating lot items status: $e');
      ref.invalidateSelf(); // Invalidate to refetch on general error
      rethrow;
    }
  }

  // --- Deliverable Management (Applying the same object-based pattern) ---

  /// Creates a new Deliverable.
  /// Expects [newDeliverable] object with `parentLotId` set, but `id` likely null/ignored.
  Future<Deliverable> createDeliverable(Deliverable newDeliverable, int parentLotId) async {
    final previousState = state;
    try {
      // Prepare data: Convert to JSON, remove ID, ensure parent ID exists
      final insertData = newDeliverable.toJson()..remove('id');
      if (insertData['parent_lot_id'] == null) {
        throw ArgumentError("Cannot create Deliverable without a parentLotId.");
      }
      final parentLotId = insertData['parent_lot_id'] as int;

      // Insert and select the full new deliverable
      final List<dynamic> newDeliverableData = await supabase.from('deliverables').insert(insertData).select();

      if (newDeliverableData.isEmpty) {
        throw Exception("Failed to create deliverable - no data returned.");
      }
      final createdDeliverable = Deliverable.fromJson(newDeliverableData.first as Map<String, dynamic>);

      // Optimistic State Update
      final currentLots = state.valueOrNull;
      if (currentLots != null) {
        final updatedLots =
            currentLots.map((lot) {
              if (lot.id == parentLotId) {
                return lot.copyWith(deliverables: [...lot.deliverables, createdDeliverable]);
              }
              return lot;
            }).toList();
        state = AsyncValue.data(updatedLots);
        print("Optimistically added deliverable ${createdDeliverable.id} to lot $parentLotId");
      } else {
        ref.invalidateSelf();
      }
      return createdDeliverable; // Return the created object
    } on PostgrestException catch (e) {
      print('Supabase Error creating deliverable for lot ${newDeliverable.parentLotId}: ${e.message}');
      state = previousState;
      throw Exception('Failed to create deliverable: ${e.message}');
    } catch (e) {
      print('Error creating deliverable: $e');
      state = previousState;
      rethrow;
    }
  }

  /// Updates an existing Deliverable.
  /// Expects the full [updatedDeliverable] object containing the desired state.
  Future<void> updateDeliverable(Deliverable updatedDeliverable) async {
    final previousState = state;
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI update: Find parent lot and replace deliverable
      bool found = false;
      final updatedLots =
          currentLots.map((lot) {
            // Check if this lot contains the deliverable
            if (lot.deliverables.any((d) => d.id == updatedDeliverable.id)) {
              found = true;
              return lot.copyWith(
                deliverables:
                    lot.deliverables.map((d) {
                      // Replace the matching deliverable
                      return d.id == updatedDeliverable.id ? updatedDeliverable : d;
                    }).toList(),
              );
            }
            return lot;
          }).toList();

      if (!found) {
        print("Deliverable ${updatedDeliverable.id} not found in current state for update.");
        return;
      }

      state = AsyncValue.data(updatedLots); // Apply optimistic update
      print("Optimistically updated deliverable: ${updatedDeliverable.id}");

      // DB Update: Send the whole object's JSON
      final updateData = updatedDeliverable.toJson()..remove('id'); // Don't update ID
      await supabase.from('deliverables').update(updateData).eq('id', updatedDeliverable.id);
      print("Successfully updated deliverable ${updatedDeliverable.id} in DB");
    } catch (e) {
      print('Error updating deliverable ${updatedDeliverable.id}: $e');
      state = previousState; // Revert optimistic update
      rethrow;
    }
  }

  /// Deletes a Deliverable by its ID.
  Future<void> deleteDeliverable(int deliverableId) async {
    final previousState = state;
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      Lot? parentLot;
      int initialTotalDeliverables = currentLots.fold(0, (sum, lot) => sum + lot.deliverables.length);

      // Optimistic UI update
      final updatedLots =
          currentLots.map((lot) {
            final initialLength = lot.deliverables.length;
            final updatedDeliverables = lot.deliverables.where((d) => d.id != deliverableId).toList();
            if (updatedDeliverables.length < initialLength) {
              parentLot = lot;
              return lot.copyWith(deliverables: updatedDeliverables);
            }
            return lot;
          }).toList();

      int finalTotalDeliverables = updatedLots.fold(0, (sum, lot) => sum + lot.deliverables.length);

      if (parentLot != null && finalTotalDeliverables < initialTotalDeliverables) {
        state = AsyncValue.data(updatedLots);
        print("Optimistically deleted deliverable: $deliverableId from lot ${parentLot?.id}");
      } else {
        print("Deliverable $deliverableId not found in current state for deletion.");
        return;
      }

      // DB delete
      await supabase.from('deliverables').delete().eq('id', deliverableId);
      print("Successfully deleted deliverable $deliverableId from DB");
    } catch (e) {
      print('Error deleting deliverable $deliverableId: $e');
      state = previousState;
      rethrow;
    }
  }

  // Helper method _parseDateTimeFromField removed as it's no longer needed for updates.
}
