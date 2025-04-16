import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Removed collection import as it's no longer needed for groupBy
part 'lot_provider.g.dart';

@Riverpod(keepAlive: true)
class Lots extends _$Lots {
  @override
  FutureOr<List<Lot>> build(int? projectId) async {
    if (projectId == null) {
      print("Project ID is null. Cannot fetch lots.");
      return []; // No project ID provided
    }

    // Use Supabase's query builder to fetch lots and related data
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
      ),
      user_profiles (
        full_name, email
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

        // Create the Lot object
        final lot = Lot(
          id: map['id'] as int,
          title: map['title'] as String,
          number: map['number'] as String,
          provider: map['provider'] as String,
        );

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

  // --- Lot Management ---
  Future<void> createLot(int projectId, Map<String, dynamic> data) async {
    try {
      final insertData = {...data, 'project_id': projectId};
      final List<dynamic> newLotData = await supabase
          .from('lots')
          .insert(insertData)
          .select('id, title, number, provider'); // Does not select items/deliverables

      if (newLotData.isEmpty) {
        throw Exception('Failed to create lot - no data returned.');
      }

      // Create the basic lot object (no items/deliverables yet)
      final newLot = Lot.fromJson(newLotData.first as Map<String, dynamic>);

      // Update State
      final currentLots = state.valueOrNull ?? [];
      final updatedLots = [...currentLots, newLot]; // Add the new basic lot
      state = AsyncValue.data(updatedLots);
    } on PostgrestException catch (e) {
      print('Supabase Error creating lot for project $projectId: ${e.message}');
      throw Exception('Failed to create lot: ${e.message}');
    } catch (e) {
      print('Error creating lot: $e');
      ref.invalidateSelf(); // Consider invalidating on error
      rethrow;
    }
  }

  Future<void> updateLot(int lotId, Map<String, dynamic> fields) async {
    // Only updates fields in the 'lots' table
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return; // Or throw?

      // Optimistic UI Update
      final updatedLots =
          currentLots.map((lot) {
            if (lot.id == lotId) {
              return lot.copyWith(
                // Only update Lot fields, keep existing items/deliverables
                title: fields['title'] ?? lot.title,
                number: fields['number'] ?? lot.number,
                provider: fields['provider'] ?? lot.provider,
              );
            }
            return lot;
          }).toList();
      state = AsyncValue.data(updatedLots);

      // DB Update
      await supabase.from('lots').update(fields).eq('id', lotId);
    } catch (e) {
      print('Error updating lot $lotId: $e');
      ref.invalidateSelf(); // Revert optimistic update on error
      rethrow;
    }
  }

  // --- LotItem Management ---
  Future<void> createLotItem(int parentLotId, Map<String, dynamic> data) async {
    final insertData = {...data, 'parent_lot_id': parentLotId};
    try {
      final List<dynamic> newItemData =
          await supabase.from('lot_items').insert(insertData).select(); // Select all columns

      if (newItemData.isEmpty) {
        throw Exception("Failed to create lot item - no data returned.");
      }
      final newItem = LotItem.fromJson(newItemData.first as Map<String, dynamic>);

      // Update state manually
      final currentLots = state.valueOrNull;
      if (currentLots != null) {
        final updatedLots =
            currentLots.map((lot) {
              if (lot.id == parentLotId) {
                return lot.copyWith(items: [...lot.items, newItem]);
              }
              return lot;
            }).toList();
        state = AsyncValue.data(updatedLots);
      } else {
        ref.invalidateSelf();
      }
    } on PostgrestException catch (e) {
      print('Supabase Error creating lot item for lot $parentLotId: ${e.message}');
      ref.invalidateSelf();
      throw Exception('Failed to create lot item: ${e.message}');
    } catch (e) {
      print('Error creating lot item: $e');
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> updateLotItem2(LotItem newLotItem) async {
    await supabase.from('lot_items').update(newLotItem.toJson()).eq('id', newLotItem.id);
  }

  Future<void> updateLotItem(int itemId, Map<String, dynamic> fields) async {
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI update
      LotItem? oldItem; // Store the old item for potential revert
      final updatedLots =
          currentLots.map((lot) {
            final updatedItems =
                lot.items.map((item) {
                  if (item.id == itemId) {
                    oldItem = item; // Store the original
                    return item.copyWith(
                      // Apply updates
                      title: fields['title'] ?? item.title,
                      quantity: fields['quantity'] ?? item.quantity,
                      endManufacturingDate:
                          fields['end_manufacturing_date'] != null
                              ? DateTime.tryParse(fields['end_manufacturing_date'])
                              : item.endManufacturingDate,
                      readyToShipDate:
                          fields['ready_to_ship_date'] != null
                              ? DateTime.tryParse(fields['ready_to_ship_date'])
                              : item.readyToShipDate,
                      plannedDeliveryDate:
                          fields['planned_delivery_date'] != null
                              ? DateTime.tryParse(fields['planned_delivery_date'])
                              : item.plannedDeliveryDate,
                      requiredOnSiteDate:
                          fields['required_on_site_date'] != null
                              ? DateTime.tryParse(fields['required_on_site_date'])
                              : item.requiredOnSiteDate,
                      purchasingProgress: fields['purchasing_progress']?.round() ?? item.purchasingProgress,
                      engineeringProgress: fields['engineering_progress']?.round() ?? item.engineeringProgress,
                      manufacturingProgress: fields['manufacturing_progress']?.round() ?? item.manufacturingProgress,
                      originCountry: fields['origin_country'] ?? item.originCountry,
                      incoterms:
                          fields['incoterms'] != null ? Incoterm.fromString(fields['incoterms']) : item.incoterms,
                      comments: fields['comments'] ?? item.comments,
                      status: fields['status'] != null ? Status.fromString(fields['status']) : item.status,
                    );
                  }
                  return item;
                }).toList();

            // Check if an item was updated in this lot
            if (updatedItems.any((item) => item.id == itemId && item != oldItem)) {
              return lot.copyWith(items: updatedItems);
            }
            return lot;
          }).toList();
      state = AsyncValue.data(updatedLots); // Apply optimistic update

      // DB Update
      await supabase.from('lot_items').update(fields).eq('id', itemId);
    } catch (e) {
      print('Error updating lot item $itemId: $e');
      ref.invalidateSelf(); // Revert on error
      rethrow;
    }
  }

  Future<void> deleteLotItem(int itemId) async {
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI update
      Lot? parentLot;
      final updatedLots =
          currentLots.map((lot) {
            final initialLength = lot.items.length;
            final updatedItems = lot.items.where((item) => item.id != itemId).toList();
            if (updatedItems.length < initialLength) {
              parentLot = lot; // Found the parent lot
              return lot.copyWith(items: updatedItems);
            }
            return lot;
          }).toList();

      if (parentLot == null) return; // Item not found in current state

      state = AsyncValue.data(updatedLots); // Apply optimistic update

      // DB delete
      await supabase.from('lot_items').delete().eq('id', itemId);
    } catch (e) {
      print('Error deleting lot item $itemId: $e');
      ref.invalidateSelf(); // Revert on error
      rethrow;
    }
  }

  Future<void> updateAllLotItemsStatus(int lotId, Status status) async {
    try {
      // DB Update
      await supabase
          .from('lot_items')
          .update({'status': status.toJson()})
          .eq('parent_lot_id', lotId); // Use toJson() for enum

      // Update state manually
      final currentLots = state.valueOrNull;
      if (currentLots != null) {
        final updatedLots =
            currentLots.map((lot) {
              if (lot.id == lotId) {
                final updatedItems = lot.items.map((item) => item.copyWith(status: status)).toList();
                return lot.copyWith(items: updatedItems);
              }
              return lot;
            }).toList();
        state = AsyncValue.data(updatedLots);
      } else {
        ref.invalidateSelf();
      }
    } on PostgrestException catch (e) {
      print('Supabase Error updating lot items status for lot $lotId: ${e.message}');
      ref.invalidateSelf();
      throw Exception('Failed to update lot items status: ${e.message}');
    } catch (e) {
      print('Error updating lot items status: $e');
      ref.invalidateSelf();
      rethrow;
    }
  }

  // --- Deliverable Management ---
  Future<void> createDeliverable(int parentLotId, Map<String, dynamic> data) async {
    final insertData = {...data, 'parent_lot_id': parentLotId};
    try {
      final List<dynamic> newDeliverableData =
          await supabase.from('deliverables').insert(insertData).select(); // Select all columns

      if (newDeliverableData.isEmpty) {
        throw Exception("Failed to create deliverable - no data returned.");
      }
      final newDeliverable = Deliverable.fromJson(newDeliverableData.first as Map<String, dynamic>);

      // Update state manually
      final currentLots = state.valueOrNull;
      if (currentLots != null) {
        final updatedLots =
            currentLots.map((lot) {
              if (lot.id == parentLotId) {
                // Add the new deliverable to the correct lot's list
                return lot.copyWith(deliverables: [...lot.deliverables, newDeliverable]);
              }
              return lot;
            }).toList();
        state = AsyncValue.data(updatedLots);
      } else {
        ref.invalidateSelf(); // Fallback if state not loaded
      }
    } on PostgrestException catch (e) {
      print('Supabase Error creating deliverable for lot $parentLotId: ${e.message}');
      ref.invalidateSelf(); // Invalidate on error
      throw Exception('Failed to create deliverable: ${e.message}');
    } catch (e) {
      print('Error creating deliverable: $e');
      ref.invalidateSelf(); // Invalidate on error
      rethrow;
    }
  }

  Future<void> updateDeliverable(int deliverableId, Map<String, dynamic> fields) async {
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI update
      Deliverable? oldDeliverable;
      final updatedLots =
          currentLots.map((lot) {
            final updatedDeliverables =
                lot.deliverables.map((deliverable) {
                  if (deliverable.id == deliverableId) {
                    oldDeliverable = deliverable;
                    // Apply updates using copyWith
                    return deliverable.copyWith(
                      title: fields['title'] ?? deliverable.title,
                      dueDate:
                          fields['due_date'] != null
                              ? DateTime.tryParse(fields['due_date']) ?? deliverable.dueDate
                              : deliverable.dueDate,
                      isReceived: fields['is_received'] ?? deliverable.isReceived,
                    );
                  }
                  return deliverable;
                }).toList();

            // Check if a deliverable was updated in this lot
            if (updatedDeliverables.any((d) => d.id == deliverableId && d != oldDeliverable)) {
              return lot.copyWith(deliverables: updatedDeliverables);
            }
            return lot;
          }).toList();
      state = AsyncValue.data(updatedLots); // Apply optimistic update

      // DB Update
      await supabase.from('deliverables').update(fields).eq('id', deliverableId);
    } catch (e) {
      print('Error updating deliverable $deliverableId: $e');
      ref.invalidateSelf(); // Revert on error
      rethrow;
    }
  }

  Future<void> deleteDeliverable(int deliverableId) async {
    try {
      final currentLots = state.valueOrNull;
      if (currentLots == null) return;

      // Optimistic UI update
      Lot? parentLot;
      final updatedLots =
          currentLots.map((lot) {
            final initialLength = lot.deliverables.length;
            // Filter out the deliverable to be deleted
            final updatedDeliverables = lot.deliverables.where((d) => d.id != deliverableId).toList();
            if (updatedDeliverables.length < initialLength) {
              parentLot = lot; // Found the parent lot
              return lot.copyWith(deliverables: updatedDeliverables);
            }
            return lot;
          }).toList();

      if (parentLot == null) return; // Deliverable not found in current state

      state = AsyncValue.data(updatedLots); // Apply optimistic update

      // DB delete
      await supabase.from('deliverables').delete().eq('id', deliverableId);
    } catch (e) {
      print('Error deleting deliverable $deliverableId: $e');
      ref.invalidateSelf(); // Revert on error
      rethrow;
    }
  }
}
