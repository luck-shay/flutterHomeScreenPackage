class JsonParserUtils {
  /// Safely extracts and casts a string from a dynamic JSON value.
  /// Falls back to casting numbers or booleans to string gracefully.
  static String? safeString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  /// Safely extracts a double, parsing correctly from string integers if payload is malformed.
  static double? safeDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Safely extracts an integer, stripping decimals or parsing string formats.
  static int? safeInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Safely checks boolean state, treating numbers > 0 or strings as truthy logically.
  static bool? safeBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    if (value is num) return value > 0;
    return null;
  }
}
