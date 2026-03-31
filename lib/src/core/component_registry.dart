import 'dart:convert';
import 'item_config.dart';
import 'exceptions.dart';
import 'json_parser_utils.dart';
import 'home_logger.dart';

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
  final Map<int, ItemConfig> _cache = {};

  ComponentRegistry({this.fallbackBuilder});

  /// Register a factory builder for a specific string type identifier.
  void register(String type, ComponentBuilder builder) {
    _builders[type] = builder;
  }

  /// Proactively check if a component mapping exists.
  bool hasComponent(String type) => _builders.containsKey(type);

  /// Map an inner JSON object to an [ItemConfig] resolving UI structure.
  ItemConfig buildComponent(Map<String, dynamic> json) {
    final type = JsonParserUtils.safeString(json['type']);

    if (type == null) {
      HomeLogger.error(
        'Component mapped to registry missing "type" key constraints.',
      );
      throw JsonValidationException('Component JSON missing "type" key.');
    }

    // Try caching for highly identical JSON nodes.
    // If the node has an ID it's explicitly identifiable.
    final id = JsonParserUtils.safeString(json['id']);
    int? cacheKey;
    if (id != null) {
      // Create a deterministic hash from the JSON string.
      cacheKey = jsonEncode(json).hashCode;
      if (_cache.containsKey(cacheKey)) {
        HomeLogger.info('Cache hit for component type: $type (id: $id)');
        return _cache[cacheKey]!;
      }
    }

    ItemConfig result;
    if (_builders.containsKey(type)) {
      result = _builders[type]!(json);
    } else if (fallbackBuilder != null) {
      HomeLogger.warn(
        'Resolving unregistered component "$type" via explicit fallback schema handler.',
      );
      result = fallbackBuilder!(type, json);
    } else {
      HomeLogger.error(
        'Component parsing bound failed natively for unknown type: $type',
      );
      throw UnknownComponentException(
        type,
        'No builder or fallback provided for component type: $type',
      );
    }

    if (cacheKey != null) {
      _cache[cacheKey] = result;
    }
    return result;
  }
}
