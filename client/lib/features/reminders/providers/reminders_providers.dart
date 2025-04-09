import 'dart:async';
import 'package:client/core/providers/supabase_provider.dart';
import 'package:client/features/auth/providers/auth_provider.dart';
import 'package:client/features/reminders/models/reminder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminders_providers.g.dart';

const String _remindersTable = 'reminders';

class ReminderFilters {
  final int? projectId;
  final int? lotId;
  final bool includeCompleted;

  ReminderFilters({this.projectId, this.lotId, this.includeCompleted = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderFilters &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          lotId == other.lotId &&
          includeCompleted == other.includeCompleted;

  @override
  int get hashCode => projectId.hashCode ^ lotId.hashCode ^ includeCompleted.hashCode;
}

// --- Reminders Notifier (Combined Logic) ---
@Riverpod(keepAlive: true)
class RemindersNotifier extends _$RemindersNotifier {
  @override
  FutureOr<List<Reminder>> build(ReminderFilters filters) async {
    final user = ref.read(authProvider);
    if (user == null) {
      return [];
    }
    var query = supabase.from(_remindersTable).select();

    // Apply optional filters from the argument
    if (filters.projectId != null) {
      query = query.eq('project_id', filters.projectId!);
    }
    if (filters.lotId != null) {
      query = query.eq('lot_id', filters.lotId!);
    }
    if (!filters.includeCompleted) {
      query = query.eq('is_completed', false);
    }

    query.order('due_date', ascending: true, nullsFirst: false).order('created_at', ascending: false);

    final data = await query;
    return data.map((map) => Reminder.fromJson(map)).toList();
  }

  // Helper method to refetch data based on current filters
  Future<void> _refetch() async {
    state = const AsyncValue.loading(); // Set loading state
    try {
      // Rerun the build logic to fetch fresh data
      final reminders = await build(filters);
      state = AsyncValue.data(reminders);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // Method to add a reminder and then refetch the list
  Future<void> addReminder({required String? note, required DateTime? dueDate, int? projectId, int? lotId}) async {
    final user = ref.read(authProvider);
    if (user == null) {
      throw Exception("User not authenticated");
    }

    state = const AsyncValue.loading(); // Optional: Indicate loading during mutation
    try {
      final newReminderData = {
        'note': note,
        'due_date':
            dueDate == null
                ? null
                : '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
        'project_id': projectId,
        'lot_id': lotId,
        'user_id': user.id,
        'tenant_id': user.tenantId,
        'is_completed': false,
      };
      newReminderData.removeWhere((key, value) => value == null);

      await supabase
          .from(_remindersTable)
          .insert(newReminderData)
          .select() // Ensure insert happens, select might not be needed if just refetching
          .single();
      // --- End Insert Logic ---

      // Refetch the list to update the state
      await _refetch(); // Will set state to data or error
    } catch (e) {
      print("Error adding reminder: $e");
      // Refetch to potentially reset state if insert failed mid-way, or set error explicitly
      await _refetch(); // Or set state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  // Method to update a reminder and then refetch
  Future<void> updateReminder(Reminder reminder) async {
    state = const AsyncValue.loading();
    try {
      // --- Database Update Logic (from former repository) ---
      final updateData = reminder.toJson();
      updateData.remove('id');
      updateData.remove('created_at');
      updateData.remove('user_id'); // Standard user cannot change owner
      updateData.remove('tenant_id');

      await supabase
          .from(_remindersTable)
          .update(updateData)
          .eq('id', reminder.id)
          .select() // Ensure update happens
          .single();
      // --- End Update Logic ---

      await _refetch();
    } catch (e) {
      print("Error updating reminder: $e");
      await _refetch(); // Reset state on error
      rethrow;
    }
  }

  // Method to toggle completion and then refetch
  Future<void> setCompletion(int reminderId, bool isCompleted) async {
    state = const AsyncValue.loading();
    try {
      // --- Database Update Logic ---
      await supabase.from(_remindersTable).update({'is_completed': isCompleted}).eq('id', reminderId);
      // --- End Update Logic ---

      await _refetch();
    } catch (e) {
      print("Error setting reminder completion: $e");
      await _refetch(); // Reset state on error
      rethrow;
    }
  }

  // Method to delete a reminder and then refetch
  Future<void> deleteReminder(int reminderId) async {
    state = const AsyncValue.loading();
    try {
      // --- Database Delete Logic ---
      await supabase.from(_remindersTable).delete().eq('id', reminderId);
      // --- End Delete Logic ---

      await _refetch();
    } catch (e) {
      print("Error deleting reminder: $e");
      await _refetch(); // Reset state on error
      rethrow;
    }
  }

  // Method to explicitly trigger a refetch from the UI
  Future<void> refresh() async {
    await _refetch();
  }
}

// Provider for a single reminder (can stay the same)
@Riverpod(keepAlive: true)
FutureOr<Reminder?> reminderById(Ref ref, int id) async {
  try {
    final data = await supabase.from(_remindersTable).select().eq('id', id).maybeSingle();
    return data == null ? null : Reminder.fromJson(data);
  } catch (e) {
    print("Error fetching reminder by ID $id: $e");
    return null;
  }
}
