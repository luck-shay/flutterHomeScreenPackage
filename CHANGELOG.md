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
