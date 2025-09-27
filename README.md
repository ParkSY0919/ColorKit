# ColorKit 🎨

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS 14+](https://img.shields.io/badge/iOS-14+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 11+](https://img.shields.io/badge/macOS-11+-blue.svg)](https://developer.apple.com/macos/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**ColorKit** is a flexible Swift package that automatically discovers and manages colors from JSON design tokens. **Works with any color naming scheme** - whether your colors are named `bg1`, `background-primary`, `Background.primary`, or anything else. No configuration required - just drop in your JSON file and start using colors with full type safety, automatic fallbacks, and automatic dark mode support.

**Key Feature**: ColorKit features a **DynamicColorProperty** system that provides multiple access patterns, automatic fallbacks for missing colors, and progressive enhancement - write your UI code before colors exist in JSON!

[한국어 README](README_KR.md) | [English README](README.md)

---

## ✨ Key Features

- **🚀 Zero Configuration**: Just add your JSON file - no mapping setup required
- **🎯 Multiple Access Patterns**: DynamicColorProperty, subscript, string-based, and convenience namespaces
- **🛡️ Automatic Fallbacks**: Safe progressive development - colors fallback to Color.gray when missing
- **🔧 Kebab-case Support**: Automatic conversion and subscript access for design tool exports
- **🌙 Automatic Dark Mode**: Built-in light/dark theme support with automatic detection
- **📱 SwiftUI & UIKit**: Full support for both frameworks
- **🔍 Automatic Discovery**: Works with ANY color naming - `bg1`, `primaryColor`, `Brand.main`, etc.
- **⚡ Type Safety**: Compile-time safety with IDE autocompletion
- **🎨 Flexible JSON Support**: Works with Figma exports, custom tokens, nested structures
- **📦 Convenience Namespaces**: Organized access via Colors.Brand.main, Colors.Background.card, etc.

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

ColorKit automatically converts your JSON color names to Swift properties. Choose from multiple access patterns:

**DynamicColorProperty Access (Recommended):**

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome!")
                .foregroundColor(Colors.textPrimary.color)    // Auto-generated from JSON
                .font(.title)

            Text("Subtitle")
                .foregroundColor(Colors.textSecondary.color)  // Type-safe access
                .font(.body)

            Button("Get Started") {
                // Action
            }
            .foregroundColor(.white)
            .background(Colors.brandPrimary.color)        // Automatic dark mode
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundMain.color)          // Automatic fallbacks
    }
}
```

**Safe Access with Fallbacks:**

```swift
// Colors automatically fallback to Color.gray if not found in JSON
Text("Safe Development")
    .foregroundColor(Colors.futureColor.color)    // Won't crash if missing
    .background(Colors.anotherNewColor.color)      // Graceful degradation
```

**For design tool exports (kebab-case):**

```swift
Text("Design System")
    .foregroundColor(Colors["text-heading-large"]?.color ?? .primary)
    .background(Colors["background-surface-elevated"]?.color ?? .gray)
```

## 🎯 Multiple Access Patterns

ColorKit provides multiple ways to access your colors, supporting any naming convention with automatic fallbacks:

### 1. DynamicColorProperty Access (Recommended) ⭐

**Core feature** - automatic property generation with fallbacks:

```swift
// Automatic property generation from any JSON structure
Colors.brandPrimary.color           // From "brand-primary" or "Brand.primary"
Colors.textHeading.color            // From "text-heading" or "Text.heading"
Colors.backgroundMain.color         // From "background-main" or "Background.main"
Colors.successGreen.color           // From "success-green" or "successGreen"

// Safe progressive development - write code before colors exist!
Colors.futureFeatureColor.color     // Fallback to Color.gray if missing
Colors.notYetDefinedColor.color     // No crashes, graceful degradation

// Automatic kebab-case conversion
Colors.primaryButton.color          // Finds "primary-button" in JSON
Colors.errorMessageText.color       // Finds "error-message-text" in JSON
```

**Key Benefits:**

- ✅ **Type Safety**: Full IDE autocompletion
- ✅ **Fallback Protection**: Never crashes on missing colors
- ✅ **Progressive Enhancement**: Write UI before JSON is ready
- ✅ **Automatic Conversion**: Handles any naming convention

### 2. Convenience Namespace Access

**Organized access** for better code organization:

```swift
// Background colors
Colors.Background.main.color        // Primary background
Colors.Background.card.color        // Card backgrounds
Colors.Background.elevated.color    // Elevated surfaces

// Text colors
Colors.Text.heading.color           // Primary text
Colors.Text.body.color              // Body text
Colors.Text.caption.color           // Secondary text
Colors.Text.onPrimary.color         // Text on colored backgrounds

// Brand colors
Colors.Brand.main.color             // Primary brand
Colors.Brand.accent.color           // Accent brand
Colors.Brand.subtle.color           // Subtle brand

// State colors
Colors.State.success.color          // Success states
Colors.State.warning.color          // Warning states
Colors.State.danger.color           // Error states
Colors.State.info.color             // Info states

// Border colors
Colors.Border.light.color           // Light borders
Colors.Border.medium.color          // Standard borders
Colors.Border.accent.color          // Accent borders
```

### 3. Subscript Access for Exact Keys

**Direct access** using exact JSON keys (ideal for design tool exports):

```swift
// Exact JSON key matching
Colors["success-green"]?.color ?? .green
Colors["text-heading-large"]?.color ?? .primary
Colors["background.surface.elevated"]?.color ?? .gray
Colors["color/brand/primary"]?.color ?? .blue

// Figma token paths
Colors["color/primitive/gray/900"]?.color ?? .black
Colors["semantic/text/on-surface"]?.color ?? .primary
```

### 4. String-Based Access

**Dynamic access** for flexible color selection:

```swift
// Using string-based lookup
if let colorTheme = Colors.color(named: "brand-primary") {
    Text("Hello").foregroundColor(colorTheme.color)
}

// Dynamic color selection
let colorName = userPreference.colorScheme
if let theme = Colors.color(named: colorName) {
    view.backgroundColor = theme.color
}
```

### 5. Generated Colors Enum (via Build Plugin)

**Type-safe access** from design tokens:

```swift
// Generated from Figma design tokens
Colors.brandPrimary.color           // Type-safe, no typos possible
Colors.backgroundMain.color         // Full IDE support
Colors.textHeading.color            // Compile-time validation
```

## 🛡️ Automatic Fallback System

**ColorKit's key feature**: Safe progressive development with automatic fallbacks.

### How Fallbacks Work

```swift
// ✅ Colors exist in JSON - returns actual colors
Colors.brandPrimary.color           // Returns #007AFF from JSON
Colors.backgroundMain.color         // Returns #FFFFFF from JSON

// ✅ Colors don't exist in JSON - automatic fallback to Color.gray
Colors.futureFeatureColor.color     // Returns Color.gray (safe fallback)
Colors.notYetImplemented.color      // Returns Color.gray (won't crash)

// ✅ Warning messages in debug builds
// Console: "⚠️ Color 'futureFeatureColor' not found, using fallback"
```

### Progressive Enhancement Workflow

**1. Write UI Code First:**

```swift
struct NewFeatureView: View {
    var body: some View {
        VStack {
            Text("New Feature")
                .foregroundColor(Colors.featureHeaderText.color)    // Fallback: gray

            Button("Action") { }
                .background(Colors.featureActionButton.color)       // Fallback: gray

            Rectangle()
                .fill(Colors.featureAccentColor.color)             // Fallback: gray
        }
        .background(Colors.featureBackground.color)                // Fallback: gray
    }
}
```

**2. Add Colors to JSON Later:**

```json
{
  "featureHeaderText": "#1D1D1F",
  "featureActionButton": "#007AFF",
  "featureAccentColor": "#34C759",
  "featureBackground": "#F2F2F7"
}
```

**3. Colors Automatically Apply:**

```swift
// Same code - now uses actual colors from JSON!
// No code changes needed, automatic hot-reload
```

### Debug and Validation

```swift
// Validate your color setup
ColorKit.validateSetup()            // Prints setup status
ColorKit.printAllColors()           // Lists all available colors

// Check missing colors
let missingColors = ColorKit.missingColorNames
print("Missing colors: \(missingColors)")
```

## 🔧 Kebab-case and Special Character Support

**Ideal for design tool exports** - ColorKit handles any naming convention:

### Automatic Conversion

```swift
// JSON contains kebab-case:
// { "success-green": "#34C759", "primary-button": "#007AFF" }

// Access via converted property names:
Colors.successGreen.color           // Finds "success-green"
Colors.primaryButton.color          // Finds "primary-button"
Colors.textHeadingLarge.color       // Finds "text-heading-large"
```

### Subscript Access for Exact Keys

```swift
// For exact JSON key matching:
Colors["success-green"]?.color ?? .green
Colors["primary-button"]?.color ?? .blue
Colors["background.surface.elevated"]?.color ?? .gray
Colors["color/brand/primary"]?.color ?? .blue
```

### Figma Token Support

```json
{
  "color/primitive/gray/900": "#000000",
  "color/semantic/text/primary": "#1D1D1F",
  "spacing/component/button/padding": "16px",
  "elevation/surface/card": "0 2px 8px rgba(0,0,0,0.1)"
}
```

```swift
// Direct access to Figma paths:
Colors["color/primitive/gray/900"]?.color ?? .black
Colors["color/semantic/text/primary"]?.color ?? .primary

// Or converted property access:
Colors.colorPrimitiveGray900.color
Colors.colorSemanticTextPrimary.color
```

### 🎨 JSON Naming Best Practices

#### ✅ Option 1: CamelCase (Cleanest Swift Code)

```json
{
  "brandPrimary": "#007AFF",
  "backgroundMain": "#FFFFFF",
  "textHeading": "#1D1D1F",
  "successGreen": "#34C759"
}
```

```swift
// Clean, direct property access:
Colors.brandPrimary.color
Colors.backgroundMain.color
Colors.textHeading.color
Colors.successGreen.color
```

#### ✅ Option 2: Kebab-case (Design Tool Standard)

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#1D1D1F",
  "success-green": "#34C759"
}
```

```swift
// Auto-converted OR subscript access:
Colors.brandPrimary.color                    // Automatic conversion
Colors["brand-primary"]?.color ?? .blue      // Exact key access
```

#### ✅ Option 3: Semantic Namespaces

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

```swift
// Namespace access:
Colors.Brand.primary.color
Colors.Background.main.color

// Or flattened access:
Colors.brandPrimary.color
Colors.backgroundMain.color
```

> **💡 Pro Tip**: ColorKit adapts to YOUR naming convention - use what works best for your team!

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

### 🚀 Fallback System

ColorKit automatically chooses the appropriate method available:

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

ColorKit includes a build plugin that automatically generates Swift color enums from Figma design tokens:

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

// Check for specific colors
let hasColor = Colors.hasColor(named: "brandPrimary")
print("Brand primary exists: \(hasColor)")

// Get color info
if let colorInfo = Colors.colorInfo(for: "brandPrimary") {
    print("Color: \(colorInfo.lightHex) / \(colorInfo.darkHex ?? "same")")
}
```

### Error Handling and Debugging

```swift
// Comprehensive validation
ColorKit.validateSetup()                    // Prints setup status
ColorKit.printAllColors()                   // Lists all available colors
ColorKit.printMissingColors()               // Shows requested but missing colors

// Check ColorKit status
if ColorKit.isReady {
    print("✅ ColorKit loaded \(ColorKit.totalColorCount) colors")
    print("📊 Access patterns: \(ColorKit.supportedAccessPatterns)")
} else {
    print("❌ ColorKit setup failed: \(ColorKit.setupError ?? "Unknown error")")
}

// Debug specific colors
let debugInfo = Colors.debugInfo(for: "brandPrimary")
print("Debug info: \(debugInfo)")

// Monitor color access in debug builds
ColorKit.enableAccessLogging = true         // Logs all color access attempts
```

### Progressive Enhancement Best Practices

```swift
// ✅ DO: Use fallback colors for safety
struct SafeButton: View {
    var body: some View {
        Button("Action") { }
            .background(Colors.primaryAction.color)     // Fallback: gray
            .foregroundColor(.white)
    }
}

// ✅ DO: Provide fallback colors
struct RobustCard: View {
    var body: some View {
        VStack {
            Text("Content")
        }
        .background(Colors.cardBackground.color)        // Fallback: gray
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Colors.cardBorder.color, lineWidth: 1)  // Fallback: gray
        )
    }
}

// ❌ DON'T: Force unwrap colors
// .background(Colors["maybe-missing"]!.color)  // Will crash!

// ✅ DO: Use safe subscript access
.background(Colors["maybe-missing"]?.color ?? .gray)
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

## 🏗️ Real-World Integration Examples

### Complete SwiftUI App Example

```swift
struct ECommerceApp: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with brand colors
                    HeaderView()

                    // Product grid with semantic colors
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        ForEach(products) { product in
                            ProductCard(product: product)
                        }
                    }
                }
                .padding()
            }
            .background(Colors.Background.main.color)           // Semantic namespace
            .navigationTitle("Shop")
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("Welcome Back!")
                .foregroundColor(Colors.Text.heading.color)     // Namespace access
                .font(.title.bold())

            Text("Discover amazing products")
                .foregroundColor(Colors.Text.body.color)        // Automatic fallbacks
                .font(.body)
        }
        .padding()
        .background(Colors.Brand.subtle.color)                  // Brand colors
        .cornerRadius(12)
    }
}

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading) {
            // Product image placeholder
            Rectangle()
                .fill(Colors.Background.card.color)             // Card backgrounds
                .frame(height: 120)
                .cornerRadius(8)

            Text(product.name)
                .foregroundColor(Colors.Text.heading.color)
                .font(.headline)

            Text("$\(product.price, specifier: "%.2f")")
                .foregroundColor(Colors.Brand.main.color)       // Brand for price
                .font(.title2.bold())

            Button("Add to Cart") {
                // Add to cart action
            }
            .foregroundColor(.white)
            .background(Colors.State.success.color)             // Success action
            .cornerRadius(6)
            .padding(.top, 4)
        }
        .padding()
        .background(Colors.Background.elevated.color)           // Elevated surfaces
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Colors.Border.light.color, lineWidth: 1) // Border colors
        )
    }
}
```

### UIKit Integration Example

```swift
class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Main background
        view.backgroundColor = Colors.Background.main.uiColor

        // Header setup
        let headerView = createHeaderView()
        let statsContainer = createStatsContainer()
        let actionButtons = createActionButtons()

        // Auto Layout setup...
    }

    private func createHeaderView() -> UIView {
        let container = UIView()
        container.backgroundColor = Colors.Brand.subtle.uiColor
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "Dashboard"
        titleLabel.textColor = Colors.Text.heading.uiColor      // Semantic text
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Your business overview"
        subtitleLabel.textColor = Colors.Text.body.uiColor      // Body text
        subtitleLabel.font = .systemFont(ofSize: 16)

        // Add constraints...
        return container
    }

    private func createStatsContainer() -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.spacing = 16

        // Revenue card
        let revenueCard = createStatCard(
            title: "Revenue",
            value: "$12,345",
            color: Colors.State.success.uiColor                 // Success state
        )

        // Orders card
        let ordersCard = createStatCard(
            title: "Orders",
            value: "123",
            color: Colors.State.info.uiColor                    // Info state
        )

        // Alerts card
        let alertsCard = createStatCard(
            title: "Alerts",
            value: "3",
            color: Colors.State.warning.uiColor                 // Warning state
        )

        container.addArrangedSubview(revenueCard)
        container.addArrangedSubview(ordersCard)
        container.addArrangedSubview(alertsCard)

        return container
    }

    private func createStatCard(title: String, value: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = Colors.Background.card.uiColor   // Card background
        card.layer.cornerRadius = 8
        card.layer.borderWidth = 1
        card.layer.borderColor = Colors.Border.light.cgColor    // Light borders

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = Colors.Text.caption.uiColor      // Caption text
        titleLabel.font = .systemFont(ofSize: 14)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = color
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)

        // Add constraints...
        return card
    }

    private func createActionButtons() -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12

        // Primary action
        let primaryButton = UIButton()
        primaryButton.setTitle("Create New Order", for: .normal)
        primaryButton.backgroundColor = Colors.Brand.main.uiColor    // Main brand
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.layer.cornerRadius = 8

        // Secondary action
        let secondaryButton = UIButton()
        secondaryButton.setTitle("View Reports", for: .normal)
        secondaryButton.backgroundColor = Colors.Background.elevated.uiColor
        secondaryButton.setTitleColor(Colors.Text.heading.uiColor, for: .normal)
        secondaryButton.layer.cornerRadius = 8
        secondaryButton.layer.borderWidth = 1
        secondaryButton.layer.borderColor = Colors.Border.medium.cgColor

        container.addArrangedSubview(primaryButton)
        container.addArrangedSubview(secondaryButton)

        return container
    }
}
```

### Progressive Enhancement Workflow Example

```swift
// Phase 1: Start development with placeholder colors
struct NewFeatureView: View {
    var body: some View {
        VStack {
            Text("New Feature")
                .foregroundColor(Colors.newFeatureTitle.color)      // Fallback: gray

            FeatureCard()
                .background(Colors.newFeatureBackground.color)      // Fallback: gray
        }
    }
}

// Phase 2: Designer provides colors, add to JSON
// JSON Update:
{
  "newFeatureTitle": "#1D1D1F",
  "newFeatureBackground": "#F2F2F7",
  "newFeatureAccent": "#007AFF"
}

// Phase 3: Colors automatically apply, no code changes needed!
// The same SwiftUI code now uses the actual colors

// Phase 4: Refine with semantic naming
{
  "Feature": {
    "title": "#1D1D1F",
    "background": "#F2F2F7",
    "accent": "#007AFF"
  }
}

// Access via namespace: Colors.Feature.title.color
```

## 🚨 Error Handling & Troubleshooting

### Common Issues and Solutions

#### 1. Colors Not Loading

```swift
// Diagnostic code to add to your app:
func diagnoseColorKit() {
    print("=== ColorKit Diagnostics ===")
    print("Is Ready: \(ColorKit.isReady)")
    print("Total Colors: \(ColorKit.totalColorCount)")
    print("JSON File: \(ColorKit.configuredFileName ?? "None")")

    if let error = ColorKit.setupError {
        print("❌ Setup Error: \(error)")
    }

    // Check JSON file exists
    if let fileName = ColorKit.configuredFileName {
        let fileExists = Bundle.main.path(forResource: fileName, ofType: "json") != nil
        print("JSON File Exists: \(fileExists)")
    }
}
```

#### 2. Missing Color Warnings

```swift
// Enable debug logging to see which colors are missing
ColorKit.enableMissingColorWarnings = true

// Get list of requested but missing colors
let missingColors = ColorKit.requestedMissingColors
print("Missing colors: \(missingColors)")

// Export missing colors as JSON template
let jsonTemplate = ColorKit.generateJSONTemplate(for: missingColors)
print("Add to your JSON:\n\(jsonTemplate)")
```

#### 3. JSON Format Validation

```swift
// Validate JSON structure
if let validationResult = ColorKit.validateJSON() {
    switch validationResult {
    case .valid:
        print("✅ JSON is valid")
    case .invalidFormat(let error):
        print("❌ Invalid JSON format: \(error)")
    case .missingFile:
        print("❌ JSON file not found")
    case .emptyFile:
        print("❌ JSON file is empty")
    }
}
```

#### 4. Dark Mode Issues

```swift
// Check dark mode setup
print("Light theme colors: \(ColorKit.lightThemeColorCount)")
print("Dark theme colors: \(ColorKit.darkThemeColorCount)")
print("Has separate theme files: \(ColorKit.hasSeparateThemeFiles)")

// Force theme for testing
ColorKit.setDebugTheme(.light)      // Test light theme
ColorKit.setDebugTheme(.dark)       // Test dark theme
ColorKit.setDebugTheme(.system)     // Reset to system
```

### Best Practices for Robust Apps

```swift
// ✅ Always use fallback colors
struct RobustView: View {
    var body: some View {
        Text("Content")
            .foregroundColor(Colors.primaryText.color)          // Auto-fallback
            .background(Colors["custom-bg"]?.color ?? .gray)     // Manual fallback
    }
}

// ✅ Validate setup in production
struct ContentView: View {
    @State private var colorKitReady = false

    var body: some View {
        Group {
            if colorKitReady {
                MainAppView()
            } else {
                LoadingView()
            }
        }
        .onAppear {
            validateColorKitSetup()
        }
    }

    private func validateColorKitSetup() {
        if ColorKit.isReady {
            colorKitReady = true
        } else {
            // Log error and use fallback
            print("ColorKit setup failed: \(ColorKit.setupError ?? "Unknown")")
            colorKitReady = true  // Continue with fallback colors
        }
    }
}

// ✅ Graceful degradation
extension Colors {
    static func safeColor(named name: String, fallback: Color = .gray) -> Color {
        return Colors.color(named: name)?.color ?? fallback
    }
}

// Usage:
Text("Safe Text")
    .foregroundColor(Colors.safeColor(named: "brand-primary", fallback: .blue))
```

## 📋 Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## 🎯 Migration Guide

### From Hard-coded Colors

```swift
// Before: Hard-coded colors
struct OldView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(Color(red: 0, green: 0.478, blue: 1))  // #007AFF
            .background(Color(red: 0.949, green: 0.949, blue: 0.97)) // #F2F2F7
    }
}

// After: ColorKit with fallbacks
struct NewView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(Colors.brandPrimary.color)          // Auto-fallback
            .background(Colors.backgroundSecondary.color)        // Auto-fallback
    }
}
```

### From Asset Catalog

```swift
// Before: Asset Catalog colors
struct OldView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(Color("BrandPrimary"))     // Asset name
            .background(Color("BackgroundMain"))        // Asset name
    }
}

// After: ColorKit (same color names work!)
struct NewView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(Colors.brandPrimary.color) // Auto-converted
            .background(Colors.backgroundMain.color)    // Auto-converted
    }
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Setup

```bash
# Clone the repo
git clone https://github.com/ParkSY0919/ColorKit.git
cd ColorKit

# Open in Xcode
open Package.swift

# Run tests
xcodebuild test -scheme ColorKit
```

## 🏆 ColorKit Benefits

### vs. Hard-coded Colors

- ✅ **Centralized Management**: One JSON file vs scattered color values
- ✅ **Designer Collaboration**: Direct Figma export support
- ✅ **Automatic Dark Mode**: No manual theme switching needed
- ✅ **Type Safety**: Compile-time validation vs runtime errors

### vs. Asset Catalog

- ✅ **Zero Setup**: No manual color registration needed
- ✅ **Bulk Import**: Add hundreds of colors at once
- ✅ **Progressive Enhancement**: Write code before colors exist
- ✅ **Multiple Access Patterns**: Various ways to access same colors

### vs. Manual Theme Systems

- ✅ **Automatic Discovery**: No color mapping required
- ✅ **Fallback Protection**: Never crashes on missing colors
- ✅ **Namespace Organization**: Structured color grouping
- ✅ **Multi-Platform**: Works across SwiftUI and UIKit

## 💡 Community Examples

### E-commerce App Colors

```json
{
  "Brand": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  },
  "Product": {
    "price": "#FF3B30",
    "sale": "#FF9500",
    "rating": "#FFCC02"
  },
  "Action": {
    "buy": "#34C759",
    "wishlist": "#FF2D92",
    "share": "#5AC8FA"
  }
}
```

### Financial App Colors

```json
{
  "Status": {
    "profit": "#30D158",
    "loss": "#FF453A",
    "neutral": "#8E8E93"
  },
  "Account": {
    "checking": "#007AFF",
    "savings": "#34C759",
    "credit": "#FF9500"
  }
}
```

### Social Media App Colors

```json
{
  "Social": {
    "like": "#FF3B30",
    "comment": "#007AFF",
    "share": "#34C759",
    "follow": "#5856D6"
  },
  "Status": {
    "online": "#30D158",
    "away": "#FFCC02",
    "busy": "#FF453A"
  }
}
```

## 📄 License

ColorKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

[⭐ Star on GitHub](https://github.com/ParkSY0919/ColorKit) | [🐛 Report Issues](https://github.com/ParkSY0919/ColorKit/issues) | [💬 Discussions](https://github.com/ParkSY0919/ColorKit/discussions)
