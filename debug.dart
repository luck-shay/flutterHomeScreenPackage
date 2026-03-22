import 'package:home_library/home_library.dart';

void main() {
  try {
    final strictRegistry = ComponentRegistry();
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
    HomeConfig.fromJson(jsonPayload, componentRegistry: strictRegistry);
  } catch (e, st) {
    print('Exception 1: $e');
    print(st);
  }

  try {
    final jsonPayload2 = {
      'version': 1,
      'sections': [
        {'type': 'divider'}, // Missing all optional attributes
        {'type': 'banner'}, // Missing banners array
      ],
    };
    HomeConfig.fromJson(jsonPayload2, componentRegistry: ComponentRegistry());
  } catch (e, st) {
    print('Exception 2: $e');
    print(st);
  }
}
