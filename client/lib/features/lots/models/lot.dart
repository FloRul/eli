import 'package:client/features/lots/models/deliverable.dart';
import 'package:client/features/lots/models/lot_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'enums.dart';

part 'lot.freezed.dart';
part 'lot.g.dart';

// ignore: avoid_dynamic_calls
Object? _readExpediter(Map<dynamic, dynamic> json, String key) => json['user_profiles']?[key];

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
    @JsonKey(includeToJson: false, includeFromJson: true) @Default([]) List<LotItem> lotItems,
    @JsonKey(includeToJson: false, includeFromJson: true) @Default([]) List<Deliverable> deliverables,
  }) = _Lot;

  factory Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

  String get displayTitle => '$title ($number)';

  List<DateTime?> get plannedDeliveryDates => lotItems.map((item) => item.plannedDeliveryDate).toList();

  Status get overallStatus {
    if (lotItems.isEmpty) return Status.ongoing;
    return lotItems.fold(Status.completed, (max, item) => item.status.priority > max.priority ? item.status : max);
  }

  double get purchasingProgress {
    if (lotItems.isEmpty) return 0.0;
    final totalProgress = lotItems.fold<double>(0, (sum, item) => sum + item.purchasingProgress);
    return totalProgress / lotItems.length;
  }

  double get engineeringProgress {
    if (lotItems.isEmpty) return 0.0;
    final totalProgress = lotItems.fold<double>(0, (sum, item) => sum + item.engineeringProgress);
    return totalProgress / lotItems.length;
  }

  double get manufacturingProgress {
    if (lotItems.isEmpty) return 0.0;
    final totalProgress = lotItems.fold<double>(0, (sum, item) => sum + item.manufacturingProgress);
    return totalProgress / lotItems.length;
  }

  List<String> get pendingItemsNameDeliveryThisWeek {
    final now = DateTime.now();
    return lotItems
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
    return lotItems
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
