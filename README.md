# ColorKit 🎨

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS 14+](https://img.shields.io/badge/iOS-14+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 11+](https://img.shields.io/badge/macOS-11+-blue.svg)](https://developer.apple.com/macos/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**ColorKit** is a powerful, flexible Swift package that automatically discovers and manages colors from JSON design tokens. **Works with any color naming scheme** - whether your colors are named `bg1`, `background-primary`, `Background.primary`, or anything else. No configuration required - just drop in your JSON file and start using colors with full type safety and automatic dark mode support.

[한국어 README](README_KR.md) | [English README](README.md)

---

## ✨ Key Features

- **🚀 Zero Configuration**: Just add your JSON file - no mapping setup required
- **🎯 Multiple Access Patterns**: Property-based, subscript, or string-based access
- **🌙 Automatic Dark Mode**: Built-in light/dark theme support
- **📱 SwiftUI & UIKit**: Full support for both frameworks
- **🔍 Smart Discovery**: Works with ANY color naming - `bg1`, `primaryColor`, `Brand.main`, etc.
- **⚡ Type Safety**: Compile-time safety with IDE autocompletion
- **🎨 Flexible JSON Support**: Works with Figma exports, custom tokens, nested structures

## 🚀 Quick Start

### 1. Install ColorKit

Add ColorKit to your project using Swift Package Manager:

#### In Xcode

1. Go to **File > Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ParkSY0919/ColorKit.git`
3. Select **Up to Next Major Version** and enter `0.1.0`
4. Click **Add Package**

#### In Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.1.0")
]
```

#### Using CocoaPods

```ruby
pod 'ColorKit', '~> 0.1'
```

#### Using Carthage

```
github "ParkSY0919/ColorKit" ~> 0.1
```

### 2. Add Your Colors JSON

ColorKit works with any JSON color structure! Here are some examples:

**Simple format:**

```json
{
  "bg1": "#FFFFFF",
  "bg2": "#F5F5F5",
  "text1": "#000000",
  "text2": "#666666",
  "accent": "#007AFF"
}
```

**Nested structure (like Figma exports):**

```json
{
  "Background": {
    "primary": "#FFFFFF",
    "secondary": "#F5F5F5"
  },
  "Text": {
    "primary": "#000000",
    "secondary": "#666666"
  },
  "Brand": {
    "primary": "#007AFF"
  }
}
```

### 3. Configure ColorKit

In your App file or early in app lifecycle:

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        // Works with any JSON file name - ColorKit automatically detects light/dark variants!
        ColorKit.configure(jsonFileName: "app-colors")
        // Automatically finds:
        // - app-colors-light.json + app-colors-dark.json (for separate theme files)
        // - OR app-colors.json (for single file with embedded themes)

        // Optional: Validate setup
        ColorKit.validateSetup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 4. Use Colors Everywhere

ColorKit automatically converts your JSON color names to Swift properties:

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome!")
                .foregroundColor(Colors.color(forKey: "Background.primary")?.color ?? .primary)
                .background(Colors.color(forKey: "Text.primary")?.color ?? .black)

            Button("Get Started") {
                // Action
            }
            .foregroundColor(Colors.color(forKey: "Brand.primary")?.color ?? .blue)
        }
        .background(Colors.color(forKey: "Background.secondary")?.color ?? .gray)
    }
}
```

**For simple naming (like "bg1", "bg2"):**

```swift
Text("Hello")
    .foregroundColor(Colors.color(forKey: "bg1")?.color ?? .black)
    .background(Colors.color(forKey: "text1")?.color ?? .white)
```

## 🎯 Multiple Access Patterns

ColorKit provides multiple ways to access your colors, supporting any naming convention:

### 1. Dynamic Color Access (Recommended)

```swift
// Access colors using dynamic provider with automatic discovery
if let theme = Colors.color(forKey: "backgroundPrimary") {
    Text("Hello").foregroundColor(theme.color)
}

// Or using property names
if let theme = Colors.color(forProperty: "backgroundPrimary") {
    Text("Hello").foregroundColor(theme.color)
}

// Both return ColorTheme with automatic light/dark support
```

### 2. String-Based Access

```swift
// Direct access using JSON key names
if let colorTheme = ColorKit.shared.dynamicProvider?.colorTheme(forKey: "background-primary") {
    Text("Hello").foregroundColor(colorTheme.color)
}

// Works with any JSON structure - nested, kebab-case, etc.
ColorKit.shared.dynamicProvider?.colorTheme(forKey: "Brand.primary")
ColorKit.shared.dynamicProvider?.colorTheme(forKey: "success-green")
```

### 3. Generated Colors Enum (via Build Plugin)

```swift
// If using the build plugin, access generated enum cases:
Colors.brandPrimary     // Generated from design tokens
Colors.backgroundMain   // Type-safe access with autocompletion
Colors.successGreen     // All colors available as enum cases
```

### 🎨 JSON Naming Best Practices

#### ✅ Recommended: CamelCase (Clean Property Access)

```json
{
  "primaryButton": "#007AFF",
  "successGreen": "#34C759",
  "errorRed": "#FF3B30",
  "backgroundMain": "#FFFFFF"
}
```

```swift
// Clean, type-safe property access:
Button("Submit")
    .foregroundColor(Colors.primaryButton.color)
    .background(Colors.successGreen.color)
```

#### 🔄 Alternative: Kebab-case/Special Characters (Subscript Access)

```json
{
  "primary-button": "#007AFF",
  "success-green": "#34C759",
  "error-red": "#FF3B30",
  "background.main": "#FFFFFF"
}
```

```swift
// Subscript access with fallback colors (recommended for safety):
Button("Submit")
    .foregroundColor(Colors["primary-button"]?.color ?? .blue)
    .background(Colors["success-green"]?.color ?? .green)
```

#### 📦 Figma/Design Tool Exports

Most design tools export with kebab-case or dots. ColorKit handles these perfectly:

```json
{
  "color/brand/primary": "#007AFF",
  "text-heading-large": "#000000",
  "background.surface.elevated": "#F5F5F5"
}
```

```swift
// Use subscript access for design tool exports:
Colors["color/brand/primary"]?.color ?? .blue
Colors["text-heading-large"]?.color ?? .black
Colors["background.surface.elevated"]?.color ?? .gray
```

#### 🏗️ Nested Structures (Any Access Method)

```json
{
  "Button": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  }
}
```

```swift
// Both work for nested structures:
Colors["Button.primary"]?.color     // Explicit path
Colors.buttonPrimary.color          // Auto-generated property (if available)
```

> **💡 Pro Tip**: Use camelCase in your JSON for the cleanest Swift code, but ColorKit supports any naming convention you need!

## 🎨 Supported JSON Structures

ColorKit automatically handles various JSON color formats. **Your color names can be anything** - ColorKit adapts to your naming convention:

### Simple Key-Value (Any Names Work!)

```json
{
  "bg1": "#FFFFFF",
  "bg2": "#F5F5F5",
  "text1": "#000000",
  "accent": "#007AFF",
  "primaryColor": "#5856D6"
}
```

### Nested Objects

```json
{
  "brand": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  },
  "text": {
    "heading": "#000000",
    "body": "#333333"
  }
}
```

### Figma Design Tokens

```json
{
  "color": {
    "brand": {
      "primary": {
        "500": {
          "value": "#007AFF",
          "type": "color"
        }
      }
    }
  }
}
```

### Array Format

```json
[
  {
    "name": "brand-primary",
    "value": "#007AFF"
  },
  {
    "name": "text-heading",
    "value": "#000000"
  }
]
```

## 🌙 Automatic Light/Dark Mode Support

ColorKit provides **three ways** to handle light and dark themes, automatically detecting the best approach:

### Method 1: Separate Light/Dark JSON Files (Recommended) 🆕

Simply create two JSON files with `-light` and `-dark` suffixes:

**app-colors-light.json:**

```json
{
  "bg1": "#FFFFFF",
  "bg2": "#F5F5F5",
  "text1": "#000000",
  "text2": "#666666",
  "accent": "#007AFF",
  "success-green": "#34C759",
  "error-red": "#FF3B30"
}
```

**app-colors-dark.json:**

```json
{
  "bg1": "#000000",
  "bg2": "#1C1C1E",
  "text1": "#FFFFFF",
  "text2": "#AEAEB2",
  "accent": "#0A84FF",
  "success-green": "#30D158",
  "error-red": "#FF453A"
}
```

**No code changes required!** ColorKit automatically detects both files and enables dynamic color switching:

```swift
// Same configuration as before
ColorKit.configure(jsonFileName: "app-colors")

// Colors automatically switch between light/dark themes
Text("Hello")
    .foregroundColor(Colors.text1.color)     // White in dark mode, black in light mode
    .background(Colors.bg1.color)            // Black in dark mode, white in light mode
```

### Method 2: Embedded Light/Dark Structure

```json
{
  "background-main": {
    "light": "#FFFFFF",
    "dark": "#000000"
  },
  "text-primary": {
    "light": "#000000",
    "dark": "#FFFFFF"
  }
}
```

### Method 3: Single Color (Used for Both Themes)

```json
{
  "brand-primary": "#007AFF" // Same color for light/dark
}
```

### 🚀 Smart Fallback System

ColorKit automatically chooses the best method available:

1. **If both `-light.json` and `-dark.json` exist** → Uses separate files (Method 1)
2. **If only single JSON exists** → Checks for embedded light/dark structure (Method 2)
3. **If neither** → Uses single colors for both themes (Method 3)

### ✨ Real-time Theme Switching

Colors automatically adapt when users switch between light and dark mode in device settings:

```swift
// No additional code needed - automatic theme switching!
VStack {
    Text("Dynamic Text")
        .foregroundColor(Colors.text1.color)        // Adapts automatically

    Rectangle()
        .fill(Colors.bg2.color)                     // Adapts automatically

    Button("Action") { }
        .foregroundColor(Colors["error-red"]?.color) // Works with any naming
}
.background(Colors.bg1.color)                       // Background adapts too
```

## 🏗️ Build Plugin & Code Generation

ColorKit includes a powerful build plugin that automatically generates Swift color enums from Figma design tokens:

### Setup Build Plugin

1. **Add design token files** to your target's `Resources/design-tokens/` directory:

   - `light.tokens.json` - Light theme colors from Figma
   - `dark.tokens.json` - Dark theme colors from Figma
   - `primitive.tokens.json` - Base color definitions

2. **The plugin automatically runs** during build and generates:
   - `Colors.swift` - Type-safe enum with all your colors
   - `ColorThemes.swift` - Internal theme data

### Figma Token Format

```json
// light.tokens.json
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

// primitive.tokens.json
{
  "color": {
    "primitive": {
      "gray": {
        "900": {
          "$type": "color",
          "$value": "#000000"
        }
      }
    }
  }
}
```

### Using Generated Colors

```swift
// Type-safe access to generated colors
Colors.brandPrimary      // From "brand.primary"
Colors.textHeading       // From "text.heading"

// Automatic light/dark theme support
Text("Hello")
    .foregroundColor(Colors.brandPrimary.color)  // Adapts to system theme
```

## 🔧 Advanced Usage

### Color Discovery and Introspection

```swift
// Get all available colors (from dynamic provider)
if let dynamicProvider = ColorKit.shared.dynamicProvider {
    let allColors = dynamicProvider.allColorNames
    print("Available colors: \(allColors)")

    let colorsByCategory = dynamicProvider.colorsByCategory
    print("Colors by category: \(colorsByCategory)")
}
```

### Validation and Debugging

```swift
// Validate setup
ColorKit.validateSetup()

// Print all colors for debugging
ColorKit.printAllColors()

// Check if ColorKit is ready
if ColorKit.isReady {
    print("✅ ColorKit loaded \(ColorKit.totalColorCount) colors")
} else {
    print("❌ ColorKit setup failed: \(ColorKit.setupError ?? "Unknown error")")
}
```

### Legacy Mapping Support (Optional)

For advanced use cases, you can still use the mapping system:

```swift
let mappings = ColorMappingSet([
    ColorMapping(jsonColorName: "brand-primary", role: .primary),
    ColorMapping(jsonColorName: "success-green", role: .success)
])

ColorKit.configure(with: mappings, jsonFileName: "app-colors")

// Access via roles
AppColors.primary.color
AppColors.success.color
```

## 🏗️ Integration Examples

### SwiftUI Example

```swift
struct MyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Title")
                .foregroundColor(Colors.textPrimary.color)     // from "Text.primary"
                .font(.title)

            Text("Subtitle")
                .foregroundColor(Colors.textSecondary.color)   // from "Text.secondary"
                .font(.body)

            Button("Action") {
                // Handle action
            }
            .foregroundColor(.white)
            .background(Colors.brandPrimary.color)          // from "Brand.primary"
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundPrimary.color)         // from "Background.primary"
    }
}
```

### UIKit Example

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary.uiColor   // from "Background.primary"

        let titleLabel = UILabel()
        titleLabel.textColor = Colors.textPrimary.uiColor         // from "Text.primary"
        titleLabel.text = "Welcome"

        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.brandPrimary.uiColor      // from "Brand.primary"
        button.setTitle("Get Started", for: .normal)

        // Add to view hierarchy...
    }
}
```

## 📋 Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

ColorKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
