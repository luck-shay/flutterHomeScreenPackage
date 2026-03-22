import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_library/home_library.dart';

void main() {
  testWidgets('ModularHomeScreen renders all configuration sections', (
    WidgetTester tester,
  ) async {
    // 1. Arrange
    final config = HomeConfig(
      appBar: AppBar(title: const Text('Test App Bar')),
      sections: [
        const HeaderSectionConfig(
          title: 'Welcome Test',
          subtitle: 'Test Subtitle',
        ),
        BannerSectionConfig(
          banners: [
            WidgetItemConfig(
              widget: Container(
                key: const Key('banner1'),
                height: 100,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        ActionGridSectionConfig(
          actions: [
            const WidgetItemConfig(
              widget: Icon(Icons.star, key: Key('action1')),
            ),
            const WidgetItemConfig(
              widget: Icon(Icons.star, key: Key('action2')),
            ),
          ],
        ),
        const DividerSectionConfig(height: 10),
        ContentListSectionConfig(
          title: 'List Title',
          items: [
            const WidgetItemConfig(
              widget: Text('Item 1', key: Key('list_item1')),
            ),
          ],
        ),
        CustomSectionConfig(
          builder: (context) =>
              const Text('Custom Widget', key: Key('custom_widget')),
        ),
      ],
    );

    // 2. Act
    await tester.pumpWidget(
      MaterialApp(home: ModularHomeScreen(config: config)),
    );

    // Provide time for the nested layout structures (like GridView) to settle
    await tester.pumpAndSettle();

    // 3. Assert - Check for presence of elements defined in the config
    expect(find.text('Test App Bar'), findsOneWidget);

    // Header
    expect(find.text('Welcome Test'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);

    // Banner
    expect(find.byKey(const Key('banner1')), findsOneWidget);

    // Action Grid
    expect(find.byKey(const Key('action1')), findsOneWidget);
    expect(find.byKey(const Key('action2')), findsOneWidget);

    // Content List
    expect(find.text('List Title'), findsOneWidget);
    expect(find.byKey(const Key('list_item1')), findsOneWidget);

    // Scroll to find the Custom Section which is likely off-screen initially
    final customWidgetFinder = find.byKey(const Key('custom_widget'));
    await tester.scrollUntilVisible(
      customWidgetFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );

    // Custom Section
    expect(customWidgetFinder, findsOneWidget);
  });
}
