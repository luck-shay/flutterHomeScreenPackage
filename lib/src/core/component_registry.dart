import 'item_config.dart';
import 'exceptions.dart';

/// Builder alias for mapping a raw JSON payload to a concrete [ItemConfig].
typedef ComponentBuilder = ItemConfig Function(Map<String, dynamic> json);

/// Fallback builder alias used when an unknown component type is encountered.
typedef FallbackBuilder =
    ItemConfig Function(String type, Map<String, dynamic> json);

/// The central user-facing registry used to parse inner components
/// (like Action Grid items or Content List cards) from JSON payloads.
class ComponentRegistry {
  /// Defines what to construct when an unknown component type is requested.
  /// If not provided, an [UnknownComponentException] is thrown.
  final FallbackBuilder? fallbackBuilder;

  final Map<String, ComponentBuilder> _builders = {};

  ComponentRegistry({this.fallbackBuilder});

  /// Register a factory builder for a specific string type identifier.
  void register(String type, ComponentBuilder builder) {
    _builders[type] = builder;
  }

  /// Proactively check if a component mapping exists.
  bool hasComponent(String type) => _builders.containsKey(type);

  /// Map an inner JSON object to an [ItemConfig] resolving UI structure.
  ItemConfig buildComponent(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    if (type == null) {
      throw JsonValidationException('Component JSON missing "type" key.');
    }

    if (_builders.containsKey(type)) {
      return _builders[type]!(json);
    } else if (fallbackBuilder != null) {
      return fallbackBuilder!(type, json);
    } else {
      throw UnknownComponentException(
        type,
        'No builder or fallback provided for component type: $type',
      );
    }
  }
}
