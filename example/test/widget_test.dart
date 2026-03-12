import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('ExampleApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    // Verify that our app renders the header
    expect(find.text('Good Morning, Jane!'), findsOneWidget);
  });
}
