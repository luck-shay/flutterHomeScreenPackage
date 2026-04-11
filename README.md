# 🚀 flutter_sdui 

A production-grade **Server-Driven UI (SDUI) Engine** built for Flutter. Construct hyper-dynamic, completely remote home screens using clean JSON payloads, strict schema validation, and declarative architectures in minutes.

<div align="center">
  <img src="https://raw.githubusercontent.com/luck-shay/flutterHomeScreenPackage/main/assets/sdui_demo.png" width="280"/>
</div>

**Stop rebuilding your app to test new layouts.** `flutter_sdui` shifts layout configurations from static application code to dynamic backend constraints. Perfect for startups, product teams, and enterprise applications that require A/B testing, remote control, and instant iteration.

---

## 🚨 The "Before" Problem

Building dynamic layouts natively means writing repetitive boilerplate, hardcoding widget positions, and suffering through app store review cycles for a simple promo banner swap:

```dart
// The Old Way: 200 lines of hardcoded brittle layout updates requiring an App Store release
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: HeaderWidget(title: "Good Morning")),
      if (showPromo) SliverToBoxAdapter(child: PromoCarouselWidget(offers: backendOffers)),
      SliverGrid(delegate: CategorySliverDelegate(categories: backendCategories)),
      if (foodList.isNotEmpty) SliverList(delegate: FoodSliverDelegate(foods: backendFoods)),
    ]
  )
)
```

## ✅ The "After" Solution

`flutter_sdui` (internally powered by `SduiEngine`) treats structural configurations as serializable layout definitions. You just send the intent natively:

```json
{
  "sections": [
    { "type": "header", "title": "Good Morning" },
    { "type": "banner", "layoutType": "carousel", "banners": [ ... ] },
    { "type": "action_grid", "crossAxisCount": 4, "actions": [ ... ] },
    { "type": "content_list", "title": "Top Restaurants", "items": [ ... ] }
  ]
}
```

## ⚡ Key Features

1. **🔥 Pure Interaction Model:** Built-in `SduiAction` engine that delegates taps seamlessly natively (`{ "type": "navigate", "route": "/product/123" }`) without coupling to GoRouter or Bloc.
2. **🛡️ Strict Schema Modes:** Treat JSON like a strict API contract. `strictMode: true` crashes your dev app if types don't match, while `false` provides unbreakable bulletproof fallbacks in Production. 
3. **🛠️ World-Class DX:** Automatic `SduiDebugOverlay` injection natively highlights missing schemas visually on-device during testing.
4. **🧠 Caching & Optimization:** Asynchronous isolate-safe JSON parsing yielding to the main thread ensuring 60fps renders even with 10MB payloads.

---

## 🚀 Copy-Paste Quick Start (The "Swiggy" Setup)

Get a massive dynamic architecture running in 2 minutes.

### 1. Register your Native Components
The engine manages structural section layouts (Grids, ScrollViews). You tell the engine how to render leaf-node items dynamically:

```dart
// 1. Initialize your custom registry
final registry = ComponentRegistry();

// 2. Map a backend object "promo_card" to your native UI
registry.register('promo_card', (json) {
  // Extract the declarative action
  final action = SduiAction.fromJson(json['action']);
  
  return WidgetItemConfig(
    action: action,
    widget: Builder(
      builder: (context) {
        // Use SduiActionHandlerProvider to automatically dispatch actions!
        return InkWell(
          onTap: () => SduiActionHandlerProvider.of(context)?.onAction(context, action),
          child: MyNativePromoCard(title: json['title']),
        );
      }
    ),
  );
});
```

### 2. Implement an Action Handler
Delegate analytics and navigation strictly to the host app:

```dart
class MyActionHandler implements SduiActionHandler {
  @override
  void onAction(BuildContext context, SduiAction action) {
     if (action.type == SduiActionType.navigate) {
         GoRouter.of(context).push(action.route, extra: action.params);
     } else if (action.type == SduiActionType.analyticsEvent) {
         FirebaseAnalytics.instance.logEvent(name: action.params?['event_name']);
     }
  }
}
```

### 3. Parse The Backend Layout

```dart
// Suppose your API returns a structural map with sections and nested promo_cards
final Map<String, dynamic> remotePayload = await fetchLayout();

// Internal tracking of Warnings / Errors on your schema
final validation = ValidationResult();

// Parse async to avoid frame drops on massive JSON schemas
final config = await SduiConfig.fromJsonAsync(
  remotePayload, 
  componentRegistry: registry,
  strictMode: false, // Fallback gracefully if schema violates constraints
  validationResult: validation, 
);

print('SDUI Warnings: ${validation.warnings}');
```

### 4. Render the Engine

Inject the parsed configuration into the high-performance `SduiScreen` orchestrator:

```dart
return SduiScreen(
  config: config,
  actionHandler: MyActionHandler(), // Hooks up user taps seamlessly!
  themeDelegate: SduiThemeDelegate(
    screenPadding: const EdgeInsets.all(16.0),
    cardBorderRadius: BorderRadius.circular(16.0),
  ),
);
```

---

## 🏗️ Supported JSON Schema Definitions

Every visual structural element cleanly maps down to the Section level.

- `header` -> `HeaderSectionConfig`: Greeting headers with optional trailing widgets.
- `banner` -> `BannerSectionConfig`: Stacked or Carousel image promotions.
- `action_grid` -> `ActionGridSectionConfig`: Dense native wrap layouts.
- `content_list` -> `ContentListSectionConfig`: Scrollable horizontal or vertical paginated lists (`nextPageUrl`).
- `divider` -> `DividerSectionConfig`: Visual semantic separators.

## 🤝 Contributing

This package is designed as infrastructure. PRs adding new Section layouts, Caching strategies, and Exposure Tracking are welcome.
