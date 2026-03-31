import 'package:flutter/material.dart';
import '../models/sdui_section_config.dart';

/// A section that renders a flexible grid of actions/icons.
class ActionGridSection extends StatelessWidget {
  final ActionGridSectionConfig config;

  const ActionGridSection({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    if (config.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    // We compute the child aspect ratio assuming standard icon sizing, but in a real scenario
    // this would be highly configurable or handled using a Wrap/Flow widget or GridView with
    // a customized delegate.
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisSpacing = config.spacing;
        final mainAxisSpacing = config.spacing;

        // Basic calculation to ensure squares if no height is provided.
        final itemWidth =
            (constraints.maxWidth -
                (crossAxisSpacing * (config.crossAxisCount - 1))) /
            config.crossAxisCount;
        final itemHeight = itemWidth; // Default to square if not specified
        final childAspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: config.crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount:
              config.actions.length +
              (config.hasMore ? config.crossAxisCount : 0),
          itemBuilder: (context, index) {
            if (index >= config.actions.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return config.actions[index].build(context);
          },
        );
      },
    );
  }
}
