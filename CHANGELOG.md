## 0.3.0

* **Major Architecture Upgrade:** Evolved from a simple layout builder to a **production-grade Server-Driven UI (SDUI) Framework**. 
* **Validation Layer (`JsonParserUtils`):** Added strict primitive coercers to protect the parsing engine from malformed remote JSON schema data types (e.g. string integers gracefully casted).
* **SDUI Identity (`ValueKey`):** `ModularHomeScreen` now automatically maps explicit rendering keys to all Sections utilizing the JSON `id` parameter. This prevents state loss and animation jank during remote refetches.
* **Observability (`HomeLogger`):** Included a built-in diagnostic logging toggle natively inside `HomeConfig.fromJson(json, debugMode: true)` to actively print component mapping boundaries or warn when generic fallback builders drop unknown elements.
* **Example Enhancements:** Created a new application tab fully loading `mock_server_layout.json` into the engine natively via HTTP-simulated asset fetches. 

## 0.2.1

* **Docs:** Updated `README.md` to reflect the latest `0.2.1` version in installation instructions.

## 0.2.0

* **Major Feature (Server-Driven UI):** `HomeConfig.fromJson(json, componentRegistry: ...)` is now entirely supported! You can define your home layouts remotely and safely map JSON types to widgets.
* **Architecture Change:** Separated layout structure (`SectionRegistry`) and layout content constraints (`ComponentRegistry`) to ensure robust parsing boundaries.
* **Component Abstraction:** Removed tight `Widget` object dependency inside standard section models (`ActionGridSectionConfig`, `ContentListSectionConfig`, etc.), swapping them with data-oriented `ItemConfig` implementations for deep JSON serialization flexibility.
* **Migration / Compat:** Wrapped legacy direct-widget instances automatically into `WidgetItemConfig` instances for a backward-compatible and smooth transition.

## 0.1.2

* **Fix:** Constrained the README demo GIF dimensions so it scales beautifully on desktop pub.dev displays.

## 0.1.1

* **Fix:** Fixed visual demo rendering on pub.dev due to URL encoding issues and bumped package snippet documentation.

## 0.1.0

* **Major Feature:** Added 3 production-ready Prebuilt Layout Templates (`EcommerceTemplate`, `DashboardTemplate`, `SocialFeedTemplate`).
* Completely overhauled the `example` application into a production-grade multi-tab layout.
* Rewrote package documentation and `README.md` to be highly comprehensive with visual demos.

## 0.0.3

* Renamed `docs` directory to `doc` to comply with pub.dev package layout conventions.

## 0.0.2

* Added fine-grained control for section spacing.
* Exported package APIs correctly for better integration.
* Improved package metadata and resolved static analysis warnings.

## 0.0.1

* Initial release of the Modular Home Screen library.
* Added orchestrator engine `ModularHomeScreen` powering a declarative layout configuration via `HomeConfig`
* Added standard sections definitions: `BannerSectionConfig`, `ActionGridSectionConfig`, `ContentListSectionConfig`, `DividerSectionConfig`.
* Core layout engine implementation supporting fully dynamic injecting of `CustomSectionConfig`.
* Theme styling capabilities overridden by `HomeThemeDelegate`.
