import 'package:flutter/material.dart';
import '../../home_library.dart';

/// A ready-to-use Dashboard home screen template (Analytics, Admin panels).
class DashboardTemplate extends StatelessWidget {
  /// The title of the dashboard.
  final String title;

  /// Actions for the app bar.
  final List<Widget>? appBarActions;

  /// The user's welcome text.
  final String greetingTitle;

  /// The user's welcome subtitle (e.g., "Here is your weekly summary").
  final String greetingSubtitle;

  /// A grid of key statistics or quick actions.
  final List<Widget> statWidgets;

  /// The number of columns in the stats grid.
  final int statsCrossAxisCount;

  /// A list of recent activity items or notifications.
  final List<Widget> recentActivity;

  /// Any additional custom sections to append to the dashboard.
  final List<HomeSectionConfig> additionalSections;

  /// Optional custom theme delegate.
  final HomeThemeDelegate? themeDelegate;

  const DashboardTemplate({
    super.key,
    this.title = 'Dashboard',
    this.appBarActions,
    this.greetingTitle = 'Hello, Admin!',
    this.greetingSubtitle = 'Here computes your system summary',
    this.statWidgets = const [],
    this.statsCrossAxisCount = 2,
    this.recentActivity = const [],
    this.additionalSections = const [],
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
          elevation: 0,
        ),
        sections: [
          HeaderSectionConfig(title: greetingTitle, subtitle: greetingSubtitle),

          if (statWidgets.isNotEmpty)
            ActionGridSectionConfig(
              crossAxisCount: statsCrossAxisCount,
              actions: statWidgets,
            ),

          if (statWidgets.isNotEmpty && recentActivity.isNotEmpty)
            const DividerSectionConfig(height: 32, thickness: 1),

          if (recentActivity.isNotEmpty)
            ContentListSectionConfig(
              title: 'Recent Activity',
              layoutType: ListLayoutType.vertical,
              items: recentActivity,
            ),

          ...additionalSections,
        ],
      ),
    );
  }
}
