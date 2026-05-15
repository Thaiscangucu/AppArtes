# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
# Build for simulator (requires Xcode path to be set)
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild -project AppArtes.xcodeproj -scheme AppArtes \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" build

# List available simulators
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl list devices available

# Run tests
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild -project AppArtes.xcodeproj -scheme AppArtes \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" test
```

The normal development workflow is to open `AppArtes.xcodeproj` directly in Xcode and run from there.

**Target:** iOS 26.0+, Swift 5, Bundle ID `com.thais.AppArtes`.  
**Permissions** (declared in project build settings, no separate Info.plist): `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`.

## Architecture

SwiftUI + SwiftData app for managing personal art collections. No third-party dependencies.

**Data layer — SwiftData models (`Models/`)**
- `Colecao` — a named collection; owns `[ObraDeArte]` via a cascade-delete `@Relationship`.
- `ObraDeArte` — an artwork stored with title, description, creation date, format string, and optional image as `Data` (`.externalStorage`).
- `Obra` / `Exposicao` — legacy `@MainActor` classes not connected to SwiftData; currently unused by the views.

The model container is registered in `AppArtesApp.swift` for `[Colecao.self, ObraDeArte.self]`.

**Navigation flow**
```
ContentView (TabView)
├── HomeView          — @Query all ObraDeArte, WaterfallGrid, → DetalheObraView
├── CollectionsView   — @Query all Colecao, list, → CollectionView
│   └── CollectionView  — receives Colecao, WaterfallGrid of colecao.obras, → DetalheObraView
│       └── NewItem (sheet) — image picker + form, inserts ObraDeArte, appends to colecao.obras
└── NewCollectionView (sheet from CollectionsView) — inserts Colecao
```

**Known bug — `CollectionView.swift:26`:** The grid calls `WaterfallGrid(data: obras, ...)` where `obras` comes from an unfiltered `@Query` (all artworks), but the empty-state check uses `colecao.obras`. The grid should use `colecao.obras` so it only shows artworks belonging to that collection.

**`WaterfallGrid` (`Views/GridStruct.swift`):** Generic Pinterest-style two-column layout; accepts any `RandomAccessCollection` of `Identifiable` items and a `@ViewBuilder` cell closure. Used by both HomeView and CollectionView.

**Image handling:** Images are picked via `ImagePicker` (a `UIViewControllerRepresentable` wrapping `UIImagePickerController`), converted to JPEG `Data` at 0.8 quality, and stored on `ObraDeArte.image`. Displayed by converting back to `UIImage` inline in each view.
