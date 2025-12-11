# FilmApp

## Contributing Guidelines

- **Respect manual edits.** If a value (padding, spacing, color, etc.) was changed directly in Xcode, do not revert or override it unless the user explicitly asks for that change.
- **Prefer inside strokes.** All 1pt borders should be drawn with `strokeBorder(...)` so the line stays inside the component bounds and does not shift the layout.
- **Avoid extra wrappers.** Do not introduce additional containers or padding layers around existing sections just to force spacing; share layout data through the shared `FeedLayout` (or similar) tokens instead, so every block follows the same values.
- **Reuse style tokens.** When adjusting spacing, typography, or colors, favor the existing enums (`Typography`, `Palette`, `FeedLayout`, etc.) so spacing changes stay consistent across the UI.
- **Horizontal scroll padding.** When designing horizontal scroll views, give them 18pt horizontal breathing room with `.contentMargins(.horizontal, FeedLayout.sectionHorizontalInset, for: .scrollContent)` so the first/last cards never start flush against the screen yet still scroll all the way to the edges; don’t revert this by reintroducing `padding(.horizontal, …)` on the parent.
- **Use local screen context.** `UIScreen.main` (and `UIScreen.mainScreen`) are deprecated on iOS 26; derive widths from the current view’s geometry or safe-area context (`GeometryReader`, `.containerRelativeFrame()`, `.safeAreaInsets`, etc.) instead of relying on global screen metrics so the layout always matches the active window scene.

<p align="center">
    <img width="400" src="./Assets/Logo.png">
</p>

## Wave

Wave is a spring-based animation engine for iOS, iPadOS, and macOS. It makes it easy to create fluid, interactive, and interruptible animations that feel great.

Wave has no external dependencies, and can be easily dropped into existing UIKit, SwiftUI, or AppKit based projects and apps.

The core feature of Wave is that all animations are _re-targetable_, meaning that you can change an animation’s destination value in-flight, and the animation will gracefully _redirect_ to that new value.

- [Understanding Retargeting](#features)
- [Installation](#installation)
- [Documentation](#documentation)
- [Getting Started](#getting-started)
    - [Block-Based Animation](#block-based-animation)
    - [Property-Based Animation](#property-based-animation)
- [Example Code](#example-code)

#### Understanding Retargeting

Consider these demos of the iOS Picture-in-Picture feature. The screen on the left is created with standard UIKit animations, and the one on the right is created with Wave.

Though both are “interruptible”, the Wave-based implementation handles the interruption much better, and fluidly _arcs_ to its new destination. The UIKit animation feels stiff and jerky in comparison.

At its core, [retargeting](https://developer.apple.com/videos/play/wwdc2018/803/) is the process of preserving an animation’s velocity even as its target changes, which Wave does automatically.

![Demo](./Assets/Retargeting.gif)


### Installation

Add Wave to your app's `Package.swift` file, or selecting `File -> Add Packages` in Xcode:

```swift
.package(url: "https://github.com/jtrivedi/Wave")
```

If you clone the repo, you can run the sample app, which contains a few interactive demos to understand what Wave provides.

Note: To enable high frame-rate animations on ProMotion devices (i.e. 120 fps animation), you'll need to add a key/value pair in your `Info.plist`. Set the key `CADisableMinimumFrameDuration` to `true`. Without this entry, animations will be capped at 60 fps.

### Documentation

There’s a full Wave [documentation site](https://Wave-jtrivedi.structure.sh) available for full API and usage documentation.

### Getting Started

There are two ways you can interact with Wave, depending on your needs: the block-based and property-based animations:

#### Block-Based Animation

The easiest way to get started is by using Wave’s block-based APIs that resemble the `UIView.animateWithDuration()` APIs.

This API lets you animate several common UIView and CALayer properties, like `frame`, `center`, `scale`, `backgroundColor`, and more.

For these supported properties, Wave will create, manage, and execute the required spring animations under-the-hood.

For example, animating the above PiP view to its final destination is extremely simple:

```swift
if panGestureRecognizer.state == .ended {

    // Create a spring with some bounciness. `response` affects the animation's duration.
    let animatedSpring = Spring(dampingRatio: 0.68, response: 0.80)

    // Get the gesture's lift-off velocity, and pass it into the Wave animation.
    let gestureVelocity = panGestureRecognizer.velocity(in: view)

    Wave.animate(withSpring: animatedSpring, gestureVelocity: gestureVelocity) {
        // Update animatable properties on the view's `animator` property, _not_ the view itself.
        pipView.animator.center = pipViewDestination     // Some target CGPoint that you calculate.
        pipView.animator.scale = CGPoint(x: 1.1, y: 1.1)
    }
}
```

Note that at _any_ time, you can _retarget_ the view’s `center` property to somewhere else, and it’ll gracefully animate.

##### Supported Animatable Properties

The block-based API currently supports animating the following properties. For other properties, you can use the property-based animation API below.

* `frame`
* `bounds`
* `center`
* `origin`
* `alpha`
* `backgroundColor`
* `cornerRadius`
* `scale`
* `translation`
* `shadowColor/radius/offset/opacity`
* `borderColor/borderWidth`

Upcoming properties:

* `rotation`

#### Property-Based Animation

While the block-based API is often most convenient, you may want to animate something that the block-based API doesn’t yet support (e.x. rotation). Or, you may want the flexibility of getting the intermediate spring values and driving an animation yourself (e.x. a progress value).

For example, to draw the orange path of the PiP demo, we need to know the value of every `CGPoint` from the view’s initial center, to its destination center:

```swift
// When the gesture ends, create a `CGPoint` animator from the PiP view's initial center, to its target.
// The `valueChanged` callback provides the intermediate locations of the callback, allowing us to draw the path.

let positionAnimator = SpringAnimator<CGPoint>(spring: animatedSpring)
positionAnimator.value = pipView.center       // The presentation value
positionAnimator.target = pipViewDestination  // The target value
positionAnimator.velocity = gestureVelocity

positionAnimator.valueChanged = { [weak self] location in
    self?.drawPathPoint(at: location)
}

positionAnimator.start()
```


##### Completion Blocks

Both the block-based and property-based APIs support completion blocks. If an animation completes fully, the completion block’s `finished` flag will be true.

However, if an animation’s target was changed in-flight (“retargeted”), `finished` will be false, while `retargeted` will be true.

```swift
Wave.animate(withSpring: Spring.defaultAnimated) {
    myView.animator.backgroundColor = .systemBlue
} completion: { finished, retargeted in
    print(finished, retargeted)
}
```

### Example Code

Exploring the provided sample app is a great way to get started with Wave.

Simply open the `Wave-Sample` Xcode project and hit “Run”. The full source code for the Picture-in-Picture demo is available there, too!

### Acknowledgements

Special thanks to [Ben Oztalay](https://github.com/boztalay) for helping architect the underlying physics of Wave!

- **Respect user edits.** If you see changes that the user made (especially outside your current edits), leave them untouched unless they explicitly ask you to revert or adjust that work.

- **iOS 26 nav rules.** Navigation Bar → Toolbar rename, Liquid Glass toolbar APIs, and tab-bar customization details live here as a working reference (see section below).

If you are unsure about a change, check with the owner before touching values that may have been tuned by hand.

## System Prompt & Coding Principles

```
#  System Prompt: iOS & SwiftUI Expert (Updated Nov 2025)

## 1. Persona & Context
You are an expert Senior iOS Engineer at Apple.
**Current Date:** November 2025.
**Target OS:** iOS 26 (Current Stable) & iOS 18 (Previous).
**Strict Rule:** Apple skipped iOS 19-25. The successor to iOS 18 is **iOS 26**. never mention iOS 19.

## 2. Knowledge Injection: New in SwiftUI (iOS 26 / WWDC 25)
*Base knowledge cutoff: Oct 2023. You MUST prioritize these newer APIs.*

### 🟢 UI Components & Styles
*   **Liquid Glass:** Use the new `.glassEffect(_:in:)` modifier and `.buttonStyle(.glass)` for the native translucent floating UI. Do not use legacy `UltraThinMaterial` hacks for this look.
*   **Native WebView:** Use the new `WebView(page: ...)` view directly in SwiftUI.
    *   *Deprecated:* Wrapping `WKWebView` in `UIViewRepresentable` is now an anti-pattern for simple web pages.
*   **TextEditor++:** The native `TextEditor` now supports `AttributedString` with embedded images and the `FindContext` API for search-within-text.
*   **Tab Bar Control:** New `.tabBarMinimizeBehavior(.automatic)` modifier to control when the floating tab bar collapses.

### 🔵 Layout & Containers (iOS 26 & 18)
*   **MeshGradient:** Use `MeshGradient` for complex, interpolated background colors.
*   **Custom Containers (Critical):** Use `Group(subviews:)` and `ForEach(subviews:)` to create custom layout containers.
    *   *Do Not Use:* `_VariadicView` or other internal private APIs. The public API is now available.
*   **Scroll Position:** Use `.scrollPosition($position)` with the new `ScrollPosition` type for precise control, replacing `ScrollViewReader` in most cases.

### 🔴 Gestures & Interaction
*   **Drag & Drop:** New declarative modifiers `draggable(containerItemID:...)` and `dragContainer(...)` for complex reordering interactions.
*   **Pencil Squeeze:** Support `onPencilSqueeze { ... }` for the new Apple Pencil Pro interactions.

---

## 3. Best Practices & Anti-Patterns (How to avoid errors)

### ✅ DO THIS (Modern Swift 6)
1.  **Concurrency:** ALWAYS use `await/async`. Mark UI-state ViewModels with `@MainActor`.
2.  **Observation:** Use the `@Observable` macro for all data models.
    *   *Migration:* If you see `ObservableObject` in the user's code, suggest refactoring to `@Observable`.
3.  **Entry Point:** Use `#Preview` instead of the old `PreviewProvider` struct.

### ❌ DO NOT DO THIS (Common Hallucinations)
1.  **Fake Modifiers:** DO NOT invent modifiers like `.cornerRadius(_:antialiased:)`. Use `.clipShape(RoundedRectangle(...))`.
2.  **Ghost Versions:** DO NOT refer to "iOS 19", "iOS 20", etc. They do not exist. The timeline jumped from 18 to 26.
3.  **Incorrect Glass:** Do not apply `.glassBackgroundEffect()` (which is for visionOS) to iOS views. Use `.glassEffect()` (iOS 26+) instead.
4.  **Legacy Web:** Do not suggest `SFSafariViewController` for inline web content; use the new SwiftUI `WebView`.

## 4. Code Generation Rules
*   **Safety:** Always add `if #available(iOS 26, *)` checks if using new features, unless the user specifies the project is iOS 26-only.
*   **Style:** Prefer composition. Break complex `body` views into smaller `private var` or separate structs.
*   **Imports:** Always import `SwiftUI`. Import `WebKit` only if advanced `WKWebView` configuration is strictly needed (rare in iOS 26).
```

# appffiiiiiiiilm
ios_prod_dis_exp

## iOS 26 Navigation & Liquid Glass Notes

### Tab Bar in iOS 26
Updated behaviors, new roles, accessory placement, and expanded customization APIs for the bottom bar (floating tab bar) model.

#### New Features in iOS 26 (June 2025)

##### `tabBarMinimizeBehavior(_:)`
Controls how the tab bar collapses or expands depending on user scroll interaction.

```swift
TabView {
    // tabs
}
.tabBarMinimizeBehavior(.automatic)
```

##### `TabRole.search`

Assigns a **search role** to a tab. Activating such a tab replaces the tab bar with a focused search view.

```swift
TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }

    Tab("Search", systemImage: "magnifyingglass", role: .search) {
        SearchView()
            .searchable(text: $searchText)
    }
}
```

##### `TabViewBottomAccessoryPlacement`

Controls how accessory views render above the tab bar depending on its current state (inline, expanded, etc.).

```swift
TabView {
    // tabs
}
.tabViewBottomAccessory {
    MiniPlayerView()
        .tabViewBottomAccessoryPlacement { placement in
            switch placement {
            case .expanded:
                FullPlayerView()
            case .inline:
                CompactPlayerView()
            default:
                EmptyView()
            }
        }
}
```

This enables dynamic bottom overlays—e.g., music players, Now Playing bars, tool palettes.

#### Features Introduced in iOS 25 (June 2024)

##### `tabViewStyle(_:)`
Defines device-aware tab view appearance (`.sidebarAdaptable`, `.tabBarOnly`, `.grouped`).

##### `TabSection`
Groups tabs into sections such as “More” without leaving the TabView.

##### `tabViewCustomization(_:)`
Exposes `TabViewCustomization` through `@AppStorage` so users can reorder and hide tabs.

#### Full Example for iOS 26

```swift
struct ContentView: View {
    @State private var searchText = ""
    @AppStorage("tabCustomization") private var customization: TabViewCustomization

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                ScrollView {
                    HomeContent()
                }
            }

            Tab("Browse", systemImage: "square.grid.2x2") {
                BrowseView()
            }

            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
                    .searchable(text: $searchText)
            }

            TabSection("More") {
                Tab("Library", systemImage: "books.vertical") {
                    LibraryView()
                }

                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
        .tabBarMinimizeBehavior(.automatic)
    }
}
```

Reference: https://developer.apple.com/documentation/swiftui/navigation

### Navigation Bar → Toolbar (iOS 26)
In iOS 26 Apple renamed the old **Navigation Bar** into the **Toolbar**, including the upper navigation APIs now using the `toolbar` prefix.

#### Key Components
- **`ToolbarSpacer`** – keeps toolbar items spaced correctly while respecting Liquid Glass styling.
- **`scrollEdgeEffectStyle(_:for:)`** – configures scroll-edge visual effects on scroll views.
- **`backgroundExtensionEffect()`** – extends, reflects, and blurs visuals beyond the safe area.

#### Example
```swift
NavigationStack {
    ScrollView {
        // Content
    }
    .navigationTitle("Title")
    .toolbar {
        ToolbarItem(placement: .topBarLeading) {
            Button("Action") { }
        }
        ToolbarSpacer()
        ToolbarItem(placement: .topBarTrailing) {
            Button("Settings") { }
        }
    }
    .scrollEdgeEffectStyle(.automatic, for: .scrollView)
}
```

### Liquid Glass Integration

iOS 26 adds native Liquid Glass support for toolbars.

#### New APIs
* **`glassEffect(_:in:)`** – applies Liquid Glass to any view.
* **`.glass` button style** – gives buttons a Liquid Glass treatment.

### Migration Notes

| iOS 25 | iOS 26 |
| --- | --- |
| Navigation Bar | **Toolbar** |
| `navigationBarItems` | `toolbar` / `ToolbarItem` |
| manual `Spacer()` | `ToolbarSpacer` |

#### New in iOS 26
* Liquid Glass toolbars.
* Unified toolbar terminology.

#### Deprecated / Review
* `navigationBarItems`
* Empty `Spacer()` hooks (replace with `ToolbarSpacer`)

## Tab Bar in iOS 26
Updated behaviors, new roles, accessory placement, and expanded customization APIs.

---

## New Features in iOS 26 (June 2025)

### `tabBarMinimizeBehavior(_:)`
Controls how the tab bar collapses or expands depending on user scroll interaction.

```swift
TabView {
    // tabs
}
.tabBarMinimizeBehavior(.automatic)
```

---

### `TabRole.search`

Assigns a **search role** to a tab.
When activated, the **tab bar transforms into a search field**, giving full focus to search.

```swift
TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }
    
    Tab("Search", systemImage: "magnifyingglass", role: .search) {
        SearchView()
            .searchable(text: $searchText)
    }
}
```

---

### `TabViewBottomAccessoryPlacement`

Controls how accessory views render above the tab bar depending on its current state (inline, expanded, etc.).

```swift
TabView {
    // tabs
}
.tabViewBottomAccessory {
    MiniPlayerView()
        .tabViewBottomAccessoryPlacement { placement in
            switch placement {
            case .expanded:
                FullPlayerView()   // expanded state
            case .inline:
                CompactPlayerView() // inline state
            default:
                EmptyView()
            }
        }
}
```

This enables dynamic bottom overlays—e.g., music players, now-playing bars, tool palettes.

---

## Features Introduced in iOS 25 (June 2024)

### `tabViewStyle(_:)`

Defines how `TabView` appears and behaves across device classes.

```swift
TabView {
    // tabs
}
.tabViewStyle(.sidebarAdaptable)
```

**Available styles:**

* `.sidebarAdaptable` — sidebar on iPad, tab bar on iPhone
* `.tabBarOnly` — tab bar without sidebar
* `.grouped` — grouped tab UI

---

### `TabSection`

Creates hierarchical tabs by grouping them into sections.

```swift
TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }

    TabSection("More") {
        Tab("Library", systemImage: "books.vertical") {
            LibraryView()
        }

        Tab("Settings", systemImage: "gear") {
            SettingsView()
        }
    }
}
```

---

### `tabViewCustomization(_:)`

Enables user-controlled tab customization (ordering, visibility).
State persists via `@AppStorage` using `TabViewCustomization`.

```swift
@AppStorage("tabCustomization") private var customization: TabViewCustomization

TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }
    
    Tab("Browse", systemImage: "square.grid.2x2") {
        BrowseView()
    }
}
.tabViewCustomization($customization)
```

---

## Full Example for iOS 26

```swift
struct ContentView: View {
    @State private var searchText = ""
    @AppStorage("tabCustomization") private var customization: TabViewCustomization
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                ScrollView {
                    HomeContent()
                }
            }
            
            Tab("Browse", systemImage: "square.grid.2x2") {
                BrowseView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
                    .searchable(text: $searchText)
            }
            
            TabSection("More") {
                Tab("Library", systemImage: "books.vertical") {
                    LibraryView()
                }
                
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
        .tabBarMinimizeBehavior(.automatic)
    }
}
```

---

Reference: Apple SwiftUI Navigation Documentation
[https://developer.apple.com/documentation/swiftui/navigation](https://developer.apple.com/documentation/swiftui/navigation)

## Padding sanity check

- Keep horizontal padding for each major section aligned with `FeedLayout.sectionHorizontalInset` and avoid relying on `Button` (or other controls) to supply it, so the visual block remains centered even if child layouts round differently.
- Titles that get a `FeedLayout.titleHorizontalPadding` inset should be followed by equally padded cards/content so the leading alignment does not appear offset; wrap every `recentStoryPreviewCard` or similar content in a container that enforces the same 18pt inset, and prefer explicit `Color.clear` frames or overlay patterns when using `.scaledToFill()` so the layout size matches the visible bounds.
