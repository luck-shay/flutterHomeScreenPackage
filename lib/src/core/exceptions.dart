class UnknownSectionException implements Exception {
  final String type;
  final String message;

  UnknownSectionException(this.type, [this.message = '']);

  @override
  String toString() => 'UnknownSectionException: $type. $message';
}

class UnknownComponentException implements Exception {
  final String type;
  final String message;

  UnknownComponentException(this.type, [this.message = '']);

  @override
  String toString() => 'UnknownComponentException: $type. $message';
}

class JsonValidationException implements Exception {
  final String message;

  JsonValidationException(this.message);

  @override
  String toString() => 'JsonValidationException: $message';
}
