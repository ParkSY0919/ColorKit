# ColorKit Guide

[한국어](GUIDE.md)

Complete API reference and configuration guide for ColorKit.

---

## Table of Contents

1. [Installation](#installation)
2. [Configuration](#configuration)
3. [JSON File Formats](#json-file-formats)
4. [Access Patterns](#access-patterns)
5. [Dark Mode Support](#dark-mode-support)
6. [Build Plugin](#build-plugin)
7. [Debugging](#debugging)
8. [Migration Guide](#migration-guide)

---

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.2.0")
]
```

### Xcode Integration

1. File → Add Package Dependencies
2. Enter repository URL: `https://github.com/ParkSY0919/ColorKit.git`
3. Select version `0.2.0` or later
4. Assign **ColorKit (Library)** to your app target
5. Assign **ColorKitPlugin (Executable)** to your app target

If ColorKitPlugin is set to "None":
- Static color properties won't be generated
- IDE autocompletion will be limited
- Subscript access (`Colors["key"]`) still works

### CocoaPods

```ruby
pod 'ColorKit', '~> 0.2'
```

### Carthage

```
github "ParkSY0919/ColorKit" ~> 0.2
```

---

## Configuration

### Basic Setup

Call `configure()` early in app lifecycle:

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        ColorKit.configure(jsonFileName: "app-colors")
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

### UIKit Apps

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ColorKit.configure(jsonFileName: "app-colors")
        return true
    }
}
```

### Validation

Check if ColorKit loaded correctly:

```swift
ColorKit.validateSetup()  // Prints status to console

if ColorKit.isReady {
    print("Loaded \(ColorKit.totalColorCount) colors")
} else {
    print("Error: \(ColorKit.setupError ?? "Unknown")")
}
```

---

## JSON File Formats

ColorKit accepts multiple JSON structures.

### Simple Key-Value

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#1D1D1F",
  "text-body": "#666666"
}
```

### Nested Objects

```json
{
  "Brand": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  },
  "Background": {
    "main": "#FFFFFF",
    "card": "#F2F2F7"
  }
}
```

### Figma Token Format

```json
{
  "color": {
    "brand": {
      "primary": {
        "$type": "color",
        "$value": "#007AFF"
      }
    }
  }
}
```

### Array Format

```json
[
  { "name": "brand-primary", "value": "#007AFF" },
  { "name": "text-heading", "value": "#1D1D1F" }
]
```

### Naming Conventions

ColorKit converts JSON keys to Swift properties:

| JSON Key | Swift Property |
|----------|----------------|
| `brand-primary` | `Colors.brandPrimary` |
| `text-heading` | `Colors.textHeading` |
| `Background.main` | `Colors.backgroundMain` |

---

## Access Patterns

### 1. Property Access (Recommended)

```swift
Colors.brandPrimary.color       // SwiftUI Color
Colors.brandPrimary.uiColor     // UIKit UIColor
Colors.brandPrimary.cgColor     // Core Graphics CGColor
```

Missing colors fallback to `Color.gray`:

```swift
Colors.undefinedColor.color     // Returns Color.gray, no crash
```

### 2. Subscript Access

For exact JSON key matching:

```swift
Colors["brand-primary"]?.color ?? .blue
Colors["Background.main"]?.color ?? .white
```

### 3. Namespace Access

Organized by category:

```swift
// Background
Colors.Background.main.color
Colors.Background.card.color
Colors.Background.elevated.color

// Text
Colors.Text.heading.color
Colors.Text.body.color
Colors.Text.caption.color

// Brand
Colors.Brand.main.color
Colors.Brand.accent.color

// State
Colors.State.success.color
Colors.State.warning.color
Colors.State.danger.color

// Border
Colors.Border.light.color
Colors.Border.medium.color
```

### 4. String-Based Access

For dynamic color selection:

```swift
if let theme = Colors.color(named: "brand-primary") {
    view.backgroundColor = theme.uiColor
}

let colorName = userSettings.accentColor
Colors.color(named: colorName)?.color ?? .blue
```

---

## Dark Mode Support

### Method 1: Separate Files (Recommended)

Create two files with `-light` and `-dark` suffixes:

**colors-light.json**
```json
{
  "background": "#FFFFFF",
  "text": "#000000"
}
```

**colors-dark.json**
```json
{
  "background": "#000000",
  "text": "#FFFFFF"
}
```

Configure with base name:

```swift
ColorKit.configure(jsonFileName: "colors")
// Automatically finds colors-light.json and colors-dark.json
```

File naming requirements:
- Use `-light` and `-dark` suffixes (kebab-case)
- `colors-light.json` / `colors-dark.json` works
- `colorsLight.json` / `colorsDark.json` does not work

### Method 2: Embedded Structure

Single file with light/dark values:

```json
{
  "background": {
    "light": "#FFFFFF",
    "dark": "#000000"
  },
  "text": {
    "light": "#000000",
    "dark": "#FFFFFF"
  }
}
```

### Method 3: Single Value

Same color for both themes:

```json
{
  "brand-primary": "#007AFF"
}
```

---

## Build Plugin

ColorKitPlugin generates Swift code from Figma design tokens.

### Setup

1. Add token files to `Resources/design-tokens/`:
   - `light.tokens.json`
   - `dark.tokens.json`
   - `primitive.tokens.json` (optional)

2. Plugin runs automatically during build

3. Generated files:
   - `Colors.swift` - Type-safe color enum
   - `ColorThemes.swift` - Theme data

### Token Format

```json
{
  "brand": {
    "primary": {
      "$type": "color",
      "$value": "#007AFF"
    }
  },
  "text": {
    "heading": {
      "$type": "color",
      "$value": "{color.primitive.gray.900}"
    }
  }
}
```

---

## Debugging

### Print All Colors

```swift
ColorKit.printAllColors()
```

Output:
```
brandPrimary: #007AFF → #0A84FF
backgroundMain: #FFFFFF → #000000
textHeading: #1D1D1F → #FFFFFF
```

### Check Missing Colors

```swift
// Enable/disable warnings (default: true)
ColorKit.enableMissingColorWarnings = true

// Get list of missing colors
let missing = ColorKit.requestedMissingColors

// Print all missing colors
ColorKit.printMissingColors()

// Clear the record
ColorKit.clearMissingColors()
```

### Color Existence and Info

```swift
// Check if color exists
if Colors.hasColor(named: "brandPrimary") {
    print("Color exists")
}

// Get color info
if let info = Colors.colorInfo(for: "brandPrimary") {
    print("Light: \(info.lightHex)")  // #007AFF
    print("Dark: \(info.darkHex)")    // #0A84FF
}

// Get debug string
print(Colors.debugInfo(for: "brandPrimary"))
```

### Access Logging

```swift
ColorKit.enableAccessLogging = true
// Logs every color access attempt
```

### Validate Setup

```swift
// Check if ColorKit loaded successfully
ColorKit.validateSetup()

// Or check programmatically
if ColorKit.isReady {
    print("Loaded \(ColorKit.totalColorCount) colors")
} else {
    print("Error: \(ColorKit.setupError ?? "Unknown")")
}
```

---

## Migration Guide

### From Hard-coded Colors

Before:
```swift
Text("Hello")
    .foregroundColor(Color(red: 0, green: 0.478, blue: 1))
```

After:
```swift
Text("Hello")
    .foregroundColor(Colors.brandPrimary.color)
```

### From Asset Catalog

Before:
```swift
Text("Hello")
    .foregroundColor(Color("BrandPrimary"))
```

After:
```swift
Text("Hello")
    .foregroundColor(Colors.brandPrimary.color)
```

### Gradual Migration

Use both systems during transition:

```swift
// New colors via ColorKit
.foregroundColor(Colors.textHeading.color)

// Legacy colors via Asset Catalog
.background(Color("LegacyBackground"))
```

---

## SwiftUI Examples

### Basic View

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Title")
                .foregroundColor(Colors.textHeading.color)

            Text("Body text")
                .foregroundColor(Colors.textBody.color)

            Button("Action") { }
                .foregroundColor(.white)
                .padding()
                .background(Colors.brandPrimary.color)
                .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundMain.color)
    }
}
```

### Card Component

```swift
struct CardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Card Title")
                .foregroundColor(Colors.Text.heading.color)

            Text("Card content goes here")
                .foregroundColor(Colors.Text.body.color)
        }
        .padding()
        .background(Colors.Background.card.color)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Colors.Border.light.color, lineWidth: 1)
        )
    }
}
```

---

## UIKit Examples

### View Controller

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundMain.uiColor

        let label = UILabel()
        label.text = "Hello"
        label.textColor = Colors.textHeading.uiColor

        let button = UIButton()
        button.setTitle("Action", for: .normal)
        button.backgroundColor = Colors.brandPrimary.uiColor
        button.layer.cornerRadius = 8
    }
}
```

---

## Troubleshooting

### Colors not loading

1. Check JSON file is in app bundle
2. Verify file name matches `configure()` parameter
3. Call `ColorKit.validateSetup()` for diagnostics

### Dark mode not working

1. Verify file naming: `name-light.json` / `name-dark.json`
2. Check both files exist in bundle
3. Ensure both files have matching keys

### Build plugin not generating

1. Confirm ColorKitPlugin is assigned to target
2. Check token files are in `Resources/design-tokens/`
3. Clean build folder and rebuild

---

[← Back to README](../README.md)
