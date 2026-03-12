import 'package:flutter/widgets.dart';
import 'section_config.dart';

/// The root configuration object passed to the ModularHomeScreen.
class HomeConfig {
  /// The list of section configurations that define the layout.
  final List<HomeSectionConfig> sections;

  /// An optional app bar to use at the top of the scroll view.
  final Widget? appBar;

  /// Background color of the home screen.
  final Color? backgroundColor;

  const HomeConfig({required this.sections, this.appBar, this.backgroundColor});
}
