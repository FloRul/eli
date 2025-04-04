import 'package:freezed_annotation/freezed_annotation.dart';
import 'company.dart'; // Import the simple company model

part 'contact.freezed.dart';
part 'contact.g.dart';

// TODO: contact creation hook on user creation in supabase
@freezed
abstract class Contact with _$Contact {
  // Factory constructor for creating instances
  // Uses snake_case for JSON keys to match Supabase columns
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Contact({
    required int id,
    required String email,
    String? cellphoneNumber,
    String? officePhoneNumber,
    String? firstName,
    String? lastName,
    required int companyId, // Store company ID
    // Include the nested company data directly if fetched that way
    // Adjust name if your Supabase query uses a different alias/structure
    @JsonKey(name: 'companies') Company? company,
  }) = _Contact;

  const Contact._();

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return email; // Fallback to email if no name
    }
  }

  String get companyName {
    return company?.name ?? 'Unknown Company';
  }
}
