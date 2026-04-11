import 'package:flutter/material.dart';
import '../models/sdui_config.dart';
import '../models/sdui_section_config.dart';
import '../theme/sdui_theme_delegate.dart';
import '../widgets/action_grid_section.dart';
import '../widgets/banner_section.dart';
import '../widgets/content_list_section.dart';
import 'sdui_action_handler.dart';

/// The central entry point widget for the Modular Home Screen package.
/// This widget expects a [SduiConfig] to define the layout structure.
class SduiScreen extends StatelessWidget {
  /// The structural layout configuration.
  final SduiConfig config;

  /// The optional delegate to control granular styling.
  final SduiThemeDelegate themeDelegate;

  /// The optional action handler delegate for interactive schemas.
  final SduiActionHandler? actionHandler;

  /// Triggered whenever a scroll boundary approaches the end of a paginated section.
  /// Provides the specific section config and the JSON `nextPageUrl` endpoint.
  final void Function(SduiSectionConfig section, String nextPageUrl)?
  onLoadMore;

  const SduiScreen({
    super.key,
    required this.config,
    this.themeDelegate = const SduiThemeDelegate(),
    this.actionHandler,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          config.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: config.appBar != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: config.appBar!,
            )
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (onLoadMore != null &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
            // Find the last section, which conventionally handles the vertical infinite scrolling.
            if (config.sections.isNotEmpty) {
              final lastSection = config.sections.last;
              if (lastSection is ContentListSectionConfig &&
                  lastSection.layoutType == ListLayoutType.vertical &&
                  lastSection.hasMore &&
                  lastSection.nextPageUrl != null) {
                onLoadMore!(lastSection, lastSection.nextPageUrl!);
              } else if (lastSection is ActionGridSectionConfig &&
                  lastSection.hasMore &&
                  lastSection.nextPageUrl != null) {
                onLoadMore!(lastSection, lastSection.nextPageUrl!);
              }
            }
          }
          return false;
        },
        child: actionHandler != null
            ? SduiActionHandlerProvider(
                handler: actionHandler!,
                child: _buildScrollView(),
              )
            : _buildScrollView(),
      ),
    );
  }

  Widget _buildScrollView() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: themeDelegate.screenPadding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final sectionConfig = config.sections[index];
              // Use the override spacing from the section config, or fallback to the theme delegate.
              final bottomSpacing =
                  sectionConfig.spacingBelow ?? themeDelegate.sectionSpacing;

              return Padding(
                key: sectionConfig.id != null
                    ? ValueKey('section_${sectionConfig.id}')
                    : null,
                padding: EdgeInsets.only(bottom: bottomSpacing),
                child: _buildSection(context, sectionConfig),
              );
            }, childCount: config.sections.length),
          ),
        ),
      ],
    );
  }

  /// Parses the base [SduiSectionConfig] and routes it to the correct widget renderer.
  Widget _buildSection(BuildContext context, SduiSectionConfig sectionConfig) {
    try {
      if (sectionConfig is HeaderSectionConfig) {
        return _buildHeaderSection(context, sectionConfig);
      } else if (sectionConfig is BannerSectionConfig) {
        return _buildBannerSection(context, sectionConfig);
      } else if (sectionConfig is ActionGridSectionConfig) {
        return _buildActionGridSection(context, sectionConfig);
      } else if (sectionConfig is ContentListSectionConfig) {
        return _buildContentListSection(context, sectionConfig);
      } else if (sectionConfig is DividerSectionConfig) {
        return _buildDividerSection(context, sectionConfig);
      } else if (sectionConfig is CustomSectionConfig) {
        return sectionConfig.builder(context);
      }

      // Fallback for an unknown section type.
      return const SizedBox.shrink();
    } catch (e, _) {
      debugPrint('SduiScreen: Error building section ${sectionConfig.id}: $e');
      if (config.errorWidgetBuilder != null) {
        return config.errorWidgetBuilder!(context, e);
      }
      return const SizedBox.shrink();
    }
  }

  Widget _buildHeaderSection(BuildContext context, HeaderSectionConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                config.title,
                style:
                    themeDelegate.sectionHeaderTextStyle ??
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (config.trailingAction != null)
              config.trailingAction!.build(context),
          ],
        ),
        if (config.subtitle != null) ...[
          const SizedBox(height: 8.0),
          Text(
            config.subtitle!,
            style:
                themeDelegate.sectionSubtitleTextStyle ??
                Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildBannerSection(BuildContext context, BannerSectionConfig config) {
    return BannerSection(config: config);
  }

  Widget _buildActionGridSection(
    BuildContext context,
    ActionGridSectionConfig config,
  ) {
    return ActionGridSection(config: config);
  }

  Widget _buildContentListSection(
    BuildContext context,
    ContentListSectionConfig config,
  ) {
    return ContentListSection(config: config, onLoadMore: onLoadMore);
  }

  Widget _buildDividerSection(
    BuildContext context,
    DividerSectionConfig config,
  ) {
    return Divider(
      height: config.height,
      thickness: config.thickness,
      color: config.colorValue != null ? Color(config.colorValue!) : null,
    );
  }
}
