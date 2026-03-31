import 'package:flutter/widgets.dart';
import '../core/component_registry.dart';
import '../core/section_registry.dart';
import '../core/exceptions.dart';
import '../core/json_parser_utils.dart';
import '../core/sdui_logger.dart';
import '../core/validation_result.dart';
import 'sdui_section_config.dart';

/// The root configuration object passed to the SduiScreen.
class SduiConfig {
  /// Expected JSON structure version to validate against backend breaking changes.
  static const int currentSupportedVersion = 1;

  /// The list of section configurations that define the layout.
  final List<SduiSectionConfig> sections;

  /// An optional app bar to use at the top of the scroll view.
  final Widget? appBar;

  /// Background color value of the home screen.
  final int? backgroundColorValue;

  /// Helper getter for rendering the translated color.
  Color? get backgroundColor =>
      backgroundColorValue != null ? Color(backgroundColorValue!) : null;

  const SduiConfig({
    required this.sections,
    this.appBar,
    this.backgroundColorValue,
  });

  /// Asynchronously decodes a server-driven JSON layout into a fully instantiated [SduiConfig].
  /// This yields the main thread allowing smooth 60fps animations while parsing massive payload structures.
  /// We use microtask yielding because registry closures cannot cross distinct Isolate bounds.
  static Future<SduiConfig> fromJsonAsync(
    Map<String, dynamic> json, {
    ComponentRegistry? componentRegistry,
    bool debugMode = false,
    bool strictMode = false,
    ValidationResult? validationResult,
  }) async {
    // Yield the event loop to prevent freezing the main UI thread during massive JSON resolutions.
    await Future.delayed(Duration.zero);
    return SduiConfig.fromJson(
      json,
      componentRegistry: componentRegistry,
      debugMode: debugMode,
      strictMode: strictMode,
      validationResult: validationResult,
    );
  }

  /// Decodes a server-driven JSON layout into a fully instantiated [SduiConfig].
  ///
  /// The [componentRegistry] is strictly required if any inner layout components
  /// (lists, banners, grids) are present in the JSON payload to resolve their explicit items.
  factory SduiConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? componentRegistry,
    bool debugMode = false,
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    SduiLogger.enableLogging = debugMode;
    SduiLogger.info('Initializing SDUI Engine parsing...');

    final version = JsonParserUtils.safeInt(
      json['version'],
      strict: strictMode,
      fieldName: 'version',
    );
    if (version != currentSupportedVersion) {
      validationResult?.addError('Unsupported JSON config version $version');
      SduiLogger.error(
        'Unsupported JSON config version. Expected $currentSupportedVersion, but got $version.',
      );
      throw JsonValidationException(
        'Unsupported JSON config version. Expected $currentSupportedVersion, but got $version.',
      );
    }

    SduiLogger.info('Engine version validated correctly: $version');

    final rawSections = json['sections'] as List<dynamic>? ?? [];
    final List<SduiSectionConfig> parsedSections = [];

    for (final rawSection in rawSections) {
      final sectionMap = rawSection as Map<String, dynamic>;
      final section = SectionRegistry.buildSection(
        sectionMap,
        componentRegistry,
        strictMode: strictMode,
        validationResult: validationResult,
      );
      parsedSections.add(section);
    }

    SduiLogger.info('Successfully parsed ${parsedSections.length} sections.');

    return SduiConfig(
      sections: parsedSections,
      backgroundColorValue: JsonParserUtils.safeInt(
        json['backgroundColorValue'],
        strict: strictMode,
      ),
      appBar:
          null, // AppBar is untyped flutter widget, omitted from typical pure JSON representations.
    );
  }
}
