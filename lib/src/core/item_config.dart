import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';

/// The base declarative configuration for any item rendered inside a typical
/// layout section (such as an ActionGrid or ContentList).
///
/// Implementing classes act purely as data models and provide a [build]
/// method to decouple JSON serialization from widget rendering.
abstract class ItemConfig extends Equatable {
  /// Optional unique identifier used for Flutter [Key] generation and diffing.
  final String? id;

  const ItemConfig({this.id});

  /// The automatically derived key based on the provided [id].
  Key? get key => id != null ? ValueKey(id) : null;

  /// Translates this data configuration into a concrete Flutter Widget.
  Widget build(BuildContext context);

  @override
  List<Object?> get props => [id];
}

/// A fallback abstraction for developers building layouts programmatically
/// in code rather than through strict JSON. Not strictly serializable.
class WidgetItemConfig extends ItemConfig {
  final Widget widget;

  const WidgetItemConfig({required this.widget, super.id});

  @override
  Widget build(BuildContext context) =>
      id != null ? KeyedSubtree(key: key, child: widget) : widget;

  @override
  List<Object?> get props => [id, widget];
}
