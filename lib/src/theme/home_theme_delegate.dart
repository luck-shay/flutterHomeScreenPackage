import 'package:flutter/material.dart';

/// A delegate that provides styling and spacing parameters for the Home Screen components.
/// If not provided, the components will fall back to the generic `Theme.of(context)` properties.
class HomeThemeDelegate {
  /// General padding around the edges of the home screen content.
  final EdgeInsetsGeometry screenPadding;

  /// Default spacing applied between different sections.
  final double sectionSpacing;

  /// Corner radius for standard card-like elements (banners, list items, action buttons).
  final BorderRadius cardBorderRadius;

  /// Default elevation for card-like elements.
  final double cardElevation;

  /// Text style overrides for section headers.
  final TextStyle? sectionHeaderTextStyle;

  /// Text style overrides for section subtitles.
  final TextStyle? sectionSubtitleTextStyle;

  /// Base background color of the cards inside sections.
  final Color? cardBackgroundColor;

  const HomeThemeDelegate({
    this.screenPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.sectionSpacing = 24.0,
    this.cardBorderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.cardElevation = 0.0,
    this.sectionHeaderTextStyle,
    this.sectionSubtitleTextStyle,
    this.cardBackgroundColor,
  });

  /// Factory constructor to generate a copy with modified values.
  HomeThemeDelegate copyWith({
    EdgeInsetsGeometry? screenPadding,
    double? sectionSpacing,
    BorderRadius? cardBorderRadius,
    double? cardElevation,
    TextStyle? sectionHeaderTextStyle,
    TextStyle? sectionSubtitleTextStyle,
    Color? cardBackgroundColor,
  }) {
    return HomeThemeDelegate(
      screenPadding: screenPadding ?? this.screenPadding,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      cardElevation: cardElevation ?? this.cardElevation,
      sectionHeaderTextStyle:
          sectionHeaderTextStyle ?? this.sectionHeaderTextStyle,
      sectionSubtitleTextStyle:
          sectionSubtitleTextStyle ?? this.sectionSubtitleTextStyle,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
    );
  }
}
