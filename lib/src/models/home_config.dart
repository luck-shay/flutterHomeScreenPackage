import 'package:flutter/widgets.dart';
import '../core/component_registry.dart';
import '../core/section_registry.dart';
import '../core/exceptions.dart';
import '../core/json_parser_utils.dart';
import '../core/home_logger.dart';
import 'section_config.dart';

/// The root configuration object passed to the ModularHomeScreen.
class HomeConfig {
  /// Expected JSON structure version to validate against backend breaking changes.
  static const int currentSupportedVersion = 1;

  /// The list of section configurations that define the layout.
  final List<HomeSectionConfig> sections;

  /// An optional app bar to use at the top of the scroll view.
  final Widget? appBar;

  /// Background color value of the home screen.
  final int? backgroundColorValue;

  /// Helper getter for rendering the translated color.
  Color? get backgroundColor =>
      backgroundColorValue != null ? Color(backgroundColorValue!) : null;

  const HomeConfig({
    required this.sections,
    this.appBar,
    this.backgroundColorValue,
  });

  /// Decodes a server-driven JSON layout into a fully instantiated [HomeConfig].
  ///
  /// The [componentRegistry] is strictly required if any inner layout components
  /// (lists, banners, grids) are present in the JSON payload to resolve their explicit items.
  factory HomeConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? componentRegistry,
    bool debugMode = false,
  }) {
    HomeLogger.enableLogging = debugMode;
    HomeLogger.info('Initializing SDUI Engine parsing...');

    final version = JsonParserUtils.safeInt(json['version']);
    if (version != currentSupportedVersion) {
      HomeLogger.error('Unsupported JSON config version. Expected $currentSupportedVersion, but got $version.');
      throw JsonValidationException(
        'Unsupported JSON config version. Expected $currentSupportedVersion, but got $version.',
      );
    }
    
    HomeLogger.info('Engine version validated correctly: $version');

    final rawSections = json['sections'] as List<dynamic>? ?? [];
    final List<HomeSectionConfig> parsedSections = [];

    for (final rawSection in rawSections) {
      final sectionMap = rawSection as Map<String, dynamic>;
      final section = SectionRegistry.buildSection(
        sectionMap,
        componentRegistry,
      );
      parsedSections.add(section);
    }
    
    HomeLogger.info('Successfully parsed ${parsedSections.length} sections.');

    return HomeConfig(
      sections: parsedSections,
      backgroundColorValue: JsonParserUtils.safeInt(json['backgroundColorValue']),
      appBar:
          null, // AppBar is untyped flutter widget, omitted from typical pure JSON representations.
    );
  }
}
