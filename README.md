# ColorKit 🎨

[![Swift 5.5+](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS 13+](https://img.shields.io/badge/iOS-13+-blue.svg)](https://developer.apple.com/ios/)
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

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "1.0.0")
]
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
        // Works with any JSON file name
        ColorKit.configure(jsonFileName: "your-colors") // or "design-tokens", "figma-export", etc.
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
                .foregroundColor(Colors.backgroundPrimary.color)  // from "Background.primary"
                .background(Colors.textPrimary.color)             // from "Text.primary"
            
            Button("Get Started") {
                // Action
            }
            .foregroundColor(Colors.brandPrimary.color)           // from "Brand.primary"
        }
        .background(Colors.backgroundSecondary.color)             // from "Background.secondary"
    }
}
```

**For simple naming (like "bg1", "bg2"):**
```swift
Text("Hello")
    .foregroundColor(Colors.bg1.color)      // from "bg1"
    .background(Colors.text1.color)         // from "text1"
```

## 🎯 Multiple Access Patterns

ColorKit provides four different ways to access your colors:

### 1. Property-Style Access (Recommended)
```swift
// ColorKit automatically generates properties from your JSON:
Colors.backgroundPrimary.color    // from "Background.primary" or "background-primary"
Colors.textPrimary.uiColor        // from "Text.primary" or "text-primary"
Colors.brandPrimary.color         // from "Brand.primary" or "brand-primary"
Colors.bg1.color                  // from "bg1"
Colors.accent.color               // from "accent"
```

### 2. Subscript Access
```swift
// Use exact JSON key names:
Colors["Background.primary"]?.color     // nested structure
Colors["bg1"]?.color                   // simple naming
Colors["Brand.primary"]?.uiColor
```

### 3. String-Based Access
```swift
// Works with any color name from your JSON:
Colors.color(named: "Background.primary")?.color
Colors.swiftUIColor(named: "bg1")
Colors.uiColor(named: "Brand.primary")
```

### 4. Semantic Grouping (Auto-Generated)
```swift
// For nested JSON structures, ColorKit creates semantic groupings:
Colors.Background.primary.color   // from "Background.primary"
Colors.Text.primary.color         // from "Text.primary" 
Colors.Brand.primary.color        // from "Brand.primary"
Colors.Status.success.color       // from "Status.success"
```

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

## 🌙 Dark Mode Support

ColorKit automatically supports light and dark themes:

### Automatic Theme JSON Structure
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

### Single Color (Used for Both Themes)
```json
{
  "brand-primary": "#007AFF"  // Same color for light/dark
}
```

Colors automatically adapt to the current interface style:

```swift
// Automatically shows correct color for current theme
Text("Hello")
    .foregroundColor(Colors.textPrimary.color)
```

## 🔧 Advanced Usage

### Color Discovery and Introspection

```swift
// Get all available colors
let allColors = Colors.allColorNames
print("Available colors: \(allColors)")

// Search colors
let brandColors = Colors.searchColors(containing: "brand")
print("Brand colors: \(brandColors)")

// Get colors by category
let colorsByCategory = Colors.colorsByCategory
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

- iOS 13.0+ / macOS 11.0+
- Swift 5.5+
- Xcode 13.0+

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

ColorKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 🙋‍♂️ Support

- 📖 [Documentation](https://github.com/ParkSY0919/ColorKit/wiki)
- 🐛 [Issue Tracker](https://github.com/ParkSY0919/ColorKit/issues)
- 💬 [Discussions](https://github.com/ParkSY0919/ColorKit/discussions)

---

Made with ❤️ by [ParkSY0919](https://github.com/ParkSY0919)
