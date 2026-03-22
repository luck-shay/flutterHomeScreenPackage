import '../models/section_config.dart';
import 'component_registry.dart';
import 'exceptions.dart';

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
    final type = json['type'] as String?;

    if (type == null) {
      throw JsonValidationException('Section JSON missing "type" key.');
    }

    if (type == 'custom') {
      throw UnsupportedError(
        'CustomSectionConfig cannot be deserialized strictly from JSON via the standard parser. '
        'Consider utilizing custom ComponentRegistries for standard data mappings.',
      );
    }

    if (_builders.containsKey(type)) {
      return _builders[type]!(json, registry);
    } else {
      throw UnknownSectionException(type);
    }
  }
}
