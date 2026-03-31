# Modular Home Screen (`home_library`)

A production-grade **Server-Driven UI (SDUI) Engine** to build dynamic, customizable, and hyper-performant Flutter home screens entirely from JSON payloads in minutes.

`home_library` is a Flutter package that shifts layout configurations from static application code to dynamic architecture constraints. Define robust `Section` templates remotely, ingest them through resilient data-parsers safely against schema mismatches, and orchestrate them via a powerful `CustomScrollView` + `Sliver` structure.

## 🚨 The Problem

Building a home screen in Flutter usually means:
- Writing repetitive, boilerplate UI code.
- Hard-to-maintain, nested widget trees.
- Poor flexibility for dynamic or remote-driven changes.
- Fighting standard scroll behaviors.

## ✅ The Solution

`home_library` solves this by transforming home screens to a remote infrastructural backend:
- **Declarative JSON Configuration:** Build complex layouts easily via typed data models fetched live avoiding Play/App Store deployments.
- **Robust Type Mapping Constraints:** Prevent structural API mismatch faults implicitly using data primitives coercions (`JsonParserUtils`).
- **Plug-and-play modular sections:** Reusable structural blocks automatically tracked perfectly using `ValueKey` injections avoiding layout jumping.
- **Clean and scalable architecture:** Decoupled structural data (`SectionRegistry`) and UI constraint logic (`ComponentRegistry`).

## 🎥 Demo

<div align="center">
  <img src="https://raw.githubusercontent.com/luck-shay/flutterHomeScreenPackage/main/assets/home_library_demo_v2.gif" alt="App Demo" width="300" />
</div>

## 🎨 Prebuilt Templates

The package comes with 3 production-ready layout templates that you can drop into any app immediately:

1. **E-Commerce Storefront**
2. **Analytics Dashboard**
3. **Social Feed**

## ⚡ Key Features

- **Built-in Section Drivers:**
    - `HeaderSectionConfig`: Greeting headers with trailing widgets.
    - `BannerSectionConfig`: Stacked or Carousel hero image promotions.
    - `ActionGridSectionConfig`: Grid/row actions natively supporting tight configurations.
    - `ContentListSectionConfig`: Scrollable horizontals or vertical lists of standard content cards.
    - `DividerSectionConfig`: Semantic custom-styled dividers.
- **Custom Section Injection:** Render literally anything at any point in the scroll view using `CustomSectionConfig`.
- **Deep Theming:** Automatically inherits the host environment `ThemeData`, but trivially overridable via `HomeThemeDelegate`.
- **State Management Agnostic:** Hook tap callbacks natively inside the component builders without fighting arbitrary framework limits.

## 🧠 When to use this?

Use `home_library` if:
- You are building dashboards or e-commerce fronts.
- You need highly reusable and dynamic home screen layouts.
- Your UI changes frequently based on backend responses.
- You want a cleaner UI architecture with less nesting.

## 🚀 Getting Started

In your `pubspec.yaml`:
```yaml
dependencies:
  home_library: ^0.4.0
```

## 💻 Example Usage

Use the orchestrator widget `ModularHomeScreen` and pass it your declarative `HomeConfig`:

```dart
import 'package:flutter/material.dart';
import 'package:home_library/home_library.dart';

class StorefrontHomeScreen extends StatelessWidget {
  const StorefrontHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModularHomeScreen(
      // Configure global theming override for a premium feel
      themeDelegate: HomeThemeDelegate(
        screenPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        sectionSpacing: 32.0,
        cardBorderRadius: BorderRadius.circular(16.0),
      ),
      config: HomeConfig(
        appBar: AppBar(
          title: const Text('Storefront', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
          ],
        ),
        sections: [
          // 1. Personalized Greeting
          HeaderSectionConfig(
            title: 'Good Morning, Alex!',
            subtitle: 'Ready for some exclusive deals?',
            trailingWidget: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
            ),
          ),
          
          // 2. Promotional Carousel
          BannerSectionConfig(
            layoutType: BannerLayoutType.carousel,
            autoPlay: true,
            banners: [ 
              _buildPromoCard('Summer Sale', 'Up to 50% Off', Colors.orangeAccent),
              _buildPromoCard('New Arrivals', 'Shop latest trends', Colors.blueAccent),
            ]
          ),
          
          // 3. Category Grid
          ActionGridSectionConfig(
            crossAxisCount: 4,
            actions: [
              _buildCategoryAction(Icons.checkroom, 'Clothing'),
              _buildCategoryAction(Icons.devices, 'Tech'),
              _buildCategoryAction(Icons.sports_esports, 'Gaming'),
              _buildCategoryAction(Icons.flight, 'Travel'),
            ]
          ),
          
          const DividerSectionConfig(height: 40, thickness: 1),
          
          // 4. Horizontal Scrolling Product List
          ContentListSectionConfig(
            title: 'Trending Now',
            layoutType: ListLayoutType.horizontal,
            horizontalHeight: 220,
            items: [
              _buildProductCard('Wireless Headphones', '\$199'),
              _buildProductCard('Smart Watch', '\$249'),
              _buildProductCard('Mechanical Keyboard', '\$129'),
            ],
          ),
        ]
      ),
    );
  }

  Widget _buildPromoCard(String title, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildCategoryAction(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 28, backgroundColor: Colors.grey.shade200, child: Icon(icon, color: Colors.black87)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildProductCard(String name, String price) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🌐 Server-Driven UI (JSON Configuration)

`home_library` securely treats structural configurations as serializable layout definitions. This allows you to construct dynamic screens entirely via API payloads!

Using the dual-registry architecture (`SectionRegistry` & `ComponentRegistry`), standard structural boundaries dynamically render pure-data `ItemConfig` mappings.

```dart
final registry = ComponentRegistry(
  fallbackBuilder: (type, json) => Text('Unknown format: $type')
);

registry.register('promo_card', (json) {
  // Deserialize your concrete ItemConfig directly from backend data!
  return MyPromoCardConfig(title: json['title']);
});

// Assuming payload is Map<String, dynamic> derived from standard jsonDecode(...)
final config = HomeConfig.fromJson(payload, componentRegistry: registry);

return ModularHomeScreen(config: config);
```

## 🛠 Advanced Customization

Pass a `themeDelegate` to seamlessly change the foundational styling logic for your sections.

```dart
ModularHomeScreen(
  config: myConfig,
  themeDelegate: HomeThemeDelegate(
    screenPadding: const EdgeInsets.all(24.0),
    sectionSpacing: 32.0,
    cardBorderRadius: BorderRadius.circular(24.0),
  ),
);
```

## 🔥 Roadmap

We are actively working to take `home_library` to the next level:
- 🥇 **Prebuilt layouts:** Drop-in E-commerce, Dashboard, and Social Feed screens.
- 🥈 **JSON-driven UI:** Dynamically build layouts directly from backend JSON responses using the component registry pipeline.
- 🥉 **Section-based architecture:** Refined direct programmatic section composition.
- 🧠 **Theming system:** Light/dark toggle support and explicit section-level themes.

## 🤝 Contributing

PRs are welcome. Have an issue or a feature request? Let us know on the GitHub repository issue tracker! Let’s make Flutter UI development faster together.

## ⭐ Support

If you find this useful, consider giving it a star on GitHub!
