import 'package:flutter/widgets.dart';
import '../core/component_registry.dart';
import '../core/section_registry.dart';
import '../core/exceptions.dart';
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
  }) {
    final version = json['version'] as int?;
    if (version != currentSupportedVersion) {
      throw JsonValidationException(
        'Unsupported JSON config version. Expected $currentSupportedVersion, but got $version.',
      );
    }

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

    return HomeConfig(
      sections: parsedSections,
      backgroundColorValue: json['backgroundColorValue'] as int?,
      appBar:
          null, // AppBar is untyped flutter widget, omitted from typical pure JSON representations.
    );
  }
}
