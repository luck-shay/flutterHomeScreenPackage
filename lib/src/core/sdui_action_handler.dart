import 'package:flutter/widgets.dart';
import '../models/sdui_action.dart';

/// An abstract pure delegate provided by the host application.
///
/// The [SduiScreen] orchestrator depends on this to propagate [SduiAction]s
/// (e.g., tap events, tracking events) out to the host without coupling to
/// a specific state manager (like Bloc) or routing system (like GoRouter).
abstract class SduiActionHandler {
  /// Invoked whenever a parsed SDUI component triggers an action block.
  void onAction(BuildContext context, SduiAction action);
}

/// A provider that injects the [SduiActionHandler] down the widget tree
/// so deeply nested layout components can trigger remote actions natively.
class SduiActionHandlerProvider extends InheritedWidget {
  final SduiActionHandler handler;

  const SduiActionHandlerProvider({
    super.key,
    required this.handler,
    required super.child,
  });

  static SduiActionHandler? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SduiActionHandlerProvider>()
        ?.handler;
  }

  @override
  bool updateShouldNotify(SduiActionHandlerProvider oldWidget) {
    return handler != oldWidget.handler;
  }
}
