import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'lot_item.dart';
import 'enums.dart';

part 'lot.freezed.dart';
part 'lot.g.dart';

@freezed
abstract class Lot with _$Lot {
  const Lot._(); // Private constructor needed for getters

  @JsonSerializable(
    fieldRename: FieldRename.snake, // Match Supabase columns
    explicitToJson: true,
  )
  const factory Lot({
    required int id,
    required String title,
    required String number,
    required String provider,
    // Items list will be populated by the provider
    @Default([]) List<LotItem> items,
  }) = _Lot;

  factory Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

  // --- Computed properties moved here from ViewModel ---

  String get displayTitle => '$title ($number)';

  List<DateTime?> get plannedDeliveryDates => items.map((item) => item.plannedDeliveryDate).toList();

  Status get overallStatus {
    if (items.isEmpty) return Status.ongoing;
    return items.fold(Status.completed, (max, item) => item.status.priority > max.priority ? item.status : max);
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
