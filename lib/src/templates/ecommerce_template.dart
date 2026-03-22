import 'package:flutter/material.dart';
import '../../home_library.dart';

/// A ready-to-use E-commerce home screen template using `ModularHomeScreen`.
class EcommerceTemplate extends StatelessWidget {
  /// The title displayed in the AppBar.
  final String title;

  /// Actions for the AppBar (e.g., shopping cart, notifications).
  final List<Widget>? appBarActions;

  /// The main greeting text.
  final String greetingTitle;

  /// The secondary greeting text.
  final String greetingSubtitle;

  /// A trailing widget for the header (e.g., profile avatar).
  final Widget? profileWidget;

  /// A list of widgets to display in the promotional banner carousel.
  final List<Widget> promoBanners;

  /// A list of widgets to display in the category quick-actions grid.
  final List<Widget> categories;

  /// A list of product sections (e.g., 'Trending Now', 'New Arrivals').
  final List<ContentListSectionConfig> productLists;

  /// Optional theming configuration.
  final HomeThemeDelegate? themeDelegate;

  const EcommerceTemplate({
    super.key,
    this.title = 'Store',
    this.appBarActions,
    this.greetingTitle = 'Welcome!',
    this.greetingSubtitle = 'Discover our latest deals',
    this.profileWidget,
    this.promoBanners = const [],
    this.categories = const [],
    this.productLists = const [],
    this.themeDelegate,
  });

  @override
  Widget build(BuildContext context) {
    return ModularHomeScreen(
      themeDelegate: themeDelegate ?? HomeThemeDelegate(),
      config: HomeConfig(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: appBarActions,
        ),
        sections: [
          HeaderSectionConfig(
            title: greetingTitle,
            subtitle: greetingSubtitle,
            trailingAction: profileWidget != null
                ? WidgetItemConfig(widget: profileWidget!)
                : null,
          ),

          if (promoBanners.isNotEmpty)
            BannerSectionConfig(
              layoutType: BannerLayoutType.carousel,
              autoPlay: true,
              banners: promoBanners
                  .map((w) => WidgetItemConfig(widget: w))
                  .toList(),
            ),

          if (categories.isNotEmpty)
            ActionGridSectionConfig(
              crossAxisCount: categories.length >= 4 ? 4 : categories.length,
              actions: categories
                  .map((w) => WidgetItemConfig(widget: w))
                  .toList(),
            ),

          if ((categories.isNotEmpty || promoBanners.isNotEmpty) &&
              productLists.isNotEmpty)
            const DividerSectionConfig(height: 32, thickness: 1),

          ...productLists,
        ],
      ),
    );
  }
}
