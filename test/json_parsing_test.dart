import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_library/home_library.dart';
import 'package:home_library/src/core/exceptions.dart';

class StubStringConfig extends ItemConfig {
  final String text;

  const StubStringConfig({required this.text, super.id});

  @override
  Widget build(BuildContext context) => Text(text);

  @override
  List<Object?> get props => super.props..add(text);
}

void main() {
  group('HomeConfig JSON Parsing Tests', () {
    late ComponentRegistry registry;

    setUp(() {
      registry = ComponentRegistry(
        fallbackBuilder: (type, json) =>
            StubStringConfig(text: 'Fallback: $type'),
      );
      registry.register(
        'string_item',
        (json) => StubStringConfig(text: json['text'] as String),
      );
    });

    test('Parses a complete valid configuration', () {
      final jsonPayload = {
        'version': 1,
        'sections': [
          {
            'type': 'header',
            'id': 'header_section',
            'title': 'My Header',
            'subtitle': 'Sub',
          },
          {
            'type': 'content_list',
            'id': 'list_section',
            'title': 'My List',
            'layoutType': 'horizontal',
            'items': [
              {'type': 'string_item', 'text': 'Item A'},
              {'type': 'unknown_magic', 'info': 'lost'},
            ],
          },
        ],
      };

      final parsed = HomeConfig.fromJson(
        jsonPayload,
        componentRegistry: registry,
      );

      expect(parsed.sections.length, 2);

      final header = parsed.sections[0] as HeaderSectionConfig;
      expect(header.id, 'header_section');
      expect(header.title, 'My Header');
      expect(header.subtitle, 'Sub');

      final list = parsed.sections[1] as ContentListSectionConfig;
      expect(list.id, 'list_section');
      expect(list.layoutType, ListLayoutType.horizontal);
      expect(list.items.length, 2);

      // Verify explicit parse mapped to the core builder
      final firstItem = list.items[0] as StubStringConfig;
      expect(firstItem.text, 'Item A');

      // Verify the fallback handled the unknown type correctly
      final fallbackItem = list.items[1] as StubStringConfig;
      expect(fallbackItem.text, 'Fallback: unknown_magic');
    });

    test('Throws JsonValidationException on unsupported version', () {
      final jsonPayload = {
        'version': 999, // Unsupported
        'sections': [],
      };

      expect(
        () => HomeConfig.fromJson(jsonPayload, componentRegistry: registry),
        throwsA(isA<JsonValidationException>()),
      );
    });

    test('Throws UnknownSectionException for unregistered section wrapper', () {
      final jsonPayload = {
        'version': 1,
        'sections': [
          {'type': 'not_a_real_section'},
        ],
      };

      expect(
        () => HomeConfig.fromJson(jsonPayload, componentRegistry: registry),
        throwsA(isA<UnknownSectionException>()),
      );
    });

    test('Throws UnknownComponentException if no fallback provided', () {
      final strictRegistry = ComponentRegistry(); // no fallback

      final jsonPayload = {
        'version': 1,
        'sections': [
          {
            'type': 'action_grid',
            'actions': [
              {'type': 'ghost_button'},
            ],
          },
        ],
      };

      expect(
        () =>
            HomeConfig.fromJson(jsonPayload, componentRegistry: strictRegistry),
        throwsA(isA<UnknownComponentException>()),
      );
    });

    test('Validates empty and partial states do not crash', () {
      final jsonPayload = {
        'version': 1,
        'sections': [
          {'type': 'divider'}, // Missing all optional attributes
          {'type': 'banner'}, // Missing banners array
        ],
      };

      final parsed = HomeConfig.fromJson(
        jsonPayload,
        componentRegistry: registry,
      );
      expect(parsed.sections.length, 2);

      final divider = parsed.sections[0] as DividerSectionConfig;
      expect(divider.height, 32.0); // Default applied

      final banner = parsed.sections[1] as BannerSectionConfig;
      expect(banner.banners, isEmpty);
    });
  });
}
