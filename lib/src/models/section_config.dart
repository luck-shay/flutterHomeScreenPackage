import 'package:flutter/widgets.dart';
import '../core/component_registry.dart';
import '../core/item_config.dart';

/// The abstract base class that all section configurations must extend.
abstract class HomeSectionConfig {
  /// Optional ID string used for server-driven UI diffing and component location.
  final String? id;

  /// Optional spacing override below this section.
  /// If not provided, it falls back to spacing defined in ThemeDelegate.
  final double? spacingBelow;

  const HomeSectionConfig({this.id, this.spacingBelow});
}

/// A custom section that allows developers to inject any widget into the layout programmatically.
/// Custom sections cannot be instantiated from a generic JSON payload.
class CustomSectionConfig extends HomeSectionConfig {
  /// Builder to render the custom widget.
  final WidgetBuilder builder;

  const CustomSectionConfig({
    required this.builder,
    super.id,
    super.spacingBelow,
  });
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

  /// The list of items to render.
  final List<ItemConfig> items;

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
    super.id,
    super.spacingBelow,
  });

  factory ContentListSectionConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? registry,
  }) {
    if (registry == null) {
      throw ArgumentError(
        'ComponentRegistry is required to parse ContentListSectionConfig items from JSON.',
      );
    }

    final typeStr = json['layoutType'] as String?;
    final layoutType = typeStr == 'horizontal'
        ? ListLayoutType.horizontal
        : ListLayoutType.vertical;

    final rawItems = json['items'] as List<dynamic>? ?? [];
    final parsedItems = rawItems
        .map((item) => registry.buildComponent(item as Map<String, dynamic>))
        .toList();

    return ContentListSectionConfig(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      items: parsedItems,
      layoutType: layoutType,
      itemSpacing: (json['itemSpacing'] as num?)?.toDouble() ?? 16.0,
      horizontalHeight: (json['horizontalHeight'] as num?)?.toDouble() ?? 200.0,
      spacingBelow: (json['spacingBelow'] as num?)?.toDouble(),
    );
  }
}

/// Configuration for a grid of quick actions.
class ActionGridSectionConfig extends HomeSectionConfig {
  /// Number of columns in the grid.
  final int crossAxisCount;

  /// The actions (item configs) to display in the grid.
  final List<ItemConfig> actions;

  /// Spacing between rows and columns.
  final double spacing;

  const ActionGridSectionConfig({
    required this.actions,
    this.crossAxisCount = 4,
    this.spacing = 16.0,
    super.id,
    super.spacingBelow,
  });

  factory ActionGridSectionConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? registry,
  }) {
    if (registry == null) {
      throw ArgumentError(
        'ComponentRegistry is required to parse ActionGridSectionConfig actions from JSON.',
      );
    }

    final rawActions = json['actions'] as List<dynamic>? ?? [];
    final parsedActions = rawActions
        .map((item) => registry.buildComponent(item as Map<String, dynamic>))
        .toList();

    return ActionGridSectionConfig(
      id: json['id'] as String?,
      actions: parsedActions,
      crossAxisCount: json['crossAxisCount'] as int? ?? 4,
      spacing: (json['spacing'] as num?)?.toDouble() ?? 16.0,
      spacingBelow: (json['spacingBelow'] as num?)?.toDouble(),
    );
  }
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

  /// The list of banner components to render in the carousel/stack.
  final List<ItemConfig> banners;

  /// If true, the carousel will automatically play (only applies if layoutType is carousel).
  final bool autoPlay;

  const BannerSectionConfig({
    required this.banners,
    this.layoutType = BannerLayoutType.standard,
    this.autoPlay = true,
    super.id,
    super.spacingBelow,
  });

  factory BannerSectionConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? registry,
  }) {
    if (registry == null) {
      throw ArgumentError(
        'ComponentRegistry is required to parse BannerSectionConfig banners from JSON.',
      );
    }

    final typeStr = json['layoutType'] as String?;
    final layoutType = typeStr == 'carousel'
        ? BannerLayoutType.carousel
        : BannerLayoutType.standard;

    final rawBanners = json['banners'] as List<dynamic>? ?? [];
    final parsedBanners = rawBanners
        .map((item) => registry.buildComponent(item as Map<String, dynamic>))
        .toList();

    return BannerSectionConfig(
      id: json['id'] as String?,
      banners: parsedBanners,
      layoutType: layoutType,
      autoPlay: json['autoPlay'] as bool? ?? true,
      spacingBelow: (json['spacingBelow'] as num?)?.toDouble(),
    );
  }
}

/// Configuration for a visual divider between sections.
class DividerSectionConfig extends HomeSectionConfig {
  /// The vertical space the divider occupies.
  final double height;

  /// The optional thickness of the rendered line.
  final double? thickness;

  /// The optional hex color of the rendered line matching layout data.
  final int? colorValue;

  const DividerSectionConfig({
    this.height = 32.0,
    this.thickness,
    this.colorValue,
    super.id,
    super.spacingBelow,
  });

  factory DividerSectionConfig.fromJson(Map<String, dynamic> json) {
    return DividerSectionConfig(
      id: json['id'] as String?,
      height: (json['height'] as num?)?.toDouble() ?? 32.0,
      thickness: (json['thickness'] as num?)?.toDouble(),
      colorValue: json['colorValue'] as int?,
      spacingBelow: (json['spacingBelow'] as num?)?.toDouble(),
    );
  }
}

/// Configuration for the header of the home screen.
class HeaderSectionConfig extends HomeSectionConfig {
  /// The main greeting or title text.
  final String title;

  /// Optional subtitle below the main text.
  final String? subtitle;

  /// Optional programmatic or configured trailing action (like a profile picture).
  final ItemConfig? trailingAction;

  const HeaderSectionConfig({
    required this.title,
    this.subtitle,
    this.trailingAction,
    super.id,
    super.spacingBelow,
  });

  factory HeaderSectionConfig.fromJson(Map<String, dynamic> json) {
    return HeaderSectionConfig(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      spacingBelow: (json['spacingBelow'] as num?)?.toDouble(),
    );
  }
}
