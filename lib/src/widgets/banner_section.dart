import 'package:flutter/material.dart';
import '../models/sdui_section_config.dart';

/// A section that renders a list of promotional or informational banners.
class BannerSection extends StatefulWidget {
  final BannerSectionConfig config;

  const BannerSection({super.key, required this.config});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // In a real production package with `autoPlay: true`, you would start a
    // timer here to advance `_pageController.nextPage`.
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.config.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.config.layoutType == BannerLayoutType.carousel) {
      return SizedBox(
        height: 200, // Fixed height or could be obtained from a theme delegate.
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.config.banners.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  16.0,
                ), // Hardcoded for now. In prod rely on SduiThemeDelegate
                child: widget.config.banners[index].build(context),
              ),
            );
          },
        ),
      );
    } else {
      // Standard stacked layout
      return Column(
        children: widget.config.banners.map((bannerWidget) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: bannerWidget.build(context),
            ),
          );
        }).toList(),
      );
    }
  }
}
