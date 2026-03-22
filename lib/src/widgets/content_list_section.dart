import 'package:flutter/material.dart';
import '../models/section_config.dart';

/// A section that renders a list of content cards either vertically or horizontally.
class ContentListSection extends StatelessWidget {
  final ContentListSectionConfig config;

  const ContentListSection({super.key, required this.config});

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
    if (config.layoutType == ListLayoutType.horizontal) {
      return SizedBox(
        height: config.horizontalHeight ?? 200.0,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: config.items.length,
          separatorBuilder: (context, index) =>
              SizedBox(width: config.itemSpacing),
          itemBuilder: (context, index) {
            return config.items[index].build(context);
          },
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: config.items.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: config.itemSpacing),
        itemBuilder: (context, index) {
          return config.items[index].build(context);
        },
      );
    }
  }
}
