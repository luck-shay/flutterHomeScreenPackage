import 'dart:convert';
import 'item_config.dart';
import 'sdui_debug_overlay.dart';
import 'validation_result.dart';
import 'exceptions.dart';
import 'json_parser_utils.dart';
import 'sdui_logger.dart';

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

  ItemConfig buildComponent(
    Map<String, dynamic> json, {
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    final type = JsonParserUtils.safeString(
      json['type'],
      strict: strictMode,
      fieldName: 'type',
    );

    if (type == null) {
      SduiLogger.error(
        'Component mapped to registry missing "type" key constraints.',
      );
      validationResult?.addError('Component JSON missing "type" key.');
      if (strictMode) {
        throw JsonValidationException('Component JSON missing "type" key.');
      }
      return WidgetItemConfig(
        widget: const SduiDebugOverlay(
          componentType: 'Unknown',
          errorReason: 'Missing "type" key in JSON payload.',
        ),
      );
    }

    // Try caching for highly identical JSON nodes.
    // If the node has an ID it's explicitly identifiable.
    final id = JsonParserUtils.safeString(json['id']);
    int? cacheKey;
    if (id != null) {
      // Create a deterministic hash from the JSON string.
      cacheKey = jsonEncode(json).hashCode;
      if (_cache.containsKey(cacheKey)) {
        SduiLogger.info('Cache hit for component type: $type (id: $id)');
        return _cache[cacheKey]!;
      }
    }

    ItemConfig result;
    if (_builders.containsKey(type)) {
      result = _builders[type]!(json);
    } else if (fallbackBuilder != null) {
      SduiLogger.warn(
        'Resolving unregistered component "$type" via explicit fallback schema handler.',
      );
      validationResult?.addWarning(
        'Resolved unregistered component "$type" via explicit fallback schema handler.',
      );
      result = fallbackBuilder!(type, json);
    } else {
      SduiLogger.error(
        'Component parsing bound failed natively for unknown type: $type',
      );
      validationResult?.addError('Unknown component type: $type');
      if (strictMode) {
        throw UnknownComponentException(
          type,
          'No builder or fallback provided for component type: $type',
        );
      }
      result = WidgetItemConfig(
        widget: SduiDebugOverlay(
          componentType: type,
          errorReason: 'No registered builder found in ComponentRegistry.',
        ),
      );
    }

    if (cacheKey != null) {
      _cache[cacheKey] = result;
    }
    return result;
  }
}
