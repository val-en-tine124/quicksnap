# Changelog

All notable changes to QuickSnap are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-06-20

### Added
-Initial release of QuickSnap
- Rich text editor powered by Flutter Quill
- Image vault with secure local storage
- Offline-first architecture using Hive + Flutter Secure Storage
- Light / Dark / System theme support with custom accent colors (amber, blue, pink, green)
- In-app update checker (GitHub Releases API integration)
- Update dialog with changelog support
- Hive caching for update config (offline fallback)
- Android CI/CD pipeline (`.github/workflows/release-android.yml`)
- Split ABI APK builds (`arm64-v8a`, `armeabi-v7a`, `universal`, `x86_64`)
- Unit and widget tests for models, providers, and UI

### Tech Stack
- Flutter 3.10+
- Dart 3.5+
- Riverpod 3.0+ (code-generated providers)
- Freezed (immutable models)
- Hive CE (local NoSQL database)
- Flutter Secure Storage (key-value encryption)
- Dio (HTTP client)
- url_launcher (external link handling)

---

## [Unreleased]

### Planned
- iOS and desktop support
- Cloud sync (optional)
- Tags and search
- Export notes (PDF, Markdown)
- Widget support