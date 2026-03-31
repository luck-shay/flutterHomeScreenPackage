import 'package:flutter/widgets.dart';
import '../models/sdui_section_config.dart';
import 'component_registry.dart';
import 'exceptions.dart';
import 'json_parser_utils.dart';
import 'sdui_logger.dart';
import 'validation_result.dart';

typedef SectionBuilder =
    SduiSectionConfig Function(
      Map<String, dynamic> json,
      ComponentRegistry? registry, {
      bool strictMode,
      ValidationResult? validationResult,
    });

/// Package-private registry managing the parsing of layout sections.
class SectionRegistry {
  static final Map<String, SectionBuilder> _builders = {
    'header': (json, _, {strictMode = false, validationResult}) =>
        HeaderSectionConfig.fromJson(
          json,
          strictMode: strictMode,
          validationResult: validationResult,
        ),
    'banner': (json, registry, {strictMode = false, validationResult}) =>
        BannerSectionConfig.fromJson(
          json,
          registry: registry,
          strictMode: strictMode,
          validationResult: validationResult,
        ),
    'action_grid': (json, registry, {strictMode = false, validationResult}) =>
        ActionGridSectionConfig.fromJson(
          json,
          registry: registry,
          strictMode: strictMode,
          validationResult: validationResult,
        ),
    'content_list': (json, registry, {strictMode = false, validationResult}) =>
        ContentListSectionConfig.fromJson(
          json,
          registry: registry,
          strictMode: strictMode,
          validationResult: validationResult,
        ),
    'divider': (json, _, {strictMode = false, validationResult}) =>
        DividerSectionConfig.fromJson(
          json,
          strictMode: strictMode,
          validationResult: validationResult,
        ),
  };

  /// Validates existence of a base structural layout parser.
  static bool hasSection(String type) => _builders.containsKey(type);

  /// Builds a section given raw JSON.
  static SduiSectionConfig buildSection(
    Map<String, dynamic> json,
    ComponentRegistry? registry, {
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    final type = JsonParserUtils.safeString(json['type']);

    if (type == null) {
      SduiLogger.error(
        'Section JSON is structurally invalid (missing "type" string).',
      );
      throw JsonValidationException('Section JSON missing "type" key.');
    }

    if (type == 'custom') {
      SduiLogger.warn(
        'Encountered custom layout section directly in JSON which is unsupported implicitly.',
      );
      throw UnsupportedError(
        'CustomSectionConfig cannot be deserialized strictly from JSON via the standard parser. '
        'Consider utilizing custom ComponentRegistries for standard data mappings.',
      );
    }

    if (_builders.containsKey(type)) {
      SduiLogger.info('Parsing mapped internal section layout > $type');
      return _builders[type]!(
        json,
        registry,
        strictMode: strictMode,
        validationResult: validationResult,
      );
    } else {
      SduiLogger.error('Encountered unknown structural section type: $type');
      validationResult?.addError(
        'Encountered unknown structural section type: $type',
      );
      if (strictMode) throw UnknownSectionException(type);

      // Fallback
      return CustomSectionConfig(
        id: 'unknown_$type',
        builder: (context) => Container(),
      );
    }
  }
}
