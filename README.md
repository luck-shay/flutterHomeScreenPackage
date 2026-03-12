# Modular Home Screen (`home_library`)

A highly robust, professional, and declarative Flutter library for composing incredibly tailored, dynamic, and beautiful home screens and dashboards in minutes.

Stop rewriting standard home screen scroll behaviors, sticky headers, and complicated grids. This package utilizes a hyper-performant `CustomScrollView` + `Sliver` architecture backing a powerfully simple declarative configuration API. 

## ✨ Features

- **Declarative Configuration:** Build complex layouts easily via typed data models rather than nesting dozens of widgets.
- **Built-in Section Drivers:**
    - `HeaderSectionConfig`: Greeting headers with trailing widgets.
    - `BannerSectionConfig`: Stacked or Carousel hero image promotions.
    - `ActionGridSectionConfig`: Grid/row actions natively supporting tight configurations.
    - `ContentListSectionConfig`: Scrollable horizontals or vertical lists of standard content cards.
    - `DividerSectionConfig`: Semantic custom-styled dividers.
- **Custom Section Injection:** Never get stuck. Render literally anything at any point in the scroll view using the `CustomSectionConfig` via the standard builder pattern.
- **Deep Theming:** Automatically inherits the host environment `ThemeData`, but trivially overridable via the `HomeThemeDelegate` for padding, radii, backgrounds, and typo-styles.
- **State Management Agnostic:** Hook tap callbacks natively inside the component builders without fighting arbitrary framework limits.

## 🚀 Getting Started

In your `pubspec.yaml`:
```yaml
dependencies:
  home_library: ^0.0.1
```

## 💻 Example Usage

Use the orchestrator widget `ModularHomeScreen` and pass it your declarative `HomeConfig`:

```dart
import 'package:flutter/material.dart';
import 'package:home_library/home_library.dart';

class MyBeautifulHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModularHomeScreen(
      config: HomeConfig(
        appBar: AppBar(title: const Text('My App')),
        sections: [
          
          HeaderSectionConfig(
            title: 'Welcome Back!',
            subtitle: 'Ready to build awesome apps?',
          ),

          BannerSectionConfig(
            layoutType: BannerLayoutType.carousel,
            banners: [ // Your List<Widget> of Banner Items
              Image.network('https://via.placeholder.com/400x200'),
              Image.network('https://via.placeholder.com/400x200'),
            ]
          ),

          ActionGridSectionConfig(
            crossAxisCount: 3,
            actions: [
              Icon(Icons.map),
              Icon(Icons.camera),
              Icon(Icons.mail),
            ]
          ),
          
          const DividerSectionConfig(),

          CustomSectionConfig(
            builder: (context) {
              return Text('I am a custom injected widget block that can do anything!');
            }
          ),
        ]
      ),
    );
  }
}
```

## 🛠 Advanced Customization

Pass a `themeDelegate` to seamlessly change the foundational styling logic for your sections.

```dart
  ModularHomeScreen(
    config: myConfig,
    themeDelegate: HomeThemeDelegate(
      screenPadding: EdgeInsets.all(24.0),
      sectionSpacing: 32.0,
      cardBorderRadius: BorderRadius.circular(24.0),
    ),
  );
```

## 🐛 Contributing & Issues

Have an issue or a feature request? Let us know on the GitHub repository issue tracker!
