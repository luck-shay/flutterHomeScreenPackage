import '../models/section_config.dart';
import 'component_registry.dart';
import 'exceptions.dart';
import 'json_parser_utils.dart';
import 'home_logger.dart';

typedef SectionBuilder =
    HomeSectionConfig Function(
      Map<String, dynamic> json,
      ComponentRegistry? registry,
    );

/// Package-private registry managing the parsing of layout sections.
class SectionRegistry {
  static final Map<String, SectionBuilder> _builders = {
    'header': (json, _) => HeaderSectionConfig.fromJson(json),
    'banner': (json, registry) =>
        BannerSectionConfig.fromJson(json, registry: registry),
    'action_grid': (json, registry) =>
        ActionGridSectionConfig.fromJson(json, registry: registry),
    'content_list': (json, registry) =>
        ContentListSectionConfig.fromJson(json, registry: registry),
    'divider': (json, _) => DividerSectionConfig.fromJson(json),
  };

  /// Validates existence of a base structural layout parser.
  static bool hasSection(String type) => _builders.containsKey(type);

  /// Builds a section given raw JSON.
  static HomeSectionConfig buildSection(
    Map<String, dynamic> json,
    ComponentRegistry? registry,
  ) {
    final type = JsonParserUtils.safeString(json['type']);

    if (type == null) {
      HomeLogger.error(
        'Section JSON is structurally invalid (missing "type" string).',
      );
      throw JsonValidationException('Section JSON missing "type" key.');
    }

    if (type == 'custom') {
      HomeLogger.warn(
        'Encountered custom layout section directly in JSON which is unsupported implicitly.',
      );
      throw UnsupportedError(
        'CustomSectionConfig cannot be deserialized strictly from JSON via the standard parser. '
        'Consider utilizing custom ComponentRegistries for standard data mappings.',
      );
    }

    if (_builders.containsKey(type)) {
      HomeLogger.info('Parsing mapped internal section layout > $type');
      return _builders[type]!(json, registry);
    } else {
      HomeLogger.error('Encountered unknown structural section type: $type');
      throw UnknownSectionException(type);
    }
  }
}
