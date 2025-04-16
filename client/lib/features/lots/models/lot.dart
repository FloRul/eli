import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'enums.dart';

part 'lot.freezed.dart';
part 'lot.g.dart';

Object? _readExpediter(Map<dynamic, dynamic> json, String key) => json['user_profiles']?[key] as Map<String, dynamic>;

@freezed
abstract class Lot with _$Lot {
  const Lot._(); // Private constructor needed for getters and methods

  @JsonSerializable(
    fieldRename: FieldRename.snake, // Match Supabase columns
  )
  const factory Lot({
    required int id,
    required String title,
    required String number,
    required String provider,
    @JsonKey(name: 'full_name', includeToJson: false, readValue: _readExpediter) String? assignedToFullName,
    @JsonKey(name: 'email', includeToJson: false, readValue: _readExpediter) String? assignedToEmail,
    String? assignedExpediterId,
    @JsonKey(includeToJson: false) @Default([]) List<LotItem> items,
    @JsonKey(includeToJson: false) @Default([]) List<Deliverable> deliverables,
  }) = _Lot;

  factory Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

  String get displayTitle => '$title ($number)';

  List<DateTime?> get plannedDeliveryDates => items.map((item) => item.plannedDeliveryDate).toList();

  Status get overallStatus {
    if (items.isEmpty) return Status.ongoing;
    return items.fold(Status.completed, (max, item) => item.status.priority > max.priority ? item.status : max);
  }

  double get purchasingProgress {
    if (items.isEmpty) return 0.0;
    final totalProgress = items.fold<double>(0, (sum, item) => sum + item.purchasingProgress);
    return totalProgress / items.length;
  }

  double get engineeringProgress {
    if (items.isEmpty) return 0.0;
    final totalProgress = items.fold<double>(0, (sum, item) => sum + item.engineeringProgress);
    return totalProgress / items.length;
  }

  double get manufacturingProgress {
    if (items.isEmpty) return 0.0;
    final totalProgress = items.fold<double>(0, (sum, item) => sum + item.manufacturingProgress);
    return totalProgress / items.length;
  }

  List<String> get pendingItemsNameDeliveryThisWeek {
    final now = DateTime.now();
    return items
        .where((item) => item.plannedDeliveryDate != null)
        .where(
          (item) =>
              item.plannedDeliveryDate!.isAfter(now.subtract(const Duration(days: 7))) &&
              item.plannedDeliveryDate!.isBefore(now.add(const Duration(days: 7))),
        )
        .map((item) => '$title -> ${item.title ?? 'Unknown'}')
        .toList();
  }

  List<String> get itemsBehindSchedule {
    final now = DateTime.now();
    return items
        .where((item) => item.plannedDeliveryDate != null)
        .where((item) => item.plannedDeliveryDate!.isBefore(now))
        .map((item) => '$title -> ${item.title ?? 'Unknown'}')
        .toList();
  }

  String get formattedFirstAndLastPlannedDeliveryDates {
    final formatter = DateFormat('MMM d, yyyy'); // Example format
    final validDates = plannedDeliveryDates.where((date) => date != null).toList();
    if (validDates.isEmpty) return 'N/A';
    final firstDate = validDates.reduce((a, b) => a!.isBefore(b!) ? a : b);
    final lastDate = validDates.reduce((a, b) => a!.isAfter(b!) ? a : b);
    return '${formatter.format(firstDate!)} - ${formatter.format(lastDate!)}';
  }

  String get formattedPlannedDeliveryDates {
    final formatter = DateFormat('MMM d, yyyy'); // Example format
    final validDates =
        plannedDeliveryDates
            .where((date) => date != null)
            .map((date) => formatter.format(date!))
            .toSet() // Unique dates
            .toList();
    if (validDates.isEmpty) return 'N/A';
    return validDates.join(', ');
  }
}
