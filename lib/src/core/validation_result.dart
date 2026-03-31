class ValidationResult {
  final List<String> errors = [];
  final List<String> warnings = [];

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;

  void addError(String error) {
    errors.add(error);
  }

  void addWarning(String warning) {
    warnings.add(warning);
  }

  @override
  String toString() {
    return 'ValidationResult(errors: ${errors.length}, warnings: ${warnings.length})';
  }
}
