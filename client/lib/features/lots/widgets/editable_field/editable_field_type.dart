enum EditableFieldType {
  text,
  multiline,
  number, // Can be int or double/num
  date, // Expects DateTime
  percentage, // Expects int or double/num (0-100)
  dropdown, // Expects Map<String, String> in options (internalValue -> displayValue)
  enumDropdown, // Expects Map<String, Enum> in options (displayName -> enumValue)
  status, // Expects Status enum, uses custom list builder
  incoterm, // Expects Incoterm enum, uses custom list builder
}
