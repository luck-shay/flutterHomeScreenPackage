import 'package:flutter/material.dart';
import '../../home_library.dart';

/// A ready-to-use Social Feed home screen template.
class SocialFeedTemplate extends StatelessWidget {
  /// The title of the feed.
  final String title;

  /// App bar actions (e.g., DM icon, search).
  final List<Widget>? appBarActions;

  /// A list of 'stories' or horizontal scrolling user updates.
  final List<Widget> stories;

  /// The core feed posts. We use `CustomSectionConfig` here usually, or ContentList.
  final List<Widget> feedPosts;

  /// Optional custom theme delegate.
  final HomeThemeDelegate? themeDelegate;

  const SocialFeedTemplate({
    super.key,
    this.title = 'Feed',
    this.appBarActions,
    this.stories = const [],
    this.feedPosts = const [],
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
          if (stories.isNotEmpty) ...[
            ContentListSectionConfig(
              title: '', // typically stories have no explicit title in UI
              layoutType: ListLayoutType.horizontal,
              horizontalHeight: 120, // tall enough for avatars + text
              items: stories,
            ),
            const DividerSectionConfig(height: 16, thickness: 1),
          ],

          if (feedPosts.isNotEmpty)
            CustomSectionConfig(
              builder: (context) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: feedPosts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => feedPosts[index],
                );
              },
            ),
        ],
      ),
    );
  }
}
