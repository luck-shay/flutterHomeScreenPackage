import 'package:flutter/widgets.dart';

/// The abstract base class that all section configurations must extend.
abstract class HomeSectionConfig {
  /// Optional spacing override below this section.
  /// If not provided, it falls back to spacing defined in ThemeDelegate.
  final double? spacingBelow;

  const HomeSectionConfig({this.spacingBelow});
}

/// A custom section that allows developers to inject any widget into the layout.
class CustomSectionConfig extends HomeSectionConfig {
  /// Builder to render the custom widget.
  final WidgetBuilder builder;

  const CustomSectionConfig({required this.builder, super.spacingBelow});
}

/// Defines the layout type for content lists.
enum ListLayoutType {
  /// Scrolling horizontally
  horizontal,

  /// Scrolling vertically
  vertical,
}

/// Configuration for a list of items (e.g. Products, recent news, etc.)
class ContentListSectionConfig extends HomeSectionConfig {
  /// The title of the list section.
  final String title;

  /// The list of widgets to render.
  final List<Widget> items;

  /// Whether the list should scroll horizontally or vertically.
  final ListLayoutType layoutType;

  /// Spacing between items.
  final double itemSpacing;

  /// The height of the section if scrolling horizontally.
  final double? horizontalHeight;

  const ContentListSectionConfig({
    required this.title,
    required this.items,
    this.layoutType = ListLayoutType.vertical,
    this.itemSpacing = 16.0,
    this.horizontalHeight = 200.0,
    super.spacingBelow,
  });
}

/// Configuration for a grid of quick actions.
class ActionGridSectionConfig extends HomeSectionConfig {
  /// Number of columns in the grid.
  final int crossAxisCount;

  /// The actions (widgets) to display in the grid.
  final List<Widget> actions;

  /// Spacing between rows and columns.
  final double spacing;

  const ActionGridSectionConfig({
    required this.actions,
    this.crossAxisCount = 4,
    this.spacing = 16.0,
    super.spacingBelow,
  });
}

/// Defines the layout type for banners.
enum BannerLayoutType {
  /// A single full-width banner
  standard,

  /// A carousel of sliding banners
  carousel,
}

/// Configuration for a promotional or informative banner section.
class BannerSectionConfig extends HomeSectionConfig {
  /// The layout style of the banner.
  final BannerLayoutType layoutType;

  /// The list of banner widgets to render in the carousel/stack.
  final List<Widget> banners;

  /// If true, the carousel will automatically play (only applies if layoutType is carousel).
  final bool autoPlay;

  const BannerSectionConfig({
    required this.banners,
    this.layoutType = BannerLayoutType.standard,
    this.autoPlay = true,
    super.spacingBelow,
  });
}

/// Configuration for a visual divider between sections.
class DividerSectionConfig extends HomeSectionConfig {
  /// The vertical space the divider occupies.
  final double height;

  /// The optional thickness of the rendered line.
  final double? thickness;

  /// The optional color of the rendered line.
  final Color? color;

  const DividerSectionConfig({
    this.height = 32.0,
    this.thickness,
    this.color,
    super.spacingBelow,
  });
}

/// Configuration for the header of the home screen.
class HeaderSectionConfig extends HomeSectionConfig {
  /// The main greeting or title text.
  final String title;

  /// Optional subtitle below the main text.
  final String? subtitle;

  /// Optional widget for actions or a profile picture at the trailing edge.
  final Widget? trailingWidget;

  const HeaderSectionConfig({
    required this.title,
    this.subtitle,
    this.trailingWidget,
    super.spacingBelow,
  });
}
