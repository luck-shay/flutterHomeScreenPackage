import 'package:flutter/material.dart';
import '../models/section_config.dart';

/// A section that renders a list of content cards either vertically or horizontally.
class ContentListSection extends StatelessWidget {
  final ContentListSectionConfig config;
  final void Function(HomeSectionConfig section, String nextPageUrl)?
  onLoadMore;

  const ContentListSection({super.key, required this.config, this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    if (config.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.title.isNotEmpty)
          Padding(
            // Normally this padding would come from the ThemeDelegate
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              config.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        _buildList(context),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    final itemCount = config.items.length + (config.hasMore ? 1 : 0);

    if (config.layoutType == ListLayoutType.horizontal) {
      return SizedBox(
        height: config.horizontalHeight ?? 200.0,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (onLoadMore != null &&
                config.hasMore &&
                config.nextPageUrl != null &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 100) {
              onLoadMore!(config, config.nextPageUrl!);
            }
            return false;
          },
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                SizedBox(width: config.itemSpacing),
            itemBuilder: (context, index) {
              if (index == config.items.length) {
                return _buildLoadingIndicator();
              }
              return config.items[index].build(context);
            },
          ),
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) =>
            SizedBox(height: config.itemSpacing),
        itemBuilder: (context, index) {
          if (index == config.items.length) {
            return _buildLoadingIndicator();
          }
          return config.items[index].build(context);
        },
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
