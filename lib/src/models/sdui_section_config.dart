import 'package:flutter/widgets.dart';
import '../core/component_registry.dart';
import '../core/item_config.dart';
import '../core/json_parser_utils.dart';
import '../core/validation_result.dart';

/// The abstract base class that all section configurations must extend.
abstract class SduiSectionConfig {
  /// Optional ID string used for server-driven UI diffing and component location.
  final String? id;

  /// Optional spacing override below this section.
  /// If not provided, it falls back to spacing defined in ThemeDelegate.
  final double? spacingBelow;

  const SduiSectionConfig({this.id, this.spacingBelow});
}

/// A custom section that allows developers to inject any widget into the layout programmatically.
/// Custom sections cannot be instantiated from a generic JSON payload.
class CustomSectionConfig extends SduiSectionConfig {
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
class ContentListSectionConfig extends SduiSectionConfig {
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

  /// Indicates if infinite scroll boundaries exist for this list.
  final bool hasMore;

  /// Optional endpoint token consumed natively by the scroll handlers.
  final String? nextPageUrl;

  const ContentListSectionConfig({
    required this.title,
    required this.items,
    this.layoutType = ListLayoutType.vertical,
    this.itemSpacing = 16.0,
    this.horizontalHeight = 200.0,
    this.hasMore = false,
    this.nextPageUrl,
    super.id,
    super.spacingBelow,
  });

  factory ContentListSectionConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? registry,
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    if (registry == null) {
      throw ArgumentError(
        'ComponentRegistry is required to parse ContentListSectionConfig items from JSON.',
      );
    }

    final typeStr = JsonParserUtils.safeString(
      json['layoutType'],
      strict: strictMode,
      fieldName: 'layoutType',
    );
    final layoutType = typeStr == 'horizontal'
        ? ListLayoutType.horizontal
        : ListLayoutType.vertical;

    final rawItems = json['items'] as List<dynamic>? ?? [];
    final parsedItems = rawItems
        .map(
          (item) => registry.buildComponent(
            item as Map<String, dynamic>? ?? {},
            strictMode: strictMode,
            validationResult: validationResult,
          ),
        )
        .toList();

    return ContentListSectionConfig(
      id: JsonParserUtils.safeString(
        json['id'],
        strict: strictMode,
        fieldName: 'id',
      ),
      title:
          JsonParserUtils.safeString(
            json['title'],
            strict: strictMode,
            fieldName: 'title',
          ) ??
          '',
      items: parsedItems,
      layoutType: layoutType,
      itemSpacing:
          JsonParserUtils.safeDouble(
            json['itemSpacing'],
            strict: strictMode,
            fieldName: 'itemSpacing',
          ) ??
          16.0,
      horizontalHeight:
          JsonParserUtils.safeDouble(
            json['horizontalHeight'],
            strict: strictMode,
            fieldName: 'horizontalHeight',
          ) ??
          200.0,
      hasMore:
          JsonParserUtils.safeBool(
            json['hasMore'],
            strict: strictMode,
            fieldName: 'hasMore',
          ) ??
          false,
      nextPageUrl: JsonParserUtils.safeString(
        json['nextPageUrl'],
        strict: strictMode,
        fieldName: 'nextPageUrl',
      ),
      spacingBelow: JsonParserUtils.safeDouble(
        json['spacingBelow'],
        strict: strictMode,
        fieldName: 'spacingBelow',
      ),
    );
  }
}

/// Configuration for a grid of quick actions.
class ActionGridSectionConfig extends SduiSectionConfig {
  /// Number of columns in the grid.
  final int crossAxisCount;

  /// The actions (item configs) to display in the grid.
  final List<ItemConfig> actions;

  /// Spacing between rows and columns.
  final double spacing;

  /// Indicates if infinite scroll boundaries exist natively for this grid.
  final bool hasMore;

  /// Endpoint cursor token.
  final String? nextPageUrl;

  const ActionGridSectionConfig({
    required this.actions,
    this.crossAxisCount = 4,
    this.spacing = 16.0,
    this.hasMore = false,
    this.nextPageUrl,
    super.id,
    super.spacingBelow,
  });

  factory ActionGridSectionConfig.fromJson(
    Map<String, dynamic> json, {
    ComponentRegistry? registry,
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    if (registry == null) {
      throw ArgumentError(
        'ComponentRegistry is required to parse ActionGridSectionConfig actions from JSON.',
      );
    }

    final rawActions = json['actions'] as List<dynamic>? ?? [];
    final parsedActions = rawActions
        .map(
          (item) => registry.buildComponent(
            item as Map<String, dynamic>? ?? {},
            strictMode: strictMode,
            validationResult: validationResult,
          ),
        )
        .toList();

    return ActionGridSectionConfig(
      id: JsonParserUtils.safeString(
        json['id'],
        strict: strictMode,
        fieldName: 'id',
      ),
      actions: parsedActions,
      crossAxisCount:
          JsonParserUtils.safeInt(
            json['crossAxisCount'],
            strict: strictMode,
            fieldName: 'crossAxisCount',
          ) ??
          4,
      spacing:
          JsonParserUtils.safeDouble(
            json['spacing'],
            strict: strictMode,
            fieldName: 'spacing',
          ) ??
          16.0,
      hasMore:
          JsonParserUtils.safeBool(
            json['hasMore'],
            strict: strictMode,
            fieldName: 'hasMore',
          ) ??
          false,
      nextPageUrl: JsonParserUtils.safeString(
        json['nextPageUrl'],
        strict: strictMode,
        fieldName: 'nextPageUrl',
      ),
      spacingBelow: JsonParserUtils.safeDouble(
        json['spacingBelow'],
        strict: strictMode,
        fieldName: 'spacingBelow',
      ),
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
class BannerSectionConfig extends SduiSectionConfig {
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
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    if (registry == null) {
      throw ArgumentError(
        'ComponentRegistry is required to parse BannerSectionConfig banners from JSON.',
      );
    }

    final typeStr = JsonParserUtils.safeString(
      json['layoutType'],
      strict: strictMode,
      fieldName: 'layoutType',
    );
    final layoutType = typeStr == 'carousel'
        ? BannerLayoutType.carousel
        : BannerLayoutType.standard;

    final rawBanners = json['banners'] as List<dynamic>? ?? [];
    final parsedBanners = rawBanners
        .map(
          (item) => registry.buildComponent(
            item as Map<String, dynamic>? ?? {},
            strictMode: strictMode,
            validationResult: validationResult,
          ),
        )
        .toList();

    return BannerSectionConfig(
      id: JsonParserUtils.safeString(
        json['id'],
        strict: strictMode,
        fieldName: 'id',
      ),
      banners: parsedBanners,
      layoutType: layoutType,
      autoPlay:
          JsonParserUtils.safeBool(
            json['autoPlay'],
            strict: strictMode,
            fieldName: 'autoPlay',
          ) ??
          true,
      spacingBelow: JsonParserUtils.safeDouble(
        json['spacingBelow'],
        strict: strictMode,
        fieldName: 'spacingBelow',
      ),
    );
  }
}

/// Configuration for a visual divider between sections.
class DividerSectionConfig extends SduiSectionConfig {
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

  factory DividerSectionConfig.fromJson(
    Map<String, dynamic> json, {
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    return DividerSectionConfig(
      id: JsonParserUtils.safeString(
        json['id'],
        strict: strictMode,
        fieldName: 'id',
      ),
      height:
          JsonParserUtils.safeDouble(
            json['height'],
            strict: strictMode,
            fieldName: 'height',
          ) ??
          32.0,
      thickness: JsonParserUtils.safeDouble(
        json['thickness'],
        strict: strictMode,
        fieldName: 'thickness',
      ),
      colorValue: JsonParserUtils.safeInt(
        json['colorValue'],
        strict: strictMode,
        fieldName: 'colorValue',
      ),
      spacingBelow: JsonParserUtils.safeDouble(
        json['spacingBelow'],
        strict: strictMode,
        fieldName: 'spacingBelow',
      ),
    );
  }
}

/// Configuration for the header of the home screen.
class HeaderSectionConfig extends SduiSectionConfig {
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

  factory HeaderSectionConfig.fromJson(
    Map<String, dynamic> json, {
    bool strictMode = false,
    ValidationResult? validationResult,
  }) {
    return HeaderSectionConfig(
      id: JsonParserUtils.safeString(
        json['id'],
        strict: strictMode,
        fieldName: 'id',
      ),
      title:
          JsonParserUtils.safeString(
            json['title'],
            strict: strictMode,
            fieldName: 'title',
          ) ??
          '',
      subtitle: JsonParserUtils.safeString(
        json['subtitle'],
        strict: strictMode,
        fieldName: 'subtitle',
      ),
      spacingBelow: JsonParserUtils.safeDouble(
        json['spacingBelow'],
        strict: strictMode,
        fieldName: 'spacingBelow',
      ),
    );
  }
}
