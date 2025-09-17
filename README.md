# ColorKit 🎨

[![Swift 5.5+](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS 13+](https://img.shields.io/badge/iOS-13+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 11+](https://img.shields.io/badge/macOS-11+-blue.svg)](https://developer.apple.com/macos/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**ColorKit** is a powerful, flexible Swift package that automatically discovers and manages colors from JSON design tokens. No configuration required - just drop in your JSON file and start using colors with full type safety and automatic dark mode support.

[한국어 README](README_KR.md) | [English README](README.md)

---

## ✨ Key Features

- **🚀 Zero Configuration**: Just add your JSON file - no mapping setup required
- **🎯 Multiple Access Patterns**: Property-based, subscript, or string-based access
- **🌙 Automatic Dark Mode**: Built-in light/dark theme support
- **📱 SwiftUI & UIKit**: Full support for both frameworks
- **🔍 Smart Discovery**: Automatically finds and converts any JSON color structure
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

Create a JSON file in your app bundle (e.g., `Resources/app-colors.json`):

```json
{
  "brand-primary": "#007AFF",
  "brand-secondary": "#5856D6", 
  "text-heading": "#000000",
  "text-body": "#333333",
  "background-main": "#FFFFFF",
  "success-green": "#34C759",
  "error-red": "#FF3B30"
}
```

### 3. Configure ColorKit

In your App file or early in app lifecycle:

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        ColorKit.configure(jsonFileName: "app-colors")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 4. Use Colors Everywhere

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome!")
                .foregroundColor(Colors.brandPrimary.color)
                .background(Colors.backgroundMain.color)
            
            Button("Success") {
                // Action
            }
            .foregroundColor(Colors.successGreen.color)
        }
    }
}
```

## 🎯 Multiple Access Patterns

ColorKit provides four different ways to access your colors:

### 1. Property-Style Access (Recommended)
```swift
Colors.brandPrimary.color        // SwiftUI Color
Colors.brandPrimary.uiColor      // UIColor
Colors.textHeading.color
Colors.backgroundMain.color
```

### 2. Subscript Access
```swift
Colors["brand-primary"]?.color
Colors["text-heading"]?.uiColor
```

### 3. String-Based Access
```swift
Colors.color(named: "brand-primary")?.color
Colors.swiftUIColor(named: "success-green")
Colors.uiColor(named: "error-red")
```

### 4. Semantic Grouping (Auto-Generated)
```swift
Colors.Brand.main.color          // If "app-brand-main" exists
Colors.Text.heading.color        // If "app-text-heading" exists
Colors.State.success.color       // If "app-state-success" exists
```

## 🎨 Supported JSON Structures

ColorKit automatically handles various JSON color formats:

### Simple Key-Value
```json
{
  "primary": "#007AFF",
  "secondary": "#5856D6"
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
                .foregroundColor(Colors.textHeading.color)
                .font(.title)
            
            Text("Subtitle") 
                .foregroundColor(Colors.textBody.color)
                .font(.body)
                
            Button("Action") {
                // Handle action
            }
            .foregroundColor(.white)
            .background(Colors.brandPrimary.color)
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundMain.color)
    }
}
```

### UIKit Example
```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundMain.uiColor
        
        let titleLabel = UILabel()
        titleLabel.textColor = Colors.textHeading.uiColor
        titleLabel.text = "Welcome"
        
        let button = UIButton()
        button.setTitleColor(.white, for: .normal) 
        button.backgroundColor = Colors.brandPrimary.uiColor
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
