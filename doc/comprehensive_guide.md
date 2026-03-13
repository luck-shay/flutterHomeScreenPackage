# Modular Home Screen - Comprehensive Developer Guide

This document is the ultimate reference guide for the `home_library` Flutter package. It explains its exact purpose, its internal architecture, all of its capabilities, and exactly how to implement every single feature.

---

## 1. What does it do?

Building home screens and dashboards in Flutter usually results in massive, heavily nested widget trees containing a mix of `ListViews`, `GridViews`, and `Column`s. Eventually, developers run into scrolling issues, performance bottlenecks, and nightmare-level code maintenance when trying to implement things like "sticky headers" or "horizontal scrolling rows inside vertical lists".

The `home_library` package solves this. **It provides a completely declarative, configuration-driven layout engine.** Instead of building widgets, developers pass a single `HomeConfig` object containing a list of `HomeSectionConfig` data models. The engine automatically translates this configuration into a highly performant, unified `CustomScrollView` utilizing Flutter's powerful `Sliver` architecture.

---

## 2. How is it built? (Internal Architecture)

The package relies on three core pillars: **Declarative Configuration**, **Sliver Rendering**, and **Theming Delegates**.

### The Configuration Pipeline
At the root of the package is:
- **`HomeConfig`**: The root model holding the global layout properties (like the `AppBar` and screen background color). It accepts a `List<HomeSectionConfig>`.
- **`HomeSectionConfig`**: An abstract base class defining parameters common to all sections (like `spacingBelow`).

When you pass a layout config like `BannerSectionConfig(banners: [...])`, the engine doesn't just nest a widget. It passes this data model through to the orchestrator.

### The Render Orchestrator (`ModularHomeScreen`)
`ModularHomeScreen` is the heart of the library. Internally, it is built exactly like this:
```dart
CustomScrollView(
  slivers: [
    if (config.appBar != null) config.appBar!,
    SliverPadding(
      padding: theme.screenPadding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
              final sectionConfig = config.sections[index];
              return _buildSection(context, sectionConfig); // Dynamically routes to the right renderer
          }
        ),
      ),
    ),
  ],
)
```
The `_buildSection` method acts as a router. If it sees an `ActionGridSectionConfig`, it returns an `ActionGridSection` widget. 

### Why Slivers?
Because slivers render directly into the view port lazy-loading mechanics, this package achieves **60 FPS/120 FPS natively**, no matter how complicated the internal grids or horizontal lists get. It flawlessly bridges the gap between horizontal scrolling and vertical scrolling bounds within the same unified context.

---

## 3. All Capabilities & How to Use Them

To start using the library, your root widget will always be:

```dart
ModularHomeScreen(
  config: HomeConfig(
     appBar: SliverAppBar(title: Text('My App')),
     sections: [
        // ... Your sections go here
     ]
  ),
  themeDelegate: HomeThemeDelegate(
     // Global spacing and styling overrides go here
  ),
)
```

Below is every section type you can put inside the `sections` list, what it does, and how to use it.

### A. `HeaderSectionConfig`
**What it does:** Renders a large greeting or title text, a subtitle, and an optional trailing widget (like a user profile picture or settings icon).
**Capabilities:** Fully responsive text dynamically aligned to the edges.
```dart
HeaderSectionConfig(
  title: 'Good Morning, Lakshay!',
  subtitle: 'Here is your daily overview.',
  trailingWidget: CircleAvatar(backgroundImage: NetworkImage('...')),
  spacingBelow: 24.0, // Override global spacing
)
```

### B. `BannerSectionConfig`
**What it does:** Renders promotional imagery or hero containers. 
**Capabilities:** It supports two distinct layout types:
- `BannerLayoutType.standard`: Stacks the provided banners vertically in a standard column.
- `BannerLayoutType.carousel`: Wraps the banners in an auto-playing horizontal PageView slider!
```dart
BannerSectionConfig(
  layoutType: BannerLayoutType.carousel,
  autoPlay: true,
  banners: [
    Image.asset('promo1.png'),
    Image.asset('promo2.png'),
  ],
)
```

### C. `ActionGridSectionConfig`
**What it does:** Renders a perfectly spaced grid of widgets (often buttons or icons).
**Capabilities:** It internally uses a `GridView` strapped with `NeverScrollablePhysics()` and mapped perfectly into a shrink-wrapped box. You define the exact cross-axis count.
```dart
ActionGridSectionConfig(
  crossAxisCount: 3, // 3 items per row
  spacing: 16.0, // 16 pixels between every column and row
  actions: [
    IconButton(icon: Icon(Icons.send), onPressed: () {}),
    IconButton(icon: Icon(Icons.request_page), onPressed: () {}),
    IconButton(icon: Icon(Icons.history), onPressed: () {}),
  ],
)
```

### D. `ContentListSectionConfig`
**What it does:** Renders a titled section containing a list of items (like "Recent Products" or "Activity Feed").
**Capabilities:** Allows you to drastically change the UI orientation by simply flipping a boolean enum.
- `ListLayoutType.vertical`: Renders items top-to-bottom.
- `ListLayoutType.horizontal`: Renders a Netflix-style sideways scrolling rail of items. Constrained by the `horizontalHeight` parameter.
```dart
ContentListSectionConfig(
  title: 'Trending Now',
  layoutType: ListLayoutType.horizontal,
  horizontalHeight: 220.0, // Strict height bounds for the sideways rail
  itemSpacing: 12.0,
  items: [
    ProductCardWidget(),
    ProductCardWidget(),
  ],
)
```

### E. `DividerSectionConfig`
**What it does:** Adds a semantic divider or empty whitespace between sections.
**Capabilities:** Can be a thick colored line or just empty transparent padding.
```dart
DividerSectionConfig(
  height: 48.0,
  thickness: 2.0, // Set to null for invisible whitespace
  color: Colors.grey.shade200, 
)
```

### F. `CustomSectionConfig` (The Escape Hatch)
**What it does:** Ensures that developers are *never* stuck or restricted by the package's built-in limits.
**Capabilities:** Takes a standard `(BuildContext context)` builder function, allowing you to inject literally any Flutter widget directly into the Sliver rendering pipeline.
```dart
CustomSectionConfig(
  builder: (context) {
    return Container(
      color: Colors.red,
      child: Center(child: Text('I am a totally custom widget!')),
    );
  }
)
```

---

## 4. Theming and Customization 

By default, the package assumes the visual identity of whatever `Theme.of(context)` it is running inside. However, you can strictly override padding and stylistic constraints globally utilizing the `HomeThemeDelegate`.

When constructing `ModularHomeScreen`, pass this delegate to manipulate the system universally:

```dart
ModularHomeScreen(
  config: myConfig,
  themeDelegate: HomeThemeDelegate(
    screenPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Outer edges of the screen
    sectionSpacing: 32.0, // Default distance between EVERY section
    cardRadius: 16.0, // Rounds corners of built-in components
    cardElevation: 0.0, // Flattens dropshadows natively
    headerStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.indigo), 
    subtitleStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    sectionTitleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
)
```

### Granular Overrides
If you want the entire screen to have `32.0` spacing, but exactly *one* header to be flush against a banner, you can use the `spacingBelow` property on any section. This securely overrides the theme locally:

```dart
HeaderSectionConfig(
  title: 'Hello!',
  spacingBelow: 0.0, // Nullifies the themeDelegate's 32.0 gap just for this element
)
```
