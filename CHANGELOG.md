## 0.6.0

* **Extensibility Upgrade**: Added `customSectionBuilders` to `SduiConfig` and `SectionRegistry` so developers can inject massive, fully custom root-level Sections directly from the engine parser, dropping the rigidity of default sections.
* **Resilience Layer**: Formally introduced `errorWidgetBuilder` mapped sequentially throughout `SduiScreen`. Unpredictable schemas and component widget crashes are gracefully swept into explicit error widgets instead of bricking the engine stream. 
* **UI Purity**: Reverted experimental app-specific `HeaderSection` alterations back to neutral framework-level styles to maintain an unopinionated core while the example application showcases proper Extensibility overrides.
* **Demonstration Polish**: Reflected precise, crisp new visual screenshots (`sdui_demo.png`) on `pub.dev`. Resolved remaining `opacity` deprecation flags.

## 0.5.0

* **Major Release: Complete Architecture Overhaul**
* **Interaction Delegation Model:** Embedded native `SduiAction` blocks and decoupled route handling natively to your application leveraging `SduiActionHandlerProvider`.
* **Explicit Strict Types:** Dropped global states inside the parser schema. `SduiSectionConfig` constructors explicitly pass down a `strictMode` boolean toggle enforcing unbreakable configurations during Development.
* **Aggregated UX Validation:** Injected `ValidationResult` objects silently gathering warnings instead of immediately interrupting parsing trees upon minor misspellings.
* **Native Fallbacks DX:** Rewrote raw missing component errors aggressively out of the engine. The system natively drops a vibrant `SduiDebugOverlay` dynamically catching unknown elements natively for supreme dev-mode observability.
* **Premium Example Replacements:** Obliterated generic layout examples and rolled out the hyper-modern complete `swiggy_home.json` example architecture natively simulating realistic full-scale SDUI infrastructure.

## 0.4.1

* **Polish:** Removed speculative roadmap from README.md and updated the layout demonstration asset with a new GIF.

## 0.4.0

* **Feature:** Added `SduiConfig.fromJsonAsync()` to enable deep JSON parsing on background microtasks, ensuring 60fps scrolling without main-thread jank when resolving massive SDUI payloads.
* **Feature:** Introduced native pagination APIs! Added `hasMore` and `nextPageUrl` schema definitions to `ContentListSectionConfig` and `ActionGridSectionConfig`.
* **Feature:** Wired `onLoadMore: (section, url)` callback into `SduiScreen` mapping engine natively bubbling scroll edge notifications from your remote layouts directly to your root application.
* **Performance:** Implemented aggressive deterministically hashed `_cache` mapping natively resolving identical JSON branches in `ComponentRegistry` in O(1) time without massive re-allocations.

## 0.3.2

* **Fix (Docs):** Explicitly renamed the layout demonstration asset to permanently bypass upstream pub.dev caching walls. 
* **Polish:** Stripped default Flutter boilerplate scaffolding and tightened `pubspec.yaml` definitions to match production-grade expectations.

## 0.3.1

* **Fix:** Appended version query parameters manually into the `README.md` image tags to bypass GitHub CDN caching so the updated demo GIF successfully propagates on pub.dev.
* **Docs:** Updated installation string to bounds `0.3.1`.

## 0.3.0

* **Major Architecture Upgrade:** Evolved from a simple layout builder to a **production-grade Server-Driven UI (SDUI) Framework**. 
* **Validation Layer (`JsonParserUtils`):** Added strict primitive coercers to protect the parsing engine from malformed remote JSON schema data types (e.g. string integers gracefully casted).
* **SDUI Identity (`ValueKey`):** `SduiScreen` now automatically maps explicit rendering keys to all Sections utilizing the JSON `id` parameter. This prevents state loss and animation jank during remote refetches.
* **Observability (`SduiLogger`):** Included a built-in diagnostic logging toggle natively inside `SduiConfig.fromJson(json, debugMode: true)` to actively print component mapping boundaries or warn when generic fallback builders drop unknown elements.
* **Example Enhancements:** Created a new application tab fully loading `mock_server_layout.json` into the engine natively via HTTP-simulated asset fetches. 

## 0.2.1

* **Docs:** Updated `README.md` to reflect the latest `0.2.1` version in installation instructions.

## 0.2.0

* **Major Feature (Server-Driven UI):** `SduiConfig.fromJson(json, componentRegistry: ...)` is now entirely supported! You can define your home layouts remotely and safely map JSON types to widgets.
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
* Added orchestrator engine `SduiScreen` powering a declarative layout configuration via `SduiConfig`
* Added standard sections definitions: `BannerSectionConfig`, `ActionGridSectionConfig`, `ContentListSectionConfig`, `DividerSectionConfig`.
* Core layout engine implementation supporting fully dynamic injecting of `CustomSectionConfig`.
* Theme styling capabilities overridden by `SduiThemeDelegate`.
