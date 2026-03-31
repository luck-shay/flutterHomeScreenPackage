import 'package:equatable/equatable.dart';

/// Defines the types of actions supported natively by the SDUI engine.
enum SduiActionType {
  navigate,
  apiCall,
  analyticsEvent,
  composite, // Used for arrays of actions
  unknown;

  static SduiActionType fromString(String? typeStr) {
    if (typeStr == null) return SduiActionType.unknown;
    switch (typeStr.toLowerCase()) {
      case 'navigate':
        return SduiActionType.navigate;
      case 'api_call':
        return SduiActionType.apiCall;
      case 'analytics_event':
        return SduiActionType.analyticsEvent;
      case 'composite':
        return SduiActionType.composite;
      default:
        return SduiActionType.unknown;
    }
  }
}

/// A structured declarative action intended to be delegated to the host app.
/// This prevents the SDUI package from coupling to GoRouter, Bloc, etc.
class SduiAction extends Equatable {
  final SduiActionType type;
  final String? route;
  final Map<String, dynamic>? params;
  final List<SduiAction>? actions; // For composite actions

  const SduiAction({required this.type, this.route, this.params, this.actions});

  /// Safely parses an action block, supporting composite arrays seamlessly.
  static SduiAction? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    final typeStr = json['type'] as String?;
    final type = SduiActionType.fromString(typeStr);

    if (type == SduiActionType.unknown) {
      return null;
    }

    if (type == SduiActionType.composite) {
      final rawActions = json['actions'] as List<dynamic>? ?? [];
      final parsedActions = rawActions
          .map((a) => a is Map<String, dynamic> ? SduiAction.fromJson(a) : null)
          .whereType<SduiAction>()
          .toList();

      if (parsedActions.isEmpty) return null;

      return SduiAction(type: type, actions: parsedActions);
    }

    return SduiAction(
      type: type,
      route: json['route'] as String?,
      params: json['params'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [type, route, params, actions];
}
