class JsonParserUtils {
  /// Safely extracts and casts a string from a dynamic JSON value.
  /// If [strict] is true, throws a FormatException if the value is not exactly a String.
  static String? safeString(
    dynamic value, {
    bool strict = false,
    String fieldName = 'unknown',
  }) {
    if (value == null) return null;
    if (value is String) return value;
    if (strict) {
      throw FormatException(
        'Strict validation failed: Expected String for field "$fieldName", but got ${value.runtimeType}',
      );
    }
    return value.toString();
  }

  /// Safely extracts a double.
  /// If [strict] is true, throws a FormatException if the value is not a num.
  static double? safeDouble(
    dynamic value, {
    bool strict = false,
    String fieldName = 'unknown',
  }) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (strict) {
      throw FormatException(
        'Strict validation failed: Expected num/double for field "$fieldName", but got ${value.runtimeType}',
      );
    }
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Safely extracts an integer.
  static int? safeInt(
    dynamic value, {
    bool strict = false,
    String fieldName = 'unknown',
  }) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (strict) {
      throw FormatException(
        'Strict validation failed: Expected num/int for field "$fieldName", but got ${value.runtimeType}',
      );
    }
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Safely checks boolean state.
  static bool? safeBool(
    dynamic value, {
    bool strict = false,
    String fieldName = 'unknown',
  }) {
    if (value == null) return null;
    if (value is bool) return value;
    if (strict) {
      throw FormatException(
        'Strict validation failed: Expected bool for field "$fieldName", but got ${value.runtimeType}',
      );
    }
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    if (value is num) return value > 0;
    return null;
  }
}
